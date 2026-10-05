import React from 'react';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
export default function DonationDetailsFields({ value, onChange, idPrefix = 'donation' }) {
  return <div className="space-y-3">
    <div className="space-y-1.5">
      <Label htmlFor={`${idPrefix}-name`}>Your name (optional, confidential)</Label>
      <Input id={`${idPrefix}-name`} maxLength={100} value={value.donor_name} onChange={(e) => onChange({ ...value, donor_name: e.target.value })} placeholder="Name for our private donor records" />
      <p className="text-xs text-gray-600">We keep this name private unless you choose public recognition below.</p>
    </div>
    <Label className="flex items-start gap-2 text-sm font-normal leading-relaxed" htmlFor={`${idPrefix}-recognition`}>
      <input id={`${idPrefix}-recognition`} type="checkbox" checked={value.public_recognition} onChange={(e) => onChange({ ...value, public_recognition: e.target.checked })} className="mt-1 accent-emerald-700" />
      <span>You may publicly name me on the sponsor leaderboard when it is built.</span>
    </Label>
  </div>;
}
