import assert from 'node:assert/strict';
import { randomUUID } from 'node:crypto';
import { createClient } from '@supabase/supabase-js';
import { getLocalAdminClient } from '../acceptance/support/local-supabase.js';
const admin = getLocalAdminClient();
const anon = createClient(process.env.VITE_SUPABASE_URL,process.env.VITE_SUPABASE_ANON_KEY);
const ip = () => `2001:db8:${randomUUID().slice(0,4)}:${randomUUID().slice(0,4)}::1`;
const request = (source, fields={}) => admin.rpc('read_program_catalog',{p_ip:source,...fields});
const checked = result => { assert.equal(result.error,null,JSON.stringify(result.error)); return result.data; };
const users=[];
try {
  const page=checked(await request(ip()));
  assert.ok(page.programs.length>0 && page.programs.length<=20);
  const id=page.programs[0].program_id;
  for(const program of page.programs) {
    assert.ok(!('submitter_email' in program)); assert.ok(!('website' in program)); assert.ok(!('sources' in program));
    assert.ok(program.description.length<=300);
  }
  assert.equal((await request(ip(),{p_program_id:id})).error.code,'28000');
  assert.ok((await anon.rpc('read_program_catalog',{p_ip:ip()})).error);
  assert.ok((await anon.from('programs').select('*')).error);
  const source=ip();
  const concurrent=await Promise.all(Array.from({length:130},()=>request(source,{p_limit:1})));
  assert.equal(concurrent.filter(r=>!r.error).length,120,'concurrent IP quota must be atomic');
  for(const r of concurrent.filter(r=>r.error)) assert.match(r.error.message,/quota/);
  for(const confirmed of [true,false]) {
    const password=randomUUID()+'Aa1!';
    const created=await admin.auth.admin.createUser({email:`abuse-${randomUUID()}@example.test`,password,email_confirm:confirmed});
    assert.equal(created.error,null); const user=created.data.user; users.push(user.id);
    if(!confirmed) { assert.equal((await request(ip(),{p_user_id:user.id,p_program_id:id})).error.code,'28000'); continue; }
    const client=createClient(process.env.VITE_SUPABASE_URL,process.env.VITE_SUPABASE_ANON_KEY);
    assert.equal((await client.auth.signInWithPassword({email:user.email,password})).error,null);
    assert.deepEqual((await client.from('programs').select('*')).data,[],'verified users cannot directly extract all programs');
    assert.ok((await client.rpc('read_program_catalog',{p_ip:ip(),p_user_id:user.id})).error);
    const detailIp=ip();
    const details=await Promise.all(Array.from({length:35},()=>request(detailIp,{p_user_id:user.id,p_program_id:id})));
    const acceptedDetails=details.filter(r=>!r.error);
    assert.equal(acceptedDetails.length,30,'concurrent per-user detail quota must be atomic');
    for(const r of details.filter(r=>r.error)) assert.match(r.error.message,/quota/);
    assert.equal(acceptedDetails[0].data.program.program_id,id);
    assert.ok(!('submitter_email' in acceptedDetails[0].data.program));
  }
  console.log('Abuse controls: bounded public summaries, denied raw/RPC bypasses, verified details and concurrent quotas passed.');
} finally { for(const id of users) await admin.auth.admin.deleteUser(id); }
