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
      {{- if .Values.valkey.use_tls }}
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
          echo "Sleep before execution:"
          echo "Sleeping {{ .Values.cronjob.sleep_before_exec | default 0 }} secs"
          sleep {{ .Values.cronjob.sleep_before_exec | default 0 }}
          echo
          /backup/backup.bash
        {{- if .Values.valkey.use_tls }}
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
              name: {{ .Values.restic_password }}
              key: password
        - name: VALKEY_USE_TLS
          value: {{ .Values.valkey.use_tls | default "false" | quote }}
        - name: VALKEY_TYPE
          value: {{ .Values.valkey.architecture | default "standalone" | quote }}
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
              name: {{ .Values.s3.access_credentials_secret | quote }}
              key: access_key
        - name: JOB_S3_SECRET_KEY
          valueFrom:
            secretKeyRef:
              name: {{ .Values.s3.access_credentials_secret | quote }}
              key: secret_access_key

        - name: VALKEY_RESTORE
          value: {{ .Values.restore.enabled | default "false" | quote }}

	{{- if .Values.restore.enabled }}
	{{- if .Values.restore.show_available_backups }}
        - name: VALKEY_BACKUP_AVAILABLE_LIST
          value: {{ .Values.restore.show_available_backups | default "false" | quote }}
	{{- end }}
	{{- if .Values.restore.snapshot_id }}
        - name: VALKEY_RESTORE_SNAPSHOT_ID
          value: {{ .Values.restore.snapshot_id | quote }}
        {{- end }}
        {{- end }}

      restartPolicy: Never
{{- end }}
