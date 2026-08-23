"""Mock LilyGO SD-card API for UTM-based development."""

from pathlib import Path
import os
import re
import secrets
import base64
import hashlib
import hmac
import json

import httpx
from fastapi import FastAPI, HTTPException, Request
from fastapi.responses import Response
from fastapi.middleware.cors import CORSMiddleware


SD_CARD = Path(__file__).resolve().parent.parent / "mock_sd_card"
SD_CARD.mkdir(parents=True, exist_ok=True)
REMOTE_WEB_ORIGIN = os.getenv("REMOTE_WEB_ORIGIN", "https://remote-order.web.app").rstrip("/")
DEVICE_SYNC_TOKEN = os.getenv("DEVICE_SYNC_TOKEN", "")
MAX_SYNC_BYTES = int(os.getenv("MAX_SYNC_BYTES", str(10 * 1024 * 1024)))
DEVICE_KEY_PATH = Path(os.getenv("DEVICE_KEY_PATH", str(SD_CARD / ".device_auth_key")))


def _device_key() -> bytes:
    if not DEVICE_KEY_PATH.exists():
        DEVICE_KEY_PATH.parent.mkdir(parents=True, exist_ok=True)
        DEVICE_KEY_PATH.write_bytes(secrets.token_bytes(32))
        try:
            DEVICE_KEY_PATH.chmod(0o600)
        except OSError:
            pass
    return DEVICE_KEY_PATH.read_bytes()
_HOP_BY_HOP_HEADERS = {
    "connection",
    "keep-alive",
    "proxy-authenticate",
    "proxy-authorization",
    "te",
    "trailer",
    "transfer-encoding",
    "upgrade",
}

app = FastAPI(title="Mock LilyGO Storage API", version="1.0.0")
app.add_middleware(
    CORSMiddleware,
    allow_origins=[],
    allow_credentials=False,
    allow_methods=["*"],
    allow_headers=["*"],
    expose_headers=["Content-Length", "Content-Type"],
)


def safe_filename(value: str | None) -> str:
    """Accept a filename from the client without allowing path traversal."""
    candidate = (value or "dolibarr_orders.parquet").strip().strip('"')
    candidate = Path(candidate).name
    candidate = re.sub(r"[^A-Za-z0-9_.-]", "_", candidate)
    if not candidate:
        raise HTTPException(status_code=400, detail="Invalid filename")
    return candidate


@app.get("/api/health")
async def health() -> dict[str, str]:
    return {"status": "ok", "service": "mock-lilygo"}


@app.post("/api/device/attest")
async def device_attest(request: Request) -> dict[str, object]:
    """Prove device-key possession without exporting the private key."""
    body = await request.json()
    nonce = str(body.get("nonce", ""))
    if len(nonce) < 16 or len(nonce) > 256:
        raise HTTPException(status_code=400, detail="Invalid attestation nonce")
    proof = hmac.new(_device_key(), nonce.encode(), hashlib.sha256).digest()
    return {
        "verified": True,
        "algorithm": "HMAC-SHA256",
        "proof": base64.urlsafe_b64encode(proof).decode().rstrip("="),
    }


@app.put("/api/storage/sync")
async def sync_storage(request: Request, filename: str | None = None) -> dict[str, object]:
    """Stream a binary upload to the simulated SD card."""
    if DEVICE_SYNC_TOKEN:
        supplied = request.headers.get("x-device-sync-token", "")
        if not secrets.compare_digest(supplied, DEVICE_SYNC_TOKEN):
            raise HTTPException(status_code=401, detail="Device sync authentication required")
    content_type = request.headers.get("content-type", "").split(";", 1)[0].lower()
    if content_type != "application/octet-stream":
        raise HTTPException(status_code=415, detail="Expected application/octet-stream")
    content_length = request.headers.get("content-length")
    if content_length and int(content_length) > MAX_SYNC_BYTES:
        raise HTTPException(status_code=413, detail="Upload exceeds device limit")
    content_disposition = request.headers.get("content-disposition", "")
    match = re.search(r'filename=(?:"([^"]+)"|([^;]+))', content_disposition)
    header_filename = match.group(1) or match.group(2) if match else None
    output = SD_CARD / safe_filename(filename or header_filename)
    byte_count = 0

    temporary = output.with_name(f".{output.name}.part")
    try:
        with temporary.open("wb") as destination:
            async for chunk in request.stream():
                if chunk:
                    byte_count += len(chunk)
                    if byte_count > MAX_SYNC_BYTES:
                        raise HTTPException(status_code=413, detail="Upload exceeds device limit")
                    destination.write(chunk)
        temporary.replace(output)
    except Exception:
        temporary.unlink(missing_ok=True)
        raise

    return {"status": "stored", "filename": output.name, "bytes": byte_count}


@app.api_route("/{path:path}", methods=["GET", "HEAD"])
async def proxy_remote_web(request: Request, path: str) -> Response:
    """Serve the hosted Flutter app while keeping device APIs on this emulator."""
    upstream_url = f"{REMOTE_WEB_ORIGIN}/{path}"
    if request.url.query:
        upstream_url = f"{upstream_url}?{request.url.query}"

    try:
        async with httpx.AsyncClient(follow_redirects=False, timeout=30.0) as client:
            upstream = await client.request(request.method, upstream_url)
    except httpx.HTTPError as error:
        return Response(
            content=f"Remote web proxy unavailable: {error}",
            status_code=502,
            media_type="text/plain",
        )

    headers = {
        name: value
        for name, value in upstream.headers.items()
        if name.lower() not in _HOP_BY_HOP_HEADERS
        and name.lower() not in {"content-length", "content-encoding"}
    }
    headers.update({
        "x-content-type-options": "nosniff",
        "referrer-policy": "no-referrer",
        "permissions-policy": "camera=(), microphone=(), geolocation=()",
    })
    location = headers.get("location")
    if location and location.startswith(REMOTE_WEB_ORIGIN):
        headers["location"] = location[len(REMOTE_WEB_ORIGIN):] or "/"

    return Response(
        content=b"" if request.method == "HEAD" else upstream.content,
        status_code=upstream.status_code,
        headers=headers,
    )
