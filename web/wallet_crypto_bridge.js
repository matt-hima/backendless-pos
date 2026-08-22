// Wallet-owned local encryption. The wallet signs a challenge; the signature
// derives an AES-GCM key that never leaves this browser tab.
(() => {
  let key;
  let owner;

  async function derive(address) {
    if (!window.ethereum) throw new Error('No injected wallet found');
    const challenge = `remote-order-owner:v1:${address.toLowerCase()}`;
    const signature = await window.ethereum.request({method: 'personal_sign', params: [challenge, address]});
    const material = await crypto.subtle.digest('SHA-256', new TextEncoder().encode(signature));
    key = await crypto.subtle.importKey('raw', material, 'AES-GCM', false, ['encrypt', 'decrypt']);
    owner = address.toLowerCase();
  }

  function encode(bytes) { return btoa(String.fromCharCode(...new Uint8Array(bytes))); }
  function decode(value) { return Uint8Array.from(atob(value), (char) => char.charCodeAt(0)); }

  window.WalletCryptoBridge = {
    async initWallet(address) { await derive(address); return owner; },
    async initLocalWallet(address, secret) {
      const material = await crypto.subtle.digest('SHA-256', new TextEncoder().encode(secret));
      key = await crypto.subtle.importKey('raw', material, 'AES-GCM', false, ['encrypt', 'decrypt']);
      owner = address.toLowerCase();
      return owner;
    },
    async encrypt(value) {
      if (!key) throw new Error('Wallet encryption is not initialized');
      const iv = crypto.getRandomValues(new Uint8Array(12));
      const encrypted = await crypto.subtle.encrypt({name: 'AES-GCM', iv}, key, new TextEncoder().encode(value));
      return JSON.stringify({version: 1, owner, iv: encode(iv), ciphertext: encode(encrypted)});
    },
    async decrypt(envelope) {
      if (!key) throw new Error('Wallet encryption is not initialized');
      const parsed = JSON.parse(envelope);
      if (parsed.owner !== owner) throw new Error('Wallet does not own this transaction');
      const plain = await crypto.subtle.decrypt({name: 'AES-GCM', iv: decode(parsed.iv)}, key, decode(parsed.ciphertext));
      return new TextDecoder().decode(plain);
    },
  };
})();
