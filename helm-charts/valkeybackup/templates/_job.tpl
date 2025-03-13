{{/* Generate the valkey job if the cronjob is deactivated */}}
{{- define "valkeybackup.job" }}
apiVersion: batch/v1
kind: Job
metadata:
  name: {{ .Release.Name }}-job
  namespace: {{ .Values.namespace  | default "default" | quote }}
spec:
  template:
    spec:
      serviceAccountName: {{ .Release.Name }}-internal-kubectl
      {{- if eq .Values.valkey.use_tls "true" }}
      volumes:
        - name: certs-vol
          secret:
            secretName: {{ .Values.valkey.certificates_secret }}
      {{- end }}
      containers:
      - name: {{ .Release.Name }}-job
        image: {{ .Values.image.repository }}:{{ .Values.image.tag }}
        command: ["bash", "-c"]
        args:
        - |
          /backup/backup.bash
          #sleep 3600
        {{- if eq .Values.valkey.use_tls "true" }}
        volumeMounts:
          - mountPath: "/certs"
            name: certs-vol
            readOnly: true
        {{- end }}
        env:
        - name: DEBUG_IMAGE
          value: {{ .Values.image.debug | default "false" | quote }}
        - name: VALKEY_NAME
          value: {{ required "A valid .Values.valkey_instance_name entry required!" .Values.valkey_instance_name }}
        - name: VALKEY_NAMESPACE
          value: {{ .Values.namespace | default "default" | quote }}
        - name: VALKEY_PASSWORD
          valueFrom:
            secretKeyRef:
              name: {{ .Values.valkey_instance_name }}
              key: valkey-password
        - name: RESTIC_PASSWORD
          valueFrom:
            secretKeyRef:
              name: {{ .Release.Name }}-restic-password
              key: password
        - name: VALKEY_USE_TLS
          value: {{ .Values.valkey.use_tls | default "false" | quote }}
        - name: JOB_BUCKET_NAME
          value: {{ .Values.s3.bucket_name | quote }}
        - name: JOB_S3_REGION
          value: {{ .Values.s3.region | quote }}
        - name: JOB_S3_HOST
          value: {{ .Values.s3.host | quote }}
        - name: JOB_S3_PORT
          value: {{ .Values.s3.port | quote }}
        - name: JOB_S3_USE_SSL
          value: {{ .Values.s3.use_ssl | quote }}
        - name: JOB_S3_ACCESS_KEY
          valueFrom:
            secretKeyRef:
              name: {{ .Release.Name }}-s3-credentials
              key: access_key
        - name: JOB_S3_SECRET_KEY
          valueFrom:
            secretKeyRef:
              name: {{ .Release.Name }}-s3-credentials
              key: secret_access_key

      restartPolicy: Never
{{- end }}
