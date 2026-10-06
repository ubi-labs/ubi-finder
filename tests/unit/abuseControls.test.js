import { describe, expect, it, vi } from 'vitest';
import { catalogRequest, catalogIp, catalogError } from '../../supabase/functions/_shared/abuse-policy.js';
import { captchaOptions } from '@/lib/captcha';
vi.mock('@/lib/supabaseClient', () => ({ supabase: { auth: { getSession: vi.fn(async () => ({ data: { session: null } })) }, functions: { invoke: vi.fn() } } }));
import { supabase } from '@/lib/supabaseClient';
import { catalogPage, programSummaries, programDetail } from '@/lib/programCatalog';
describe('catalog boundary', () => {
  it('accepts bounded cursor pages and single IDs', () => {
    expect(catalogRequest({})).toEqual({ programId: null, after: 0, limit: 20 });
    expect(catalogRequest({ program_id: 5, limit: 1 }).programId).toBe(5);
  });
  it.each([{limit:21},{limit:0},{limit:'20'},{after:-1},{after:1.5},{program_id:'1'},{program_id:0},{program_id:2147483648},{after:2147483648},{user_id:'forged'},{ip:'forged'},[],null])('rejects malformed or authority-bearing input %j', body => expect(() => catalogRequest(body)).toThrow());
  it('ignores forged XFF and fails closed without gateway IP', () => {
    expect(() => catalogIp(new Headers({'x-forwarded-for':'1.2.3.4'}))).toThrow();
    expect(catalogIp(new Headers({'cf-connecting-ip':'2001:db8::1','x-forwarded-for':'forged'}))).toBe('2001:db8::1');
    expect(() => catalogIp(new Headers({'cf-connecting-ip':'not-an-ip'}))).toThrow();
    expect(catalogIp(new Headers(),true)).toBe('127.0.0.1');
  });
  it('distinguishes authentication, quota and infrastructure failures', () => {
    expect(catalogError('28000','secret').status).toBe(401);
    expect(catalogError('P0001','Request quota exceeded').status).toBe(429);
    expect(catalogError('XX000','secret').status).toBe(503);
    expect(catalogError('XX000','secret').error).not.toContain('secret');
  });
});
describe('CAPTCHA', () => {
  it('requires a token except in explicit local development', () => {
    expect(() => captchaOptions('')).toThrow();
    expect(() => captchaOptions('  ')).toThrow();
    expect(captchaOptions('token')).toEqual({ captchaToken:'token' });
    expect(captchaOptions('',true)).toEqual({});
  });
});
describe('program client', () => {
  it('propagates server denial rather than returning empty success', async () => {
    supabase.functions.invoke.mockResolvedValueOnce({ error: { context: { json: async () => ({ error:'Too many program requests.' }) } } });
    await expect(catalogPage()).rejects.toThrow('Too many program requests.');
  });
  it('only caches summaries, and fetches each detail through the quota boundary', async () => {
    supabase.functions.invoke.mockResolvedValueOnce({ data: { programs:[{program_id:1}], next:1 } }).mockResolvedValueOnce({ data: { programs:[],next:null } });
    expect(await programSummaries()).toEqual([{program_id:1}]);
    const calls=supabase.functions.invoke.mock.calls.length;
    await programSummaries();
    expect(supabase.functions.invoke.mock.calls.length).toBe(calls);
    supabase.functions.invoke.mockResolvedValue({ data: { program:{ program_id:1 } } });
    await programDetail(1); await programDetail(1);
    expect(supabase.functions.invoke.mock.calls.length).toBe(calls+2);
  });
});
