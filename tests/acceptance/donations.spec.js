import { expect, test } from '@playwright/test';
import { acceptanceUser } from './support/local-supabase.js';
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
  await page.getByRole('button', { name: 'Continue as guest without credits' }).click();
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
    expect(route.request().headers().authorization || '').toBe('');
    expect(route.request().headers().apikey).toBeTruthy();
    return route.fulfill({ json: { url: 'https://checkout.stripe.com/c/pay/homepage-fixture' } });
  });
  await page.goto('/');
  for (const value of [5, 20, 100, 500]) await expect(page.locator(`label[for="amount-${value}"]`)).toBeVisible();
  await expect(page.locator('label[for="amount-1000"]')).toHaveCount(0);
  await page.locator('label[for="amount-20"]').click();
  await page.getByRole('button', { name: 'Donate $20 USD via Stripe', exact: true }).click();
  await page.getByRole('button', { name: 'Continue as guest without credits' }).click();
  await expect(page).toHaveURL('https://checkout.stripe.com/c/pay/homepage-fixture');
});


test('crypto alternative celebrates only after recording explicit self-confirmation', async ({ page }) => {
  await paymentResponse(page, null);
  let fail = true;
  let recorded;
  await page.route('**/functions/v1/submit-crypto-donation', (route) => {
    recorded = route.request().postDataJSON();
    expect(route.request().headers().authorization || '').toBe('');
    expect(route.request().headers().apikey).toBeTruthy();
    return route.fulfill({ status: fail ? 503 : 201, json: fail ? { message: 'unavailable' } : { donation_id: 'fixture', status: 'pending_review', account_credit_eligible: false } });
  });
  await page.goto('/');
  await page.getByRole('button', { name: 'Donate crypto instead', exact: true }).click();
  await expect(page.getByRole('dialog')).toContainText('ubifinder.eth');
  await expect(page.getByRole('dialog')).toContainText('give account credit within a week');
  await page.getByRole('dialog').getByLabel('Transaction hash or explorer link').fill('0x' + 'a'.repeat(64));
  await expect(page.getByText('Interac / E-Transfer / Bank')).toHaveCount(0);
  await expect(page.locator('canvas')).toHaveCount(0);
  await page.getByRole('button', { name: 'I have transferred crypto' }).click();
  await expect(page.getByRole('alert')).toContainText('Unable to record your transaction');
  await expect(page.locator('canvas')).toHaveCount(0);
  fail = false;
  await page.getByRole('button', { name: 'I have transferred crypto' }).click();
  await expect(page.getByRole('dialog')).toHaveCount(0);
  await expect(page.locator('canvas')).toHaveCount(1);
  expect(recorded).toMatchObject({ amount_usd: 100, crypto_chain: 'ethereum', transaction_reference: '0x' + 'a'.repeat(64), public_recognition: false });
});


test('guest sign-in prompt is prominent and private name is passed with explicit recognition consent', async ({ page }) => {
  await paymentResponse(page, null);
  let body;
  await page.route('**/functions/v1/create-stripe-checkout', (route) => {
    body = route.request().postDataJSON();
    return route.fulfill({ status: 503, json: {} });
  });
  await page.goto('/');
  await page.getByLabel('Your name (optional, confidential)', { exact: true }).fill('Private Supporter');
  await expect(page.getByRole('checkbox', { name: /publicly name me/ })).not.toBeChecked();
  await page.getByRole('button', { name: 'Donate $100 USD via Stripe', exact: true }).click();
  await expect(page.getByRole('dialog')).toContainText('You won’t receive donation credits unless you log in first.');
  await page.getByRole('button', { name: 'Continue as guest without credits' }).click();
  await expect(page.getByRole('alert')).toContainText('No payment was taken');
  expect(body).toMatchObject({ donor_name: 'Private Supporter', public_recognition: false });
  await expect(page.getByRole('dialog').getByRole('textbox')).toHaveCount(0);
  await expect(page.getByRole('dialog').getByRole('checkbox')).toHaveCount(0);
  await expect(page.getByRole('link', { name: 'Log in to receive donor credits' })).toHaveAttribute('href', '/login?redirectTo=%2F%23support-this-project');
  await page.getByRole('dialog').getByRole('button', { name: 'Close', exact: true }).click();
  await page.getByRole('checkbox', { name: /publicly name me/ }).check();
  await page.getByRole('button', { name: 'Donate $100 USD via Stripe', exact: true }).click();
  await page.getByRole('button', { name: 'Continue as guest without credits' }).click();
  await expect.poll(() => body?.public_recognition).toBe(true);
});

test('crypto references are validated and consent saved while review remains pending', async ({ page }) => {
  await paymentResponse(page, null);
  let submitted;
  await page.route('**/functions/v1/submit-crypto-donation', (route) => {
    submitted = route.request().postDataJSON();
    return route.fulfill({ json: { donation_id: 'fixture', status: 'pending_review', account_credit_eligible: false } });
  });
  await page.goto('/');
  await page.getByLabel('Your name (optional, confidential)', { exact: true }).fill('Crypto Supporter');
  await page.getByRole('checkbox', { name: /publicly name me/ }).check();
  await page.getByRole('button', { name: 'Donate crypto instead', exact: true }).click();
  const dialog = page.getByRole('dialog');

  await dialog.getByLabel('Transaction hash or explorer link').fill('https://evil.test/tx/0x' + 'a'.repeat(64));
  await page.getByRole('button', { name: 'I have transferred crypto' }).click();
  await expect(page.getByRole('alert')).toContainText('selected network');
  expect(submitted).toBeUndefined();
  await dialog.getByLabel('Transaction network').selectOption('celo');
  await dialog.getByLabel('Transaction hash or explorer link').fill('https://celoscan.io/tx/0x' + 'b'.repeat(64));
  await page.getByRole('button', { name: 'I have transferred crypto' }).click();
  await expect(dialog).toHaveCount(0);
  await expect(page.getByText(/Transaction saved. We’ll manually confirm it within a week/, { exact: false }).first()).toBeVisible();
  expect(submitted).toMatchObject({ donor_name: 'Crypto Supporter', public_recognition: true, crypto_chain: 'celo' });
});

test('guest verified payment receipt does not grant account credits', async ({ page }) => {
  await paymentResponse(page, { status: 'completed', amount_cents: 500, receipt_url: 'https://pay.stripe.com/receipts/fixture' }, 500);
  await page.goto('/donate/success?session_id=cs_test_guest');
  await expect(page.getByText('You donated as a guest, so no account credits were granted.', { exact: false })).toBeVisible();
  await expect(page.getByText('Your supporter access is active.', { exact: false })).toHaveCount(0);
});


test('prominent login returns to donating and signed-in Checkout offers account credit', async ({ page }) => {
  await paymentResponse(page, null);
  await page.route('**/functions/v1/create-stripe-checkout', (route) => route.fulfill({ status: 503, json: {} }));
  await page.goto('/');
  await page.getByRole('button', { name: 'Donate $100 USD via Stripe', exact: true }).click();
  await page.getByRole('link', { name: 'Log in to receive donor credits', exact: true }).click();
  await expect(page).toHaveURL(/\/login\?redirectTo=/);
  await page.getByLabel('Email address').fill(acceptanceUser.email);
  await page.getByLabel('Password').fill(acceptanceUser.password);
  await page.getByRole('button', { name: 'Sign in', exact: true }).click();
  await expect(page).toHaveURL(/\/#support-this-project$/);
  await expect(page.getByRole('link', { name: 'Log in to receive donor credits', exact: true })).toHaveCount(0);
  await page.getByRole('button', { name: 'Donate $100 USD via Stripe', exact: true }).click();
  await expect(page.getByText('Checkout is unavailable. No payment was taken. Please try again.', { exact: true }).first()).toBeVisible();
  await expect(page.getByRole('dialog')).toHaveCount(0);
  await expect(page.getByRole('button', { name: 'Continue as guest without credits' })).toHaveCount(0);
});
