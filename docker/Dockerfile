# Используем базовый образ Ubuntu
FROM ubuntu:22.04

# Устанавливаем зависимости
RUN apt update && apt install -y tarantool python3 python3-pip

# Устанавливаем зависимости Python
WORKDIR /app
COPY ../requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Копируем код
COPY ../app .

# Запуск Tarantool и FastAPI
CMD tarantool /app/init.lua & uvicorn main:app --host 0.0.0.0 --port 8000
