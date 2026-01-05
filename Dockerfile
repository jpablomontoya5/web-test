FROM python:3.9-slim

WORKDIR /app

# Copiamos solo los requisitos primero para aprovechar la caché de capas de Docker
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app/main.py .

EXPOSE 8000

# Usamos ENTRYPOINT para definir el ejecutable
ENTRYPOINT ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]