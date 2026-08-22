// Local passkey unlock. A WebAuthn platform credential (Face ID / Windows
// Hello / fingerprint) protects the same passphrase LocalWalletBridge already
// uses — there is no backend here, so this is a device-local convenience
// unlock, not a remote-verified FIDO2 identity.
(() => {
  const storageKey = 'remote_order_passkey_v1';
  const prfSalt = new TextEncoder().encode('remote-order-passkey-v1');

  function toBase64(buffer) {
    let binary = '';
    const bytes = new Uint8Array(buffer);
    for (let i = 0; i < bytes.length; i++) binary += String.fromCharCode(bytes[i]);
    return btoa(binary);
  }

  function fromBase64(base64) {
    const binary = atob(base64);
    const bytes = new Uint8Array(binary.length);
    for (let i = 0; i < binary.length; i++) bytes[i] = binary.charCodeAt(i);
    return bytes.buffer;
  }

  async function deriveKey(prfBytes) {
    const material = await crypto.subtle.importKey('raw', prfBytes, 'HKDF', false, ['deriveKey']);
    return crypto.subtle.deriveKey(
      {name: 'HKDF', hash: 'SHA-256', salt: new Uint8Array(0), info: new TextEncoder().encode('passphrase-wrap')},
      material,
      {name: 'AES-GCM', length: 256},
      false,
      ['encrypt', 'decrypt']
    );
  }

  window.PasskeyBridge = {
    hasPasskey() {
      return Boolean(localStorage.getItem(storageKey));
    },

    async enroll(passphrase) {
      if (!window.PublicKeyCredential) throw new Error('Passkeys are not supported in this browser');
      const created = await navigator.credentials.create({
        publicKey: {
          challenge: crypto.getRandomValues(new Uint8Array(32)),
          rp: {name: 'Store Manager'},
          user: {id: crypto.getRandomValues(new Uint8Array(16)), name: 'local-account', displayName: 'Local account'},
          pubKeyCredParams: [{alg: -7, type: 'public-key'}, {alg: -257, type: 'public-key'}],
          authenticatorSelection: {authenticatorAttachment: 'platform', residentKey: 'required', userVerification: 'required'},
          extensions: {prf: {eval: {first: prfSalt}}},
        },
      });
      if (!created) throw new Error('Passkey creation was canceled');
      let prfResult = created.getClientExtensionResults().prf?.results?.first;
      if (!prfResult) {
        const assertion = await navigator.credentials.get({
          publicKey: {
            challenge: crypto.getRandomValues(new Uint8Array(32)),
            allowCredentials: [{id: created.rawId, type: 'public-key'}],
            userVerification: 'required',
            extensions: {prf: {eval: {first: prfSalt}}},
          },
        });
        prfResult = assertion?.getClientExtensionResults().prf?.results?.first;
      }
      if (!prfResult) throw new Error('This device does not support passkey-based unlock (no PRF result)');
      const key = await deriveKey(prfResult);
      const iv = crypto.getRandomValues(new Uint8Array(12));
      const ciphertext = await crypto.subtle.encrypt({name: 'AES-GCM', iv}, key, new TextEncoder().encode(passphrase));
      localStorage.setItem(storageKey, JSON.stringify({
        credentialId: toBase64(created.rawId),
        iv: toBase64(iv),
        ciphertext: toBase64(ciphertext),
      }));
    },

    async unlock() {
      const stored = localStorage.getItem(storageKey);
      if (!stored) throw new Error('No passkey has been set up on this device');
      const {credentialId, iv, ciphertext} = JSON.parse(stored);
      const assertion = await navigator.credentials.get({
        publicKey: {
          challenge: crypto.getRandomValues(new Uint8Array(32)),
          allowCredentials: [{id: fromBase64(credentialId), type: 'public-key'}],
          userVerification: 'required',
          extensions: {prf: {eval: {first: prfSalt}}},
        },
      });
      const prfResult = assertion?.getClientExtensionResults().prf?.results?.first;
      if (!prfResult) throw new Error('Passkey unlock failed on this device');
      const key = await deriveKey(prfResult);
      const plaintext = await crypto.subtle.decrypt({name: 'AES-GCM', iv: fromBase64(iv)}, key, fromBase64(ciphertext));
      return new TextDecoder().decode(plaintext);
    },
  };
})();
