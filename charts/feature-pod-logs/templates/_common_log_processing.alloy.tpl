{{- define "feature.podLogs.processing.alloy" }}
loki.process "pod_logs" {
  stage.match {
    selector = "{tmp_container_runtime=~\"containerd|cri-o\"}"
    // the cri processing stage extracts the following k/v pairs: log, stream, time, flags
    stage.cri {}

    // Set the extract flags and stream values as labels
    stage.labels {
      values = {
        flags  = "",
        stream  = "",
      }
    }
  }

  stage.match {
    selector = "{tmp_container_runtime=\"docker\"}"
    // the docker processing stage extracts the following k/v pairs: log, stream, time
    stage.docker {}

    // Set the extract stream value as a label
    stage.labels {
      values = {
        stream  = "",
      }
    }
  }

  // Drop the filename label, since it's not really useful in the context of Kubernetes, where we already have cluster,
  // namespace, pod, and container labels. Drop any structured metadata. Also drop the temporary
  // container runtime label as it is no longer needed.
  stage.label_drop {
    values = [
      "filename",
      "tmp_container_runtime",
    ]
  }

{{- if .Values.extraLogProcessingStages }}
{{ tpl .Values.extraLogProcessingStages $ | indent 2 }}
{{ end }}
  forward_to = argument.logs_destinations.value
}

{{- end }}
