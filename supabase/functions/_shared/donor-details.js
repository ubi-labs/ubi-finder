export function validateDonorDetails(name = '', publicRecognition = false) {
  if (name === null) name = '';
  if (typeof name !== 'string' || name.trim().length > 100 || /[\u0000-\u001f\u007f]/.test(name)) throw new Error('Enter a name of at most 100 characters.');
  if (typeof publicRecognition !== 'boolean') throw new Error('Choose whether you want public recognition.');
  const donorName = name.trim();
  if (publicRecognition && !donorName) throw new Error('Enter the name you want shown before opting into public recognition.');
  return { donor_name: donorName || null, public_recognition: publicRecognition };
}
export function validateCryptoTransaction(chain, reference) {
  const hosts = { ethereum: ['etherscan.io'], celo: ['celoscan.io', 'celo.blockscout.com'] };
  if (!Object.hasOwn(hosts, chain) || typeof reference !== 'string') throw new Error('Choose Ethereum or Celo and paste your transaction hash or explorer link.');
  let hash = reference.trim();
  if (!/^0x[a-fA-F0-9]{64}$/.test(hash)) {
    let url;
    try { url = new URL(hash); } catch { throw new Error('Paste a valid transaction hash or explorer link.'); }
    const match = url.pathname.match(/^\/tx\/(0x[a-fA-F0-9]{64})\/?$/);
    if (url.protocol !== 'https:' || !hosts[chain].includes(url.hostname) || url.username || url.password || url.port || !match || url.search || url.hash) throw new Error('Use a transaction link from the selected network’s explorer.');
    hash = match[1];
  }
  return { crypto_chain: chain, transaction_hash: hash.toLowerCase() };
}
