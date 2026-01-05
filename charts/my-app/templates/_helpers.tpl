{{/* Nombre completo de la aplicación */}}
{{- define "my-app.fullname" -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/* Etiquetas de selección (Lo que te faltaba) */}}
{{- define "my-app.selectorLabels" -}}
app: {{ include "my-app.fullname" . }}
{{- end -}}

{{/* Etiquetas comunes */}}
{{- define "my-app.labels" -}}
{{ include "my-app.selectorLabels" . }}
release: {{ .Release.Name }}
{{- end -}}