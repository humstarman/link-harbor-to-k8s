kind: Service
apiVersion: v1
metadata:
  name: {{.name}} 
  namespace: {{.namespace}} 
spec:
  ports:
    - protocol: TCP 
      port: {{.port}}
      targetPort: {{.port}}
