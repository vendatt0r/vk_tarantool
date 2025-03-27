# Используем Ubuntu 22.04 в качестве базового образа
FROM ubuntu:22.04

# Устанавливаем необходимые зависимости
RUN apt update && apt install -y tarantool python3 python3-pip

# Устанавливаем зависимости Python
WORKDIR /app
COPY app/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Копируем весь код
COPY app/ .

# Создаем директории для Tarantool
RUN mkdir -p /app/tarantool_wal /app/tarantool_memtx /app/tarantool_vinyl

# Запуск Tarantool и FastAPI через bash -c
CMD bash -c "tarantool /app/init.lua & uvicorn main:app --host 0.0.0.0 --port 8000"
