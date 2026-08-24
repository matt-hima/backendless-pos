window.SecondDisplayBridge = {
  supported() {
    return typeof window.open === 'function';
  },
  open(url) {
    const display = window.open(
      url,
      'lilygo_second_display',
      'popup=yes,toolbar=no,location=no,status=no,menubar=no,resizable=yes',
    );
    if (display) display.focus();
    return !!display;
  },
};
