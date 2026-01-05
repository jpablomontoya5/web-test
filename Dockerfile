FROM python:3.9-slim

WORKDIR /app

# Crear un usuario de sistema para evitar correr como root
RUN adduser --disabled-password --gecos "" appuser

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app/main.py .

# Cambiar la propiedad de los archivos al nuevo usuario
RUN chown -R appuser:appuser /app

# Cambiar al usuario no privilegiado
USER appuser

EXPOSE 8000

# Usamos ENTRYPOINT siguiendo las mejores prácticas evaluadas
ENTRYPOINT ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]