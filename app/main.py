import os
import tarantool
import logging
from fastapi import FastAPI, HTTPException

# Логирование
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

app = FastAPI()

# Подключение к Tarantool
TARANTOOL_HOST = os.getenv("TARANTOOL_HOST", "vktarantool-production.up.railway.app")
TARANTOOL_PORT = int(os.getenv("TARANTOOL_PORT", 3301))

try:
    conn = tarantool.Connection(TARANTOOL_HOST, TARANTOOL_PORT)
    logger.info(f"Connected to Tarantool at {TARANTOOL_HOST}:{TARANTOOL_PORT}")
except tarantool.error.NetworkError as e:
    logger.error(f"Failed to connect to Tarantool: {e}")
    raise RuntimeError(f"Failed to connect to Tarantool: {e}")

# API эндпоинты
@app.post("/kv")
def create_kv(item: dict):
    key = item.get("key")
    value = item.get("value")
    if not key or value is None:
        raise HTTPException(status_code=400, detail="Invalid body")

    if conn.space("kv").select(key):
        raise HTTPException(status_code=409, detail="Key already exists")

    conn.space("kv").insert((key, value))
    return {"message": "Created"}

@app.get("/kv/{key}")
def get_kv(key: str):
    result = conn.space("kv").select(key)
    if not result:
        raise HTTPException(status_code=404, detail="Not found")

    return {"key": key, "value": result[0][1]}

@app.put("/kv/{key}")
def update_kv(key: str, item: dict):
    value = item.get("value")
    if value is None:
        raise HTTPException(status_code=400, detail="Invalid body")

    if not conn.space("kv").select(key):
        raise HTTPException(status_code=404, detail="Not found")

    conn.space("kv").replace((key, value))
    return {"message": "Updated"}

@app.delete("/kv/{key}")
def delete_kv(key: str):
    if not conn.space("kv").select(key):
        raise HTTPException(status_code=404, detail="Not found")

    conn.space("kv").delete(key)
    return {"message": "Deleted"}
