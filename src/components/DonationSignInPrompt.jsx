import React from 'react';
import { Link } from 'react-router-dom';
export default function DonationSignInPrompt() {
  return <aside className="rounded-xl border-2 border-emerald-700 bg-emerald-50 p-4 space-y-3">
    <p className="text-sm text-gray-700">You won’t receive donation credits unless you log in first. Guest donations cannot be credited to your account later.</p>
    <Link className="block rounded-lg bg-emerald-700 px-4 py-3 text-center font-semibold text-white hover:bg-emerald-800" to="/login?redirectTo=%2F%23support-this-project">Log in to receive donor credits</Link>
  </aside>;
}
