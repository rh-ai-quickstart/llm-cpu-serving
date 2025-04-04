# vllm-cpu-blueprint

Clone:

```
git clone https://github.com/RHRolun/vllm-cpu-blueprint.git && \
    cd vllm-cpu-blueprint/  
```



Create the project

```bash
PROJECT="tinyllama-cpu-demo"

oc apply -f - <<EOF
apiVersion: project.openshift.io/v1
kind: Project
metadata:
  name: ${PROJECT}
  labels:
    kubernetes.io/metadata.name: ${PROJECT}
    modelmesh-enabled: 'false'
    opendatahub.io/dashboard: 'true'
    pod-security.kubernetes.io/audit: restricted
    pod-security.kubernetes.io/audit-version: latest
    pod-security.kubernetes.io/warn: restricted
    pod-security.kubernetes.io/warn-version: latest
  annotations:
    openshift.io/description: A project to host TinyLlama
    openshift.io/display-name: ${PROJECT}
spec:
  finalizers:
    - kubernetes
EOF
``` 

Install:

```
helm install vllm-cpu . \
    --namespace  ${PROJECT} 
```

wait for pods:

```
oc -n ${PROJECT}  get pods -w
```


Uninstall:
```
helm uninstall vllm-cpu --namespace ${PROJECT} 
```
