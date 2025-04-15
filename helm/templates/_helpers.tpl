{{/*
Expand the name of the chart.
*/}}
{{- define "up42-app.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "up42-app.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "up42-app.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "up42-app.labels" -}}
helm.sh/chart: {{ include "up42-app.chart" . }}
{{ include "up42-app.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "up42-app.selectorLabels" -}}
app.kubernetes.io/name: {{ include "up42-app.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "up42-app.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "up42-app.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the name of the shared secret
*/}}
{{- define "up42-app.shared-minio-password" -}}
{{ .Release.Name }}-shared-secret
{{- end }}

{{/* vim: set filetype=gotemplate: */}}
{{/* ... other helpers (fullname, name, chart, labels, selectorLabels) ... */}}

{{/*
Create the name of the service account to use for MinIO
*/}}
{{- define "up42-app.minioServiceAccountName" -}}
{{- if .Values.minio.serviceAccount.create }}
    {{- /* Use provided name if set, otherwise generate default */}}
    {{- default (printf "%s-minio" (include "up42-app.fullname" .)) .Values.minio.serviceAccount.name }}
{{- else }}
    {{- /* Use default service account if not creating a new one */}}
    {{- "default" }}
{{- end }}
{{- end -}}


