// WebRTC transport using Google's public STUN server. Signaling remains
// copy/paste for now, so no external signaling service is required.
(() => {
  let peer;
  let channel;
  let messageHandler;
  let lastSeenMs = 0;
  const HEARTBEAT_MS = 5000;
  const STALE_AFTER_MS = 12000;
  const incoming = [];

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

  function onChannelMessage(raw) {
    lastSeenMs = Date.now();
    let envelope;
    try { envelope = JSON.parse(raw); } catch (_) { envelope = null; }
    if (envelope && envelope.type === 'ping') {
      if (channel?.readyState === 'open') channel.send(JSON.stringify({type: 'pong', ts: Date.now()}));
      return;
    }
    if (envelope && envelope.type === 'pong') return;
    incoming.push(raw);
    messageHandler?.(raw);
  }

  function wireChannel(nextChannel) {
    channel = nextChannel;
    channel.onmessage = (message) => onChannelMessage(message.data);
    channel.onopen = () => { lastSeenMs = Date.now(); };
  }

  function wirePeer(nextPeer) {
    peer = nextPeer;
    peer.onconnectionstatechange = () => window.dispatchEvent(new CustomEvent('webrtc-state', {detail: peer.connectionState}));
    peer.ondatachannel = (event) => wireChannel(event.channel);
  }

  function info(description, role) {
    return JSON.stringify({role, stun: 'stun:stun.l.google.com:19302', type: description.type, sdp: description.sdp});
  }

  setInterval(() => {
    if (channel?.readyState === 'open') channel.send(JSON.stringify({type: 'ping', ts: Date.now()}));
  }, HEARTBEAT_MS);

  window.WebRtcBridge = {
    async createOffer() {
      const nextPeer = new RTCPeerConnection(config);
      wirePeer(nextPeer);
      wireChannel(nextPeer.createDataChannel('order-sync'));
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
    drainMessages() {
      const drained = incoming.splice(0, incoming.length);
      return JSON.stringify(drained);
    },
    state() { return peer?.connectionState ?? 'new'; },
    status() {
      if (channel?.readyState !== 'open') return peer ? 'connecting' : 'disconnected';
      return (Date.now() - lastSeenMs) <= STALE_AFTER_MS ? 'connected' : 'stale';
    },
  };
})();
