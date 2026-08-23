# LilyGO ERP offline-first simulator

This project simulates the full development loop:

`mock WebRTC order → DuckDB-Wasm → Parquet export → HTTP PUT → UTM mock SD card`

The LilyGO itself is represented by a FastAPI server. It only stores the uploaded binary file; all relational processing stays in the Flutter browser client.

## 1. Start the simulated LilyGO in UTM

Create or boot an Ubuntu/Debian VM in UTM. In the VM, copy the `mock_server/` directory (or copy the entire project), then run:

```bash
cd lilygo-erp
python3 -m venv .venv
source .venv/bin/activate
python -m pip install -r mock_server/requirements.txt
python -m uvicorn mock_server.main:app --host 0.0.0.0 --port 8000
```

For a protected device sync endpoint, set a long random token before starting the emulator:

```bash
export DEVICE_SYNC_TOKEN="replace-with-a-long-random-token"
python -m uvicorn mock_server.main:app --host 0.0.0.0 --port 8000
```

When using a local Flutter build, pass the same token with `--dart-define=DEVICE_SYNC_TOKEN=...`. For network exposure, terminate HTTPS in front of the emulator or start Uvicorn with an appropriate certificate and private key; do not expose plain HTTP beyond the trusted UTM/LAN segment.

UTM networking must allow the host to reach the VM. With shared/NAT networking, find the VM address with:

```bash
ip -4 addr
```

Verify from the host browser or terminal that `http://VM_IP:8000/api/health` returns `{"status":"ok",...}`. Opening `http://VM_IP:8000/` now reverse-proxies the hosted Flutter app from `https://remote-order.web.app`; uploaded files still appear in `mock_sd_card/dolibarr_orders.parquet` inside the VM.

## 2. Configure the Flutter client

On the host, install Flutter 3.22+ and enable web support. From this project directory:

```bash
flutter pub get
flutter config --enable-web
```

The file `web/duckdb_bridge.js` loads DuckDB-Wasm from jsDelivr and exposes a small browser API used by `DatabaseService`. `web/index.html` loads that bridge before Flutter. An internet connection is needed the first time the DuckDB-Wasm JavaScript and worker assets are fetched; production deployments should self-host and pin those assets.

Start the app with the VM address when using the local Flutter build:

```bash
flutter run -d chrome --dart-define=API_URL=http://VM_IP:8000
```

The default address is `http://192.168.64.3:8000`, so the define is optional if that is your VM address. If Chrome blocks the request, check that the FastAPI process is bound to `0.0.0.0`, the VM networking mode exposes port 8000, and the app is using the VM IP rather than `localhost`.

## 3. Test the flow

The mock radio emits one order every 10 seconds. Each order contains a third party, contact, and order. The client:

1. Creates the three Dolibarr-style tables in DuckDB-Wasm.
2. Upserts the payload into `llx_societe`, `llx_socpeople`, and `llx_commande`.
3. Exports a joined order view as `dolibarr_orders.parquet` in DuckDB-Wasm's virtual filesystem.
4. Reads the file into `Uint8List` and sends it to `PUT /api/storage/sync`.

The Flutter status card shows the latest order, Parquet byte count, and row count. The FastAPI console shows the request, and the VM's `mock_sd_card/` directory contains the resulting file.

## Dolibarr workspace UI

The Flutter client includes four tabs:

- **Overview**: offline status and counts for orders, third parties, and products.
- **Third parties**: reads `llx_societe` customer data.
- **Products**: reads `llx_product` and supports creating/editing reference, label, price HT, VAT, and stock directly in DuckDB-Wasm.
- **Orders**: reads `llx_commande` joined with the customer name.

The product schema is:

```sql
llx_product(rowid, ref, label, price, tva_tx, stock, updated_at)
```

Mock order payloads now include a product and upsert it into `llx_product`. Product edits are local-first; the next Parquet sync includes the current order export.

The Products tab's **Load 鼎泰豐 menu** action uses the same product-save function as **New product**. It upserts the predefined menu items (小籠包、燒賣、鍋貼、蒸餃、蛋炒飯、麵、湯、青菜與甜點). Every mock order randomly selects 2–3 different menu products, assigns each a quantity from 1–3, calculates the order total, and writes each relationship to `llx_commandedet`. The Orders tab displays every line separately.

Orders use `llx_commande.fk_statut` with Dolibarr-style states: Draft, Validated, Accepted, In process, Delivered, and Canceled. Each order card has an operation menu for changing its transaction state without horizontal scrolling.

## API contract

```http
PUT /api/storage/sync?filename=dolibarr_orders.parquet
Content-Type: application/octet-stream

<raw Parquet bytes>
```

The server streams the body directly to disk and sanitizes the filename to prevent path traversal. CORS allows all origins, methods, and headers for local development.

## Firebase Hosting

The Flutter client is deployed as a client-side SPA. The root route is the client landing page and `/portal` opens the Dolibarr order portal. Firebase rewrites both paths to `index.html`, so browser refresh and deep links work.

```bash
flutter build web --release --dart-define=API_URL=http://192.168.64.3:8000 --base-href=/
firebase deploy --only hosting:remote-order --project glassnframeshop-69ed3
```

Live site: [remote-order.web.app](https://remote-order.web.app/) · Portal: [remote-order.web.app/portal](https://remote-order.web.app/portal)

The root client uses `web/indexeddb_bridge.js` and stores client-side Dolibarr-shaped records in IndexedDB: `llx_product`, `llx_societe`, `llx_commande`, and `llx_commandedet`. Customer ordering requires wallet login. The connected wallet is upserted as the local `llx_societe` third party, and its address, code, and wallet identity are included in the encrypted transaction payload. Transaction statistics filter by both channel and the connected wallet, so a client only processes its own orders. The portal continues to use DuckDB-Wasm for relational processing and Parquet export.

## Channel links and FQDN deployment

The client accepts a channel query parameter:

```text
https://remote-order.web.app/?channel=ABC123
```

The portal's **Create channel** action generates a code and shareable URL. Orders saved from that URL carry the channel code in their IndexedDB transaction record, keeping separate tables, rooms, or ordering sessions logically isolated.

The hosted FQDN can save orders to browser IndexedDB, but it cannot directly write to a private ESP32/UTM IP from public HTTPS. For ESP32 sync, expose a secure HTTPS relay/API or run the client on the same reachable LAN; do not point a production hosted page at an unreachable private address.

The UTM emulator provides that same-LAN path without rebuilding the web app: browse to `http://VM_IP:8000/`. GET/HEAD requests are proxied to `remote-order.web.app`, while `PUT /api/storage/sync` remains local and writes to the emulator's SD-card directory. Set `REMOTE_WEB_ORIGIN` if the hosted site changes.

When the device is reachable, the portal calls `POST /api/device/attest` with a one-time nonce before accepting a WebRTC order. The emulator keeps its HMAC device key in `mock_sd_card/.device_auth_key` and returns only a proof; the key is never sent to the portal. If the device is offline, the portal remains usable and queues its local DuckDB state for a later sync.

## WebRTC portal connection

The portal WebRTC tab uses `stun:stun.l.google.com:19302` and provides editable offer/answer JSON fields. The portal clicks **Generate portal offer**, the remote client accepts that offer and returns an answer, and the portal applies the answer. This is manual signaling for development; Google STUN discovers routes but does not relay storage uploads or replace a signaling/relay service.

## Wallet-owned client transactions

Both the customer page and `/portal` support an injected EIP-1193 wallet through `flutter_web3` or a browser-local wallet generated by the app. Local wallet creation asks for a passphrase, generates an EVM account with ethers, and stores only its encrypted JSON keystore in `localStorage`; the plaintext private key is never returned to Dart or persisted. A wallet-specific challenge/key is initialized once per browser session and AES-GCM protects the order payload. IndexedDB stores only the encrypted order envelope plus public channel/wallet filter fields. DuckDB-Wasm is initialized only for `/portal`; the root ordering page uses IndexedDB only.

After login, **Remember info** lets the user optionally save a phone number and birthday. Those fields are encrypted with the wallet key before browser storage and are never written as plaintext Dolibarr contact fields. Users who need stronger recovery can write down the generated recovery phrase and restore the wallet after browser storage is lost.
