# Используем базовый образ Ubuntu
FROM ubuntu:22.04

# Устанавливаем зависимости, включая netcat
RUN apt update && apt install -y tarantool python3 python3-pip netcat

# Устанавливаем зависимости Python
WORKDIR /app
COPY app/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Копируем код
COPY app/ .

# Копируем скрипт entrypoint
COPY app/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Запуск скрипта
CMD ["/entrypoint.sh"]

