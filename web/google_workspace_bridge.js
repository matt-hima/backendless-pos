// Browser-only Google Drive/Sheets bridge. OAuth tokens stay in memory and
// are never written to IndexedDB or localStorage.
window.GoogleWorkspaceBridge = (() => {
  const DRIVE_SCOPE = 'https://www.googleapis.com/auth/drive.file';
  const SHEETS_SCOPE = 'https://www.googleapis.com/auth/spreadsheets';
  let tokenClient;
  let accessToken;

  function configured(clientId) {
    return Boolean(clientId && clientId.trim());
  }

  function loadIdentityScript() {
    if (window.google?.accounts?.oauth2) return Promise.resolve();
    return new Promise((resolve, reject) => {
      const existing = document.querySelector('script[data-google-identity]');
      if (existing) {
        existing.addEventListener('load', resolve, {once: true});
        existing.addEventListener('error', () => reject(new Error('Google sign-in library failed to load')), {once: true});
        return;
      }
      const script = document.createElement('script');
      script.src = 'https://accounts.google.com/gsi/client';
      script.async = true;
      script.defer = true;
      script.dataset.googleIdentity = 'true';
      script.onload = resolve;
      script.onerror = () => reject(new Error('Google sign-in library failed to load'));
      document.head.appendChild(script);
    });
  }

  async function authorize(clientId) {
    if (!configured(clientId)) throw new Error('Google OAuth client ID is not configured');
    await loadIdentityScript();
    if (accessToken) return accessToken;
    return new Promise((resolve, reject) => {
      tokenClient = google.accounts.oauth2.initTokenClient({
        client_id: clientId,
        scope: `${DRIVE_SCOPE} ${SHEETS_SCOPE}`,
        callback: (response) => {
          if (response.error) { reject(new Error(response.error)); return; }
          accessToken = response.access_token;
          resolve(accessToken);
        },
      });
      tokenClient.requestAccessToken({prompt: 'consent'});
    });
  }

  async function request(url, options = {}) {
    const response = await fetch(url, {
      ...options,
      headers: {'Authorization': `Bearer ${accessToken}`, ...(options.headers || {})},
    });
    if (!response.ok) {
      const body = await response.text();
      throw new Error(`Google API ${response.status}: ${body.slice(0, 240)}`);
    }
    return response;
  }

  function multipartBody(metadata, content) {
    const boundary = `lilygo_${Math.random().toString(16).slice(2)}`;
    const body = [
      `--${boundary}\r\nContent-Type: application/json; charset=UTF-8\r\n\r\n`,
      JSON.stringify(metadata),
      `\r\n--${boundary}\r\nContent-Type: application/json\r\n\r\n`,
      content,
      `\r\n--${boundary}--`,
    ].join('');
    return {body, contentType: `multipart/related; boundary=${boundary}`};
  }

  async function findFile(name, mimeType) {
    const q = `name = '${name.replaceAll("'", "\\'")}' and trashed = false and mimeType = '${mimeType}'`;
    const response = await request(`https://www.googleapis.com/drive/v3/files?q=${encodeURIComponent(q)}&pageSize=10&fields=files(id,name,modifiedTime)`, {headers: {}});
    const files = (await response.json()).files || [];
    files.sort((a, b) => String(b.modifiedTime).localeCompare(String(a.modifiedTime)));
    return files[0] || null;
  }

  async function saveDriveJson(clientId, filename, json) {
    await authorize(clientId);
    const mimeType = 'application/json';
    const existing = await findFile(filename, mimeType);
    const metadata = {name: filename, mimeType};
    const multipart = multipartBody(metadata, json);
    const url = existing
      ? `https://www.googleapis.com/upload/drive/v3/files/${existing.id}?uploadType=multipart`
      : 'https://www.googleapis.com/upload/drive/v3/files?uploadType=multipart';
    const response = await request(url, {
      method: existing ? 'PATCH' : 'POST',
      headers: {'Content-Type': multipart.contentType},
      body: multipart.body,
    });
    return (await response.json()).id;
  }

  async function restoreDriveJson(clientId, filename) {
    await authorize(clientId);
    const file = await findFile(filename, 'application/json');
    if (!file) throw new Error(`No ${filename} backup found in Google Drive`);
    return await (await request(`https://www.googleapis.com/drive/v3/files/${file.id}?alt=media`)).text();
  }

  function tabName(prefix, name) {
    const value = `${prefix}${name}`.replace(/[\\/?*\[\]:]/g, '_');
    return value.slice(0,  ninetyNine());
  }

  function ninetyNine() { return 99; }

  function rowsFor(value) {
    const rows = Array.isArray(value) ? value : [];
    const keys = [...new Set(rows.flatMap((row) => Object.keys(row || {})))];
    return [keys, ...rows.map((row) => keys.map((key) => row?.[key] ?? ''))];
  }

  function sheetsFromEnvelope(envelope) {
    const sheets = [];
    for (const [name, rows] of Object.entries(envelope.duckdb || {})) sheets.push({title: tabName('db__', name), rows});
    for (const [name, rows] of Object.entries(envelope.indexeddb || {})) sheets.push({title: tabName('idb__', name), rows});
    return sheets;
  }

  async function exportSheet(clientId, title, envelopeJson) {
    await authorize(clientId);
    const envelope = typeof envelopeJson === 'string' ? JSON.parse(envelopeJson) : envelopeJson;
    const create = await request('https://sheets.googleapis.com/v4/spreadsheets', {
      method: 'POST', headers: {'Content-Type': 'application/json'},
      body: JSON.stringify({properties: {title}}),
    });
    const spreadsheet = await create.json();
    const sheets = sheetsFromEnvelope(envelope);
    if (sheets.length) {
      await request(`https://sheets.googleapis.com/v4/spreadsheets/${spreadsheet.spreadsheetId}:batchUpdate`, {
        method: 'POST', headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({requests: [
          {updateSheetProperties: {properties: {sheetId: spreadsheet.sheets[0].properties.sheetId, title: sheets[0].title}, fields: 'title'}},
          ...sheets.slice(1).map((sheet) => ({addSheet: {properties: {title: sheet.title}}})),
        ]}),
      });
      for (let index = 0; index < sheets.length; index++) {
        const sheet = sheets[index];
        const range = `${encodeURIComponent(sheet.title)}!A1`;
        const values = rowsFor(sheet.rows);
        await request(`https://sheets.googleapis.com/v4/spreadsheets/${spreadsheet.spreadsheetId}/values/${range}?valueInputOption=RAW`, {
          method: 'PUT', headers: {'Content-Type': 'application/json'},
          body: JSON.stringify({range: `${sheet.title}!A1`, majorDimension: 'ROWS', values}),
        });
      }
    }
    return spreadsheet.spreadsheetUrl;
  }

  function parseCell(value) {
    if (value === '') return null;
    if (value === 'true') return true;
    if (value === 'false') return false;
    if (/^-?\d+(\.\d+)?$/.test(value)) return Number(value);
    return value;
  }

  async function importSheet(clientId, spreadsheetId) {
    await authorize(clientId);
    const metadata = await (await request(`https://sheets.googleapis.com/v4/spreadsheets/${spreadsheetId}?fields=sheets.properties`)).json();
    const envelope = {version: 1, exported_at: new Date().toISOString(), duckdb: {}, indexeddb: {}};
    for (const sheet of metadata.sheets || []) {
      const title = sheet.properties.title;
      const range = `${encodeURIComponent(title)}!A:ZZ`;
      const values = (await (await request(`https://sheets.googleapis.com/v4/spreadsheets/${spreadsheetId}/values/${range}`)).json()).values || [];
      if (!values.length) continue;
      const headers = values[0];
      const rows = values.slice(1).filter((row) => row.some((cell) => cell !== '')).map((row) => Object.fromEntries(headers.map((header, index) => [header, parseCell(row[index] ?? '')])));
      if (title.startsWith('db__')) envelope.duckdb[title.slice(4)] = rows;
      if (title.startsWith('idb__')) envelope.indexeddb[title.slice(5)] = rows;
    }
    return JSON.stringify(envelope);
  }

  return {configured, saveDriveJson, restoreDriveJson, exportSheet, importSheet};
})();
