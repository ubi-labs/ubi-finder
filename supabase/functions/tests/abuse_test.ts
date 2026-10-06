import { handler } from '../program-catalog/index.ts';
Deno.test('catalog rejects authority-bearing input before connecting to database', async () => {
  const response=await handler(new Request('https://example.test',{method:'POST',body:JSON.stringify({ip:'forged',user_id:'forged'})}));
  if(response.status!==400) throw new Error('Expected 400');
});
Deno.test('catalog requires platform IP and fails closed', async () => {
  Deno.env.delete('ABUSE_LOCAL_DEVELOPMENT');
  const response=await handler(new Request('https://example.test',{method:'POST',headers:{'x-forwarded-for':'1.2.3.4'},body:'{}'}));
  if(response.status!==503) throw new Error('Expected 503');
});
Deno.test('catalog handles preflight, invalid JSON and size limits', async () => {
  for(const [method,body,status] of [['OPTIONS',null,200],['GET',null,405],['POST','{',400],['POST','x'.repeat(1025),413]] as const) {
    const response=await handler(new Request('https://example.test',{method,body}));
    if(response.status!==status) throw new Error('Unexpected status');
  }
});
Deno.test('forged identity fails authentication before catalog RPC', async () => {
  const original=globalThis.fetch;
  const oldUrl=Deno.env.get('SUPABASE_URL'); const oldKey=Deno.env.get('SUPABASE_SERVICE_ROLE_KEY');
  Deno.env.set('SUPABASE_URL','https://unit.test'); Deno.env.set('SUPABASE_SERVICE_ROLE_KEY','unit-server-key');
  const calls: string[]=[];
  globalThis.fetch=(input) => {
    const url=String(input); calls.push(url);
    return Promise.resolve(new Response(JSON.stringify({msg:'Invalid JWT'}),{status:401,headers:{'Content-Type':'application/json'}}));
  };
  try {
    const response=await handler(new Request('https://unit.test',{method:'POST',headers:{'cf-connecting-ip':'203.0.113.1',authorization:'Bearer forged'},body:'{"program_id":1}'}));
    if(response.status!==401 || calls.some(url=>url.includes('/rpc/'))) throw new Error('Forged authentication reached catalog');
  } finally {
    globalThis.fetch=original;
    if(oldUrl) Deno.env.set('SUPABASE_URL',oldUrl); else Deno.env.delete('SUPABASE_URL');
    if(oldKey) Deno.env.set('SUPABASE_SERVICE_ROLE_KEY',oldKey); else Deno.env.delete('SUPABASE_SERVICE_ROLE_KEY');
  }
});
