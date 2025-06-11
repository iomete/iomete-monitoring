{{/*
Expand the name of the chart.
*/}}
{{- define "iomete-monitoring-chart.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "iomete-monitoring-chart.fullname" -}}
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
{{- define "iomete-monitoring-chart.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "iomete-monitoring-chart.labels" -}}
helm.sh/chart: {{ include "iomete-monitoring-chart.chart" . }}
{{ include "iomete-monitoring-chart.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "iomete-monitoring-chart.selectorLabels" -}}
app.kubernetes.io/name: {{ include "iomete-monitoring-chart.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "iomete-monitoring-chart.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "iomete-monitoring-chart.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/* Get all monitored namespaces */}}
{{- define "monitoring.namespaces" -}}
{{- $list := list .Release.Namespace }}
{{- $dataPlane := .Values.dataPlaneNamespaces }}
{{- if $dataPlane }}
  {{- if kindIs "string" $dataPlane }}
    {{- if hasPrefix "[" $dataPlane }}
      {{- $parsed := fromYaml $dataPlane }}
      {{- $list = concat $list $parsed }}
    {{- else }}
      {{- $split := splitList " " $dataPlane }}
      {{- $list = concat $list $split }}
    {{- end }}
  {{- else if kindIs "slice" $dataPlane }}
    {{- $list = concat $list $dataPlane }}
  {{- end }}
{{- end }}
{{- if .Values.iometeSystemNamespace }}
{{- $list = append $list .Values.iometeSystemNamespace }}
{{- end }}
{{- $list | uniq | sortAlpha | join " " }}
{{- end }}

{{- define "chart.storageClassName" -}}
{{- if .storageClassName -}}
  {{- .storageClassName -}}
{{- else if .global.storageClassName -}}
  {{- .global.storageClassName -}}
{{- end -}}
{{- end -}}
