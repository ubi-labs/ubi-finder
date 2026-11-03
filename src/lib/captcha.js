export function captchaOptions(token, localDevelopment = false) {
  if (localDevelopment) return {};
  if (typeof token !== 'string' || !token.trim()) throw new Error('Please complete the security verification.');
  return { captchaToken: token };
}
export const localCaptchaDevelopment = import.meta.env.DEV && import.meta.env.MODE === 'local-supabase';
