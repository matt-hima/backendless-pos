window.BackupBridge = {
  downloadJson(filename, jsonString) {
    this.downloadText(filename, jsonString, 'application/json');
  },
  downloadText(filename, content, mimeType) {
    const blob = new Blob([content], {type: mimeType});
    const url = URL.createObjectURL(blob);
    const link = document.createElement('a');
    link.href = url;
    link.download = filename;
    document.body.appendChild(link);
    link.click();
    link.remove();
    URL.revokeObjectURL(url);
  },
  pickJsonFile() {
    return new Promise((resolve, reject) => {
      const input = document.createElement('input');
      input.type = 'file';
      input.accept = 'application/json';
      input.style.display = 'none';
      input.onchange = () => {
        const file = input.files?.[0];
        input.remove();
        if (!file) { reject(new Error('No file selected')); return; }
        const reader = new FileReader();
        reader.onload = () => resolve(reader.result);
        reader.onerror = () => reject(reader.error);
        reader.readAsText(file);
      };
      document.body.appendChild(input);
      input.click();
    });
  }
};
