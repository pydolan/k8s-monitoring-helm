{{- define "features.annotationAutodiscovery.enabled" }}{{ .Values.annotationAutodiscovery.enabled }}{{- end }}
{{- define "features.annotationAutodiscovery.include" }}
{{- if .Values.annotationAutodiscovery.enabled -}}
{{- $destinations := include "features.annotationAutodiscovery.destinations" . | fromYamlArray }}
// Feature: Annotation Autodiscovery
{{- include "feature.annotationAutodiscovery.module" .Subcharts.annotationAutodiscovery }}
annotation_autodiscovery "feature" {
  metrics_destinations = [
    {{ include "destinations.alloy.targets" (dict "destinations" $.Values.destinations "names" $destinations "type" "metrics" "ecosystem" "prometheus") | indent 4 | trim }}
  ]
}
{{- end -}}
{{- end -}}

{{- define "features.annotationAutodiscovery.destinations" }}
{{- if .Values.annotationAutodiscovery.enabled -}}
{{- include "destinations.get" (dict "destinations" $.Values.destinations "type" "metrics" "ecosystem" "prometheus" "filter" $.Values.annotationAutodiscovery.destinations) -}}
{{- end -}}
{{- end -}}

{{- define "features.annotationAutodiscovery.validate" }}
{{- if .Values.annotationAutodiscovery.enabled -}}
{{- $featureName := "Annotation Autodiscovery" }}
{{- $destinations := include "features.annotationAutodiscovery.destinations" . | fromYamlArray }}
{{- include "destinations.validate_destination_list" (dict "destinations" $destinations "type" "metrics" "ecosystem" "prometheus" "feature" $featureName) }}
{{- include "collectors.require_collector" (dict "Values" $.Values "name" "alloy-metrics" "feature" $featureName) }}
{{- end -}}
{{- end -}}