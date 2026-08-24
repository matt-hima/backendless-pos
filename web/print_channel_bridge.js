window.PrintChannelBridge = {
  _port: null,
  open(html) {
    const existing = document.getElementById('__channel_print_frame');
    if (existing) existing.remove();
    const frame = document.createElement('iframe');
    frame.id = '__channel_print_frame';
    frame.style.position = 'fixed';
    frame.style.right = '0';
    frame.style.bottom = '0';
    frame.style.width = '0';
    frame.style.height = '0';
    frame.style.border = '0';
    document.body.appendChild(frame);
    frame.contentDocument.open();
    frame.contentDocument.write(html);
    frame.contentDocument.close();
    return true;
  },
  thermalSupported() {
    return 'serial' in navigator;
  },
  async printThermal(code, link) {
    if (!this.thermalSupported()) return false;
    if (!this._port) {
      this._port = await navigator.serial.requestPort();
      await this._port.open({baudRate: 9600});
    }
    const writer = this._port.writable.getWriter();
    const text = new TextEncoder();
    const bytes = [];
    const add = (...values) => bytes.push(...values);
    const writeText = value => add(...text.encode(value));
    const qrData = text.encode(link);
    const qrLength = qrData.length + 3;
    add(0x1b, 0x40, 0x1b, 0x61, 0x01);
    writeText(`Channel ${code}\n\n`);
    add(0x1d, 0x28, 0x6b, 0x04, 0x00, 0x31, 0x43, 0x06);
    add(0x1d, 0x28, 0x6b, qrLength & 0xff, (qrLength >> 8) & 0xff, 0x31, 0x50, 0x30, ...qrData);
    add(0x1d, 0x28, 0x6b, 0x03, 0x00, 0x31, 0x51, 0x30);
    add(0x1b, 0x61, 0x00);
    writeText(`\n${link}\n\n\n`);
    add(0x1d, 0x56, 0x00);
    await writer.write(new Uint8Array(bytes));
    writer.releaseLock();
    return true;
  },
};
