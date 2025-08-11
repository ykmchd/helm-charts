{{/*
Vector configuration template
*/}}
{{- define "vector-common.config" -}}
api:
  enabled: true
  address: 127.0.0.1:8686
  playground: false

sources:
{{- range $name, $source := .Values.vector.config.sources }}
  {{ $name }}:
    type: {{ $source.type }}
    {{- if $source.include }}
    include:
    {{- range $source.include }}
      - {{ . }}
    {{- end }}
    {{- end }}
    {{- if $source.read_from }}
    read_from: {{ $source.read_from }}
    {{- end }}
{{- end }}

transforms:
{{- range $name, $transform := .Values.vector.config.transforms }}
  {{ $name }}:
    type: {{ $transform.type }}
    {{- if $transform.inputs }}
    inputs:
    {{- range $transform.inputs }}
      - {{ . }}
    {{- end }}
    {{- end }}
    {{- if $transform.source }}
    source: |
{{ $transform.source | indent 6 }}
    {{- end }}
{{- end }}

sinks:
{{- range $key, $value := .Values.vector.config.outputs }}
  {{ $key }}:
    type: {{ $value.type }}
    {{- if $value.inputs }}
    inputs:
    {{- range $value.inputs }}
      - {{ . }}
    {{- end }}
    {{- else }}
    inputs:
    {{- range $name, $transform := $.Values.vector.config.transforms }}
      - {{ $name }}
    {{- end }}
    {{- end }}
    {{- if $value.encoding }}
    encoding:
      {{- toYaml $value.encoding | nindent 6 }}
    {{- end }}
{{- end }}
{{- end -}}