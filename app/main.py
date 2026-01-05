import logging
from fastapi import FastAPI
from prometheus_fastapi_instrumentator import Instrumentator

# Logs estructurados
logging.basicConfig(level=logging.INFO, format='{"time": "%(asctime)s", "level": "%(levelname)s", "msg": "%(message)s"}')
logger = logging.getLogger(__name__)

app = FastAPI()

# Observabilidad: Métricas para Prometheus
Instrumentator().instrument(app).expose(app)

@app.get("/")
def read_root():
    logger.info("Consulta a la raiz realizada")
    return {"status": "ok", "app": "DevOps-App"}

@app.get("/health")
def health_check():
    return {"status": "healthy"}