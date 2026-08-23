(() => {
  window.DeviceQrBridge = {
    supported: () => 'BarcodeDetector' in window && !!navigator.mediaDevices?.getUserMedia,
    async scan() {
      if (!this.supported()) return '';
      const detector = new BarcodeDetector({formats: ['qr_code']});
      const video = document.createElement('video');
      const panel = document.createElement('div');
      panel.style = 'position:fixed;inset:8%;z-index:99999;background:#111;display:flex;align-items:center;justify-content:center;border:3px solid #fff;border-radius:12px;overflow:hidden';
      video.style = 'width:100%;height:100%;object-fit:contain';
      panel.appendChild(video); document.body.appendChild(panel);
      const stream = await navigator.mediaDevices.getUserMedia({video: {facingMode: 'environment'}});
      video.srcObject = stream; await video.play();
      try {
        for (let i = 0; i < 120; i++) {
          const codes = await detector.detect(video);
          if (codes.length && codes[0].rawValue) return codes[0].rawValue;
          await new Promise(resolve => setTimeout(resolve, 100));
        }
        return '';
      } finally {
        stream.getTracks().forEach(track => track.stop()); panel.remove();
      }
    }
  };
})();
