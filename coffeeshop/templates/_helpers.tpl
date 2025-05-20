{{- define "fullname" -}}
{{ printf "%s-%s" .Release.Name .Chart.Name }}
{{- end }}

{{- define "labels" -}}
app.kubernetes.io/name: {{ .Chart.Name }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "selectorLabels" -}}
app.kubernetes.io/name: {{ .Chart.Name }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Put all functions here please!
*/}}
{{- define "vol_conf_mount" }}
{{- if eq .Values.custom_config "true" -}}
volumeMounts:
- name: configs
mountPath: "/usr/app/envs"
readOnly: true
{{- end }}
{{- end }}
{{- define "vol_conf_define" }}
{{- if eq .Values.custom_config "true" -}}
volumes:
- name: configs
configMap:
name: {{ .Chart.Name }}
{{- end }}
{{- end }}

{{/*
Return chart name
*/}}
{{- define "barista.name" -}}
{{ .Chart.Name }}
{{- end }}

{{/*
Return full name
*/}}
{{- define "barista.fullname" -}}
{{ printf "%s-%s" .Release.Name .Values.services.name }}
{{- end }}

