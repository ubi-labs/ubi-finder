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
  await expect(page.getByRole('heading', { name: 'Thank you for supporting UBI Finder!' })).toBeVisible();
  await expect(page.getByText('Your $5.00 USD contribution is confirmed.')).toBeVisible();
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
