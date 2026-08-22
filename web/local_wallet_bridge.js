// Browser-owned EVM wallet. The encrypted JSON keystore is the only value
// persisted in localStorage; the decrypted private key stays inside this JS call.
(() => {
  const storageKey = 'remote_order_encrypted_wallet_v1';

  async function openKeystore(password) {
    if (!window.ethers) throw new Error('Wallet library is still loading');
    const encrypted = localStorage.getItem(storageKey);
    if (!encrypted) return null;
    const wallet = await window.ethers.Wallet.fromEncryptedJson(encrypted, password);
    await window.WalletCryptoBridge.initLocalWallet(wallet.address, wallet.privateKey);
    return wallet.address;
  }

  window.LocalWalletBridge = {
    async hasWallet() { return Boolean(localStorage.getItem(storageKey)); },
    async create(password) {
      if (!password || password.length < 8) throw new Error('Use a passphrase of at least 8 characters');
      const wallet = window.ethers.Wallet.createRandom();
      const encrypted = await wallet.encrypt(password);
      localStorage.setItem(storageKey, encrypted);
      await window.WalletCryptoBridge.initLocalWallet(wallet.address, wallet.privateKey);
      return wallet.address;
    },
    async unlock(password) { return openKeystore(password); },
  };
})();
