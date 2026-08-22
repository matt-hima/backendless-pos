// WebRTC transport using Google's public STUN server. Signaling remains
// copy/paste for now, so no external signaling service is required.
(() => {
  let peer;
  let channel;
  let messageHandler;

  const config = {iceServers: [{urls: 'stun:stun.l.google.com:19302'}]};

  function waitForIceGathering() {
    if (!peer || peer.iceGatheringState === 'complete') return Promise.resolve();
    return new Promise((resolve) => {
      const check = () => {
        if (peer.iceGatheringState === 'complete') {
          peer.removeEventListener('icegatheringstatechange', check);
          resolve();
        }
      };
      peer.addEventListener('icegatheringstatechange', check);
      setTimeout(resolve, 5000);
    });
  }

  function wirePeer(nextPeer) {
    peer = nextPeer;
    peer.onconnectionstatechange = () => window.dispatchEvent(new CustomEvent('webrtc-state', {detail: peer.connectionState}));
    peer.ondatachannel = (event) => {
      channel = event.channel;
      channel.onmessage = (message) => messageHandler?.(message.data);
    };
  }

  function info(description, role) {
    return JSON.stringify({role, stun: 'stun:stun.l.google.com:19302', type: description.type, sdp: description.sdp});
  }

  window.WebRtcBridge = {
    async createOffer() {
      const nextPeer = new RTCPeerConnection(config);
      wirePeer(nextPeer);
      channel = nextPeer.createDataChannel('order-sync');
      channel.onmessage = (message) => messageHandler?.(message.data);
      await nextPeer.setLocalDescription(await nextPeer.createOffer());
      await waitForIceGathering();
      return info(nextPeer.localDescription, 'offer');
    },
    async acceptOffer(offerJson) {
      const offer = JSON.parse(offerJson);
      const nextPeer = new RTCPeerConnection(config);
      wirePeer(nextPeer);
      await nextPeer.setRemoteDescription(offer);
      await nextPeer.setLocalDescription(await nextPeer.createAnswer());
      await waitForIceGathering();
      return info(nextPeer.localDescription, 'answer');
    },
    async applyAnswer(answerJson) {
      await peer.setRemoteDescription(JSON.parse(answerJson));
      return peer.connectionState;
    },
    send(message) {
      if (channel?.readyState !== 'open') throw new Error('WebRTC data channel is not open');
      channel.send(message);
    },
    onMessage(callback) { messageHandler = callback; },
    state() { return peer?.connectionState ?? 'new'; },
  };
})();

