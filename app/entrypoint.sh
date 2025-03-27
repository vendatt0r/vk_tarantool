#!/bin/bash

# Запускаем Tarantool в фоне
tarantool /app/init.lua &

# Ждем, пока Tarantool запустится
until nc -z 127.0.0.1 3301; do
  echo "Waiting for Tarantool..."
  sleep 2
done

# Запускаем FastAPI
uvicorn main:app --host 0.0.0.0 --port 8000
