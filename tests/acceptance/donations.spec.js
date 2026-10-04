import { expect, test } from '@playwright/test';
async function paymentResponse(page, payment, total = 0) {
  await page.route('**/functions/v1/donation-status', (route) => route.fulfill({ json: { user_id: null, total_cents: total, payment } }));
}
test('forged amount and missing session cannot grant supporter access', async ({ page }) => {
  await paymentResponse(page, null);
  await page.goto('/donate/success?amount=50000');
  await expect(page.getByRole('heading', { name: 'Unable to verify payment' })).toBeVisible();
  await expect(page.getByText('Your $50000')).toHaveCount(0);
});
test('cancellation and failed payments show no confirmation or receipt', async ({ page }) => {
  await paymentResponse(page, { status: 'failed', amount_cents: 500 });
  await page.goto('/donate/success?cancelled=1');
  await expect(page.getByRole('heading', { name: 'Checkout cancelled' })).toBeVisible();
  await page.goto('/donate/success?session_id=cs_test_failed');
  await expect(page.getByRole('heading', { name: 'Payment not completed' })).toBeVisible();
  await expect(page.getByRole('link', { name: 'View Stripe receipt' })).toHaveCount(0);
});
test('delayed webhook stays pending until verified state and then displays server amount and receipt', async ({ page }) => {
  let confirmations = 0;
  await page.route('**/functions/v1/donation-status', (route) => {
    const body = route.request().postDataJSON();
    const ready = body.session_id && ++confirmations > 1;
    return route.fulfill({ json: { user_id: null, total_cents: ready ? 500 : 0, payment: body.session_id ? { status: ready ? 'completed' : 'pending', amount_cents: 500, receipt_url: ready ? 'https://pay.stripe.com/receipts/fixture' : null } : null } });
  });
  await page.goto('/donate/success?session_id=cs_test_delayed&amount=99999');
  await expect(page.getByRole('heading', { name: 'Confirming your payment' })).toBeVisible();
  await expect(page.locator('canvas')).toHaveCount(0);
  await expect(page.getByRole('heading', { name: 'Thank you for supporting UBI Finder!' })).toBeVisible();
  await expect(page.getByText('Your $5.00 USD contribution is confirmed.')).toBeVisible();
  await expect(page.locator('canvas')).toHaveCount(1);
  await expect(page.getByRole('link', { name: 'View Stripe receipt' })).toHaveAttribute('href', 'https://pay.stripe.com/receipts/fixture');
  await page.reload();
  await expect(page.getByText('Your $5.00 USD contribution is confirmed.')).toBeVisible();
});
test('untrusted receipt URLs are omitted', async ({ page }) => {
  await paymentResponse(page, { status: 'completed', amount_cents: 500, receipt_url: 'https://evil.test' }, 500);
  await page.goto('/donate/success?session_id=cs_test_receipt');
  await expect(page.getByRole('heading', { name: 'Thank you for supporting UBI Finder!' })).toBeVisible();
  await expect(page.getByRole('link', { name: 'View Stripe receipt' })).toHaveCount(0);
});


test('homepage support panel opens Stripe checkout and fails closed when checkout is unavailable', async ({ page }) => {
  await paymentResponse(page, null);
  let checkoutBody;
  let legacyWrites = 0;
  await page.route('**/rest/v1/support_donations*', (route) => { legacyWrites++; return route.fulfill({ json: [] }); });
  await page.route('**/functions/v1/create-stripe-checkout', (route) => {
    checkoutBody = route.request().postDataJSON();
    return route.fulfill({ status: 503, json: { error: 'unavailable' } });
  });
  await page.goto('/');
  await page.getByLabel('Or enter a custom amount').fill('12.34');
  await page.getByRole('button', { name: 'Donate $12.34 USD via Stripe', exact: true }).click();
  await expect(page.getByRole('dialog')).toContainText('Contribute $12.34 USD');
  await expect(page.getByRole('button', { name: 'I have eTransferred' })).toHaveCount(0);
  await page.getByRole('button', { name: 'Continue to secure checkout' }).click();
  await expect(page.getByRole('alert')).toContainText('No payment was taken');
  await expect(page.locator('canvas')).toHaveCount(0);
  expect(checkoutBody.amount_usd).toBe(12.34);
  expect(checkoutBody.guest_token).toMatch(/^[a-f0-9]{64}$/);
  expect(checkoutBody.return_url).toBe(new URL(page.url()).origin);
  expect(legacyWrites).toBe(0);
});

test('homepage custom donation rejects fractional cents before checkout', async ({ page }) => {
  await paymentResponse(page, null);
  let checkoutRequests = 0;
  await page.route('**/functions/v1/create-stripe-checkout', (route) => { checkoutRequests++; return route.fulfill({ status: 503, json: {} }); });
  await page.goto('/');
  await page.getByLabel('Or enter a custom amount').fill('1.001');
  await page.getByRole('button', { name: 'Donate $1.001 USD via Stripe', exact: true }).click();
  await expect(page.getByText('Enter an amount with at most two decimal places.', { exact: true })).toBeVisible();
  await expect(page.getByRole('dialog')).toHaveCount(0);
  expect(checkoutRequests).toBe(0);
});


test('homepage preset donation redirects to the Stripe-hosted URL', async ({ page }) => {
  await paymentResponse(page, null);
  await page.route('https://checkout.stripe.com/c/pay/homepage-fixture', (route) => route.fulfill({ contentType: 'text/html', body: '<h1>Stripe checkout fixture</h1>' }));
  await page.route('**/functions/v1/create-stripe-checkout', (route) => {
    expect(route.request().postDataJSON().amount_usd).toBe(20);
    return route.fulfill({ json: { url: 'https://checkout.stripe.com/c/pay/homepage-fixture' } });
  });
  await page.goto('/');
  await page.locator('label[for="amount-20"]').click();
  await page.getByRole('button', { name: 'Donate $20 USD via Stripe', exact: true }).click();
  await page.getByRole('button', { name: 'Continue to secure checkout' }).click();
  await expect(page).toHaveURL('https://checkout.stripe.com/c/pay/homepage-fixture');
});


test('crypto alternative celebrates only after recording explicit self-confirmation', async ({ page }) => {
  await paymentResponse(page, null);
  let fail = true;
  let recorded;
  await page.route('**/rest/v1/support_donations*', (route) => {
    recorded = route.request().postDataJSON();
    return route.fulfill({ status: fail ? 503 : 201, json: fail ? { message: 'unavailable' } : {} });
  });
  await page.goto('/');
  await page.getByRole('button', { name: 'Donate crypto instead', exact: true }).click();
  await expect(page.getByRole('dialog')).toContainText('ubifinder.eth');
  await expect(page.getByRole('dialog')).toContainText('does not grant Stripe-verified supporter access');
  await expect(page.getByText('Interac / E-Transfer / Bank')).toHaveCount(0);
  await expect(page.locator('canvas')).toHaveCount(0);
  await page.getByRole('button', { name: 'I have transferred crypto' }).click();
  await expect(page.getByRole('alert')).toContainText('Unable to record your confirmation');
  await expect(page.locator('canvas')).toHaveCount(0);
  fail = false;
  await page.getByRole('button', { name: 'I have transferred crypto' }).click();
  await expect(page.getByRole('dialog')).toHaveCount(0);
  await expect(page.locator('canvas')).toHaveCount(1);
  expect(recorded).toMatchObject({ amount_usd: 100, payment_method: 'crypto', status: 'pledged' });
});
