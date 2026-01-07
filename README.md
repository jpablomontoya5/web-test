# Proyecto Web-Test: Pipeline DevSecOps & GitOps

Este repositorio contiene una solución completa de entrega continua para una aplicación Python (FastAPI), integrando prácticas avanzadas de seguridad, despliegue automatizado en Kubernetes mediante ArgoCD y un stack profesional de Observabilidad. 🛠

## Tecnologías Utilizadas

| Categoría     | Herramienta / Lenguaje |
|--------------:|------------------------|
| Lenguaje      | Python (FastAPI)       |
| CI/CD         | GitHub Actions         |
| Seguridad (SAST) | Semgrep             |
| SCA           | Trivy                  |
| Infraestructura | Kubernetes (Kind), Helm |
| GitOps        | ArgoCD                 |
| Observabilidad| Prometheus & Grafana   |

---

## 1. Arquitectura del Flujo End-to-End

El flujo de trabajo sigue un modelo de Automatización Total:

- CI (Integración Continua): Al realizar un push, GitHub Actions ejecuta pruebas unitarias y escanea el código con Semgrep y Trivy para detectar vulnerabilidades.
- Build & Security: Se construye la imagen Docker segura y se sube al registro.
- GitOps Trigger: El pipeline actualiza automáticamente el tag de la imagen en `charts/my-app/values.yaml` y realiza un commit.
- CD (Despliegue Continuo): ArgoCD detecta el cambio en Git y sincroniza el estado del clúster local (Kind), desplegando la nueva versión automáticamente.

---


## 2. Implementación de Seguridad (DevSecOps)

Se aplicó el principio de "Least Privilege" y "Hardening" de contenedores tras los hallazgos de seguridad (SAST):

- 🔒 Sistema de archivos de solo lectura: Configuración de `readOnlyRootFilesystem: true` para mitigar ataques de persistencia.
- 👤 No privilegios: Los contenedores corren como usuarios no-root (`runAsNonRoot: true`, UID `1000`).
- 🛡️ Análisis Automático: Cada commit es bloqueado si no cumple con las reglas de seguridad de Kubernetes definidas en el pipeline.

---

## Comparativa: ¿Por qué Semgrep?

A continuación, se comparan las ventajas de la herramienta SAST utilizada frente a otras comunes:

| Ventaja   | Descripción |
|----------:|-------------|
| Velocidad | Semgrep es increíblemente rápido; escaneó los 11 archivos del proyecto en segundos. SonarQube suele requerir un servidor pesado y más tiempo. |
| Enfoque en Seguridad | Mientras SonarQube busca errores de lógica, Semgrep destaca en encontrar configuraciones inseguras en manifiestos de Kubernetes, Dockerfiles y YAML. |
| Portabilidad | No requiere instalación compleja ni cuentas. Se ejecuta como un contenedor Docker ligero en el CI/CD. |
| Personalización | Las reglas de Semgrep parecen código real, facilitando la creación de reglas propias. |

---

## 3. Observabilidad y Monitoreo

Se implementó el stack Prometheus-Grafana para visibilidad total del sistema:

### A. Logs Estructurados

La aplicación emite logs en formato JSON, facilitando su recolección y análisis por herramientas como Loki.

Ejemplo:
```json
{"time": "2026-01-05...", "level": "INFO", "msg": "Consulta a la raiz realizada"}
```

### B. Métricas de Aplicación

Integración del endpoint `/metrics` para que Prometheus recolecte datos de rendimiento (latencia, peticiones HTTP, errores) directamente desde FastAPI.

### C. Visualización en Grafana

Se desplegaron tableros automáticos mediante IaC (ConfigMaps) para monitorear:
- Salud del API Server: Disponibilidad al 100%.
- Uso de Recursos: Gráficas en tiempo real de CPU y Memoria del clúster y de los pods individuales.

---

## 4. Guía de Despliegue Local

### Requisitos
- Docker Desktop & Kind
- Helm v3+
- kubectl

### Pasos de Instalación

Crear el clúster local:
```bash
kind create cluster --name devops-project
```

Instalar Stack de Monitoreo:
```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm install monitoring prometheus-community/kube-prometheus-stack
```

Desplegar Aplicación:
- ArgoCD se encarga del despliegue al conectar el repositorio. Si se desea hacer manual:
```bash
cd charts
helm install mi-app ./my-app
```

Acceder a la Aplicación:
```bash
kubectl port-forward svc/mi-app 8000:80
```

Visitar: http://localhost:8000

---

## 📊 5. Resultados del Estado Actual

- ✅ Pods Activos: 2 réplicas en ejecución constante (Alta Disponibilidad).
- ✅ Estabilidad: 0 reinicios en los pods principales durante el periodo de prueba final (4+ horas).
- ✅ Seguridad: Pipeline validado y libre de hallazgos críticos de SAST y SCA.

Este proyecto demuestra una transición exitosa de un desarrollo local a una arquitectura lista para la nube, siguiendo los estándares de la industria DevSecOps.
