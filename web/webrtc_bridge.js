// PeerJS transport. PeerJS brokers the initial WebRTC handshake; application
// data continues directly over WebRTC data channels.
(() => {
  let peer;
  let portalMode = false;
  let portalPeerId = '';
  let peerReady = false;
  let lastSeenMs = 0;
  const connections = new Map();
  const pending = new Map();
  const incoming = [];
  const HEARTBEAT_MS = 5000;
  const STALE_AFTER_MS = 12000;
  const PEER_OPTIONS = {
    config: {
      iceServers: [
        { urls: 'stun:stun.l.google.com:19302' },
      ],
    },
  };

  function peerIdForChannel(channel) {
    const safe = (channel || 'default').replace(/[^a-zA-Z0-9_-]/g, '_');
    return `lilygo-merchant-${safe}`;
  }

  function queueMessage(connection, raw) {
    lastSeenMs = Date.now();
    let envelope;
    if (typeof raw === 'string') {
      try { envelope = JSON.parse(raw); } catch (_) { envelope = null; }
    } else if (raw && typeof raw === 'object') {
      envelope = raw;
    }
    if (envelope && envelope.type === 'ping') {
      if (connection.open) connection.send(JSON.stringify({type: 'pong', ts: Date.now()}));
      return;
    }
    if (envelope && envelope.type === 'pong') return;
    if (envelope && typeof envelope === 'object') envelope.__peer_id = connection.peer;
    incoming.push(JSON.stringify(envelope ?? {type: 'raw', payload: raw}));
  }

  function registerConnection(connection) {
    connections.set(connection.peer, connection);
    pending.set(connection.peer, pending.get(connection.peer) || []);
    connection.on('open', () => {
      lastSeenMs = Date.now();
      if (!portalMode) connection.send(JSON.stringify({type: 'client_ready'}));
      const queued = pending.get(connection.peer) || [];
      pending.set(connection.peer, []);
      for (const message of queued) connection.send(message);
    });
    connection.on('data', (raw) => queueMessage(connection, raw));
    connection.on('close', () => { connections.delete(connection.peer); pending.delete(connection.peer); });
    connection.on('error', () => { connections.delete(connection.peer); pending.delete(connection.peer); });
  }

  function connectToPortal() {
    if (portalMode || !peer || !portalPeerId) return;
    const connection = peer.connect(portalPeerId, {reliable: true, label: 'merchant-room'});
    registerConnection(connection);
  }

  setInterval(() => {
    for (const connection of connections.values()) {
      if (connection.open) connection.send(JSON.stringify({type: 'ping', ts: Date.now()}));
    }
  }, HEARTBEAT_MS);

  window.WebRtcBridge = {
    async initialize(isPortal, channel) {
      portalMode = Boolean(isPortal);
      portalPeerId = peerIdForChannel(channel);
      if (peer) peer.destroy();
      peerReady = false;
      peer = portalMode
        ? new Peer(portalPeerId, PEER_OPTIONS)
        : new Peer(PEER_OPTIONS);
      await new Promise((resolve, reject) => {
        peer.on('open', () => { peerReady = true; lastSeenMs = Date.now(); resolve(); });
        peer.on('error', reject);
        peer.on('connection', registerConnection);
      });
      if (!portalMode) connectToPortal();
    },
    // Retained for compatibility with the old manual-signaling UI.
    async createOffer() { throw new Error('PeerJS connects through the merchant channel'); },
    async acceptOffer() { throw new Error('PeerJS connects through the merchant channel'); },
    async applyAnswer() { throw new Error('PeerJS connects through the merchant channel'); },
    send(message) {
      const envelope = JSON.parse(message);
      const target = envelope.__target_peer_id;
      delete envelope.__target_peer_id;
      const encoded = JSON.stringify(envelope);
      if (target) {
        const connection = connections.get(target);
        if (connection?.open) connection.send(encoded);
        else if (connection) pending.get(target).push(encoded);
        return;
      }
      for (const connection of connections.values()) {
        if (connection.open) connection.send(encoded);
        else pending.get(connection.peer).push(encoded);
      }
    },
    state() {
      return connections.size > 0 ? 'connected' : (peer ? 'connecting' : 'new');
    },
    status() {
      const open = [...connections.values()].some((connection) => connection.open);
      if (!peer) return 'disconnected';
      if (!peerReady) return 'connecting';
      if (!open) return portalMode ? 'open' : 'connecting';
      return (Date.now() - lastSeenMs) <= STALE_AFTER_MS ? 'connected' : 'stale';
    },
    connectionCount() {
      return [...connections.values()].filter((connection) => connection.open).length;
    },
    drainMessages() {
      const drained = incoming.splice(0, incoming.length);
      return JSON.stringify(drained);
    },
  };
})();
