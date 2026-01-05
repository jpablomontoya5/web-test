from fastapi import FastAPI
from fastapi.responses import HTMLResponse

app = FastAPI(title="Mi App DevOps")

@app.get("/", response_class=HTMLResponse)
def home():
    return """
    <html>
        <head><title>App Funcional</title></head>
        <body>
            <h1>Bienvenido a la API REST</h1>
            <p>Estado: <strong>Operacional</strong></p>
            <a href="/docs">Ver Documentación Interactiva</a>
        </body>
    </html>
    """

@app.get("/api/v1/saludo/{nombre}")
def saludo(nombre: str):
    return {"mensaje": f"Hola {nombre}, este es un microservicio funcional."}