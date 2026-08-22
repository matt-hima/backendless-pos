window.PrintChannelBridge = {
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
  }
};
