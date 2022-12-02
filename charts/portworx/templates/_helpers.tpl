{{/* Gets the correct API Version based on the version of the cluster
*/}}

{{- define "rbac.apiVersion" -}}
{{$version := .Capabilities.KubeVersion.GitVersion | regexFind "^v\\d+\\.\\d+\\.\\d+" | trimPrefix "v"}}
{{- if semverCompare ">= 1.8" $version -}}
"rbac.authorization.k8s.io/v1"
{{- else -}}
"rbac.authorization.k8s.io/v1beta1"
{{- end -}}
{{- end -}}

{{- define "px.labels" -}}
chart: "{{ .Chart.Name }}-{{ .Chart.Version }}"
heritage: {{ .Release.Service | quote }}
release: {{ .Release.Name | quote }}
{{- end -}}

{{- define "driveOpts" }}
{{ $v := .Values.installOptions.drives | split "," }}
{{$v._0}}
{{- end -}}

{{- define "px.kubernetesVersion" -}}
{{$version := .Capabilities.KubeVersion.GitVersion | regexFind "^v\\d+\\.\\d+\\.\\d+"}}{{$version}}
{{- end -}}

{{- define "px.kubectlImageTag" -}}
{{$version := .Capabilities.KubeVersion.GitVersion | regexFind "^v\\d+\\.\\d+\\.\\d+" | trimPrefix "v" | split "."}}
{{- $major := index $version "_0" -}}
{{- $minor := index $version "_1" -}}
{{printf "%s.%s" $major $minor }}
{{- end -}}

{{- define "px.getOperatorImage" -}}
{{- $product := .Values.awsProduct | default "PX-ENTERPRISE" }}
{{- if (.Values.customRegistryURL) -}}
  {{- if (eq "/" (.Values.customRegistryURL | regexFind "/")) -}}
    {{- cat (trim .Values.customRegistryURL) "/px-operator:" (trim .Values.pxOperatorImageVersion) | replace " " ""}}
  {{- else -}}
    {{- cat (trim .Values.customRegistryURL) "/px-operator:" (trim .Values.pxOperatorImageVersion) | replace " " ""}}
  {{- end -}}
{{- else -}}
  {{- if eq $product "PX-ENTERPRISE-DR" }}
    {{- cat (trim .Values.repo.dr) "/px-operator:" (trim .Values.pxOperatorImageVersion) | replace " " ""}}
  {{- else }}
    {{- cat (trim .Values.repo.enterprise) "/px-operator:" (trim .Values.pxOperatorImageVersion) | replace " " ""}}
  {{- end }}
{{- end -}}
{{- end -}}

{{- define "px.getImage" -}}
{{- $product := .Values.awsProduct | default "PX-ENTERPRISE" }}
{{- if (.Values.customRegistryURL) -}}
  {{- if (eq "/" (.Values.customRegistryURL | regexFind "/")) -}}
    {{- cat (trim .Values.customRegistryURL) "/px-enterprise:" (trim .Values.versions.enterprise) | replace " " ""}}
  {{- else -}}
    {{- cat (trim .Values.customRegistryURL) "/px-enterprise:" (trim .Values.versions.enterprise)| replace " " ""}}
  {{- end -}}
{{- else -}}
  {{- cat "portworx/px-enterprise:" (trim .Values.versions.enterprise) | replace " " ""}}
{{- end -}}
{{- end -}}

{{- define "px.getOCIImage" -}}
{{- $product := .Values.awsProduct | default "PX-ENTERPRISE" }}
{{- if (.Values.customRegistryURL) -}}
  {{- if (eq "/" (.Values.customRegistryURL | regexFind "/")) -}}
    {{- cat (trim .Values.customRegistryURL) "/oci-monitor:" (trim .Values.imageVersion) | replace " " ""}}
  {{- else -}}
    {{- cat (trim .Values.customRegistryURL) "/oci-monitor:" (trim .Values.imageVersion)| replace " " ""}}
  {{- end -}}
{{- else -}}
  {{- if eq $product "PX-ENTERPRISE-DR" }}
    {{- cat (trim .Values.repo.dr) "/oci-monitor:" (trim .Values.imageVersion) | replace " " ""}}
  {{- else }}
    {{- cat (trim .Values.repo.enterprise) "/oci-monitor:" (trim .Values.imageVersion) | replace " " ""}}
  {{- end }}
{{- end -}}
{{- end -}}

{{- define "px.getStorkImage" -}}
{{- $product := .Values.awsProduct | default "PX-ENTERPRISE" }}
{{- if (.Values.customRegistryURL) -}}
  {{- if (eq "/" (.Values.customRegistryURL | regexFind "/")) -}}
    {{- cat (trim .Values.customRegistryURL) "/stork:" (trim .Values.storkVersion)| replace " " ""}}
  {{- else -}}
    {{- cat (trim .Values.customRegistryURL) "/stork:" (trim .Values.storkVersion) | replace " " ""}}
  {{- end -}}
{{- else -}}
  {{- if eq $product "PX-ENTERPRISE-DR" }}
    {{- cat (trim .Values.repo.dr) "/stork:" (trim .Values.storkVersion) | replace " " ""}}
  {{- else }}
    {{- cat (trim .Values.repo.enterprise) "/stork:" (trim .Values.storkVersion) | replace " " ""}}
  {{- end }}
{{- end -}}
{{- end -}}

{{- define "px.getAutopilotImage" -}}
{{- $product := .Values.awsProduct | default "PX-ENTERPRISE" }}
{{- if (.Values.customRegistryURL) -}}
  {{- if (eq "/" (.Values.customRegistryURL | regexFind "/")) -}}
    {{- cat (trim .Values.customRegistryURL) "/autopilot:" (trim .Values.versions.autoPilot) | replace " " ""}}
  {{- else -}}
    {{- cat (trim .Values.customRegistryURL) "/autopilot:" (trim .Values.versions.autoPilot) | replace " " ""}}
  {{- end -}}
{{- else -}}
  {{- if eq $product "PX-ENTERPRISE-DR" }}
    {{- cat (trim .Values.repo.dr) "/autopilot:" (trim .Values.versions.autoPilot) | replace " " ""}}
  {{- else }}
    {{- cat (trim .Values.repo.enterprise) "/autopilot:" (trim .Values.versions.autoPilot) | replace " " ""}}
  {{- end }}
{{- end -}}
{{- end -}}

{{- define "px.registryConfigType" -}}
{{- $version := .Capabilities.KubeVersion.GitVersion | regexFind "^v\\d+\\.\\d+\\.\\d+" | trimPrefix "v" -}}
{{- if semverCompare ">=1.9" $version -}}
".dockerconfigjson"
{{- else -}}
".dockercfg"
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use for hooks
*/}}
{{- define "px.hookServiceAccount" -}}
{{- if .Values.serviceAccount.hook.create -}}
    {{- printf "%s-hook" .Chart.Name | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- else -}}
    {{ default "default" .Values.serviceAccount.hook.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the cluster role to use for hooks
*/}}
{{- define "px.hookClusterRole" -}}
{{- if .Values.serviceAccount.hook.create -}}
    {{- printf "%s-hook" .Chart.Name | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- else -}}
    {{ default "default" .Values.serviceAccount.hook.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the cluster role binding to use for hooks
*/}}
{{- define "px.hookClusterRoleBinding" -}}
{{- if .Values.serviceAccount.hook.create -}}
    {{- printf "%s-hook" .Chart.Name | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- else -}}
    {{ default "default" .Values.serviceAccount.hook.name }}
{{- end -}}
{{- end -}}


{{/*
Create the name of the role to use for hooks
*/}}
{{- define "px.hookRole" -}}
{{- if .Values.serviceAccount.hook.create -}}
    {{- printf "%s-hook" .Chart.Name | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- else -}}
    {{ default "default" .Values.serviceAccount.hook.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the role binding to use for hooks
*/}}
{{- define "px.hookRoleBinding" -}}
{{- if .Values.serviceAccount.hook.create -}}
    {{- printf "%s-hook" .Chart.Name | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- else -}}
    {{ default "default" .Values.serviceAccount.hook.name }}
{{- end -}}
{{- end -}}

{{/*
Generate a random token for storage provisioning
*/}}

{{- define "portworx-cluster-key" -}}
{{- randAlphaNum 16 | nospace | b64enc -}}
{{- end -}}


{{- define "px.affinityPxEnabledOperator" -}}
{{- if .Values.requirePxEnabledTag -}}
    {{- "In" }}
{{- else -}}
    {{ "NotIn" }}
{{- end -}}
{{- end -}}


{{- define "px.affinityPxEnabledValue" -}}
{{- if .Values.requirePxEnabledTag -}}
    {{- "true"  | quote }}
{{- else -}}
    {{ "false" | quote }}
{{- end -}}
{{- end -}}

{{- define "px.deprecatedKvdbArgs" }}
{{- $result := "" }}
{{- if ne .Values.etcd.credentials "none:none" }}
    {{- $result = printf "%s -userpwd %s" $result .Values.etcd.credentials }}
{{- end }}
{{- if ne .Values.etcd.ca "none" }}
    {{- $result = printf "%s -ca %s" $result .Values.etcd.ca }}
{{- end }}
{{- if ne .Values.etcd.cert "none" }}
    {{- $result = printf "%s -cert %s" $result .Values.etcd.cert }}
{{- end }}
{{- if ne .Values.etcd.key "none" }}
    {{- $result = printf "%s -key %s" $result .Values.etcd.key }}
{{- end }}
{{- if ne .Values.consul.token "none" }}
    {{- $result = printf "%s -acltoken %s" $result .Values.consul.token }}
{{- end }}
{{- trim $result }}
{{- end }}

{{- define "px.miscArgs" }}
{{- $result := "" }}
{{- if (include "px.deprecatedKvdbArgs" .) }}
    {{- $result = printf "%s %s" $result (include "px.deprecatedKvdbArgs" .) }}
{{- end }}
{{- if ne .Values.miscArgs "none" }}
    {{- $result = printf "%s %s" $result .Values.miscArgs }}
{{- end }}
{{- trim $result }}
{{- end }}

{{- define "px.volumesPresent" }}
{{- $result := false }}
{{- if (default false .Values.isTargetOSCoreOS) }}
    {{- $result = true }}
{{- end }}
{{- if ne (default "none" .Values.etcd.certPath) "none" }}
    {{- $result = true }}
{{- end }}
{{- if .Values.volumes }}
    {{- $result = true }}
{{- end }}
{{- $result }}
{{- end }}

{{- define "px.getProductID" -}}
{{- $product := .Values.awsProduct | default "PX-ENTERPRISE" }}
    {{- if eq $product "PX-ENTERPRISE-DR" }}
        {{- cat "6a97e814-fbe5-4ae3-a3e2-14ca735b5e6b" }}
    {{- else }}
        {{- cat "3a3fcb1c-7ee5-4f3b-afe3-d293c3f9beb4" }}
    {{- end }}
{{- end -}}

{{- define "px.getDeploymentNamespace" -}}
{{- if (.Release.Namespace) -}}
    {{- if (eq "default" .Release.Namespace) -}}
        {{- printf "kube-system"  -}}
    {{- else -}}
        {{- printf "%s" .Release.Namespace -}}
    {{- end -}}
{{- end -}}
{{- end -}}