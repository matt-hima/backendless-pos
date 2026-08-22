"""Mock LilyGO SD-card API for UTM-based development."""

from pathlib import Path
import re

from fastapi import FastAPI, HTTPException, Request
from fastapi.middleware.cors import CORSMiddleware


SD_CARD = Path(__file__).resolve().parent.parent / "mock_sd_card"
SD_CARD.mkdir(parents=True, exist_ok=True)

app = FastAPI(title="Mock LilyGO Storage API", version="1.0.0")
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
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


@app.put("/api/storage/sync")
async def sync_storage(request: Request, filename: str | None = None) -> dict[str, object]:
    """Stream a binary upload to the simulated SD card."""
    content_disposition = request.headers.get("content-disposition", "")
    match = re.search(r'filename=(?:"([^"]+)"|([^;]+))', content_disposition)
    header_filename = match.group(1) or match.group(2) if match else None
    output = SD_CARD / safe_filename(filename or header_filename)
    byte_count = 0

    with output.open("wb") as destination:
        async for chunk in request.stream():
            if chunk:
                destination.write(chunk)
                byte_count += len(chunk)

    return {"status": "stored", "filename": output.name, "bytes": byte_count}

