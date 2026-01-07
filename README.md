Proyecto Web-Test: Pipeline DevSecOps & GitOps
Este repositorio contiene una solución completa de entrega continua para una aplicación Python (FastAPI), integrando prácticas avanzadas de seguridad, despliegue automatizado en Kubernetes mediante ArgoCD y un stack profesional de Observabilidad.
Tecnologías Utilizadas
Lenguaje: Python (FastAPI)
CI/CD: GitHub Actions
Seguridad (SAST): Semgrep
Infraestructura: Kubernetes (Kind), Helm
GitOps: ArgoCD
Observabilidad: Prometheus & Grafana




1. Arquitectura del Flujo End-to-End
El flujo de trabajo sigue un modelo de Automatización Total:

CI (Integración Continua): Al realizar un push, GitHub Actions ejecuta pruebas unitarias y escanea el código con Semgrep para detectar vulnerabilidades.
Build & Security: Se construye la imagen Docker y se sube al registro.
GitOps Trigger: El pipeline actualiza automáticamente el tag de la imagen en charts/my-app/values.yaml.
CD (Despliegue Continuo): ArgoCD detecta el cambio en Git y sincroniza el estado del clúster local (Kind), desplegando la nueva versión.
2. Implementación de Seguridad (DevSecOps)
Se aplicó el principio de "Least Privilege" y "Hardening" de contenedores tras los hallazgos de Semgrep:

Sistema de archivos de solo lectura: Configuración de readOnlyRootFilesystem: true para mitigar ataques de persistencia.
No privilegios: Los contenedores corren como usuarios no-root (runAsNonRoot: true).
Análisis Automático: Cada commit es bloqueado si no cumple con las reglas de seguridad de Kubernetes definidas en el pipeline.

A continuación, se comparan algunas ventajas de la herramienta SAST utilizada (Semgrep) frente a otras comunes:

Ventaja
Descripción
Velocidad
Semgrep es increíblemente rápido; escaneó tus 11 archivos en segundos. SonarQube suele requerir un servidor pesado y más tiempo de procesamiento.
Enfoque en Seguridad
Mientras SonarQube busca errores de lógica, Semgrep destaca en encontrar configuraciones inseguras en manifiestos de Kubernetes, Dockerfiles y YAML.
Portabilidad
No necesitas instalar nada complejo ni tener una cuenta. Se ejecuta como un contenedor Docker ligero en tu CI/CD sin necesidad de tokens de autenticación externos para escaneos locales o de comunidad.
Personalización
Las reglas de Semgrep parecen código real, lo que hace que sea muy fácil crear reglas propias para tu empresa.

 3. Observabilidad y Monitoreo
Se implementó el stack Prometheus-Grafana para visibilidad total del sistema:
A. Logs Estructurados
La aplicación emite logs en formato JSON, facilitando su recolección y análisis por herramientas como Loki.

Ejemplo: {"time": "...", "level": "INFO", "msg": "Consulta a la raiz realizada"}
B. Métricas de Aplicación
Integración de /metrics para que Prometheus recolecte datos de rendimiento (latencia, peticiones HTTP, errores).
C. Visualización en Grafana
Se desplegaron tableros automáticos para monitorear:

Salud del API Server: Disponibilidad al 100%.
Uso de Recursos: Gráficas en tiempo real de CPU y Memoria del clúster y de los pods individuales.
4. Guía de Despliegue Local
Requisitos
Docker Desktop & Kind
Helm v3+
kubectl
Pasos
Crear clúster: kind create cluster --name devops-project.
Instalar Monitoreo:

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm install monitoring prometheus-community/kube-prometheus-stack

Desplegar Aplicación: ArgoCD se encarga del despliegue al conectar el repositorio.
📊 5. Resultados del Estado Actual
Pods Activos: 2 réplicas en ejecución constante (Alta Disponibilidad).
Estabilidad: 0 reinicios en los pods principales durante el periodo de prueba (4+ horas).
Seguridad: Pipeline validado y libre de hallazgos críticos de SAST.

Este proyecto demuestra una transición exitosa de un desarrollo local a una arquitectura lista para la nube, siguiendo los estándares de la industria.
