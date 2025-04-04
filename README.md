# vllm-cpu-blueprint

Jump straight to [installation](#install)

## Description 

[Section for Descriptions. Essentially, an elevator pitch. Happy to help draft]: # 

## Architecture diagrams

[Probably optional, good to have if easy to create. Happy to do this too]: # 

## References 

[Links to external references, docs, or Arcades (optional)]: # 

## Minimum hardware requirements 

[Suggestions? deployment dependencies?]: #

- no GPU needed! 
- 2 cores 
- 8 Gi 
- Storage: 5Gi 

[might need to double check ^^]: # 


## Required software  

- Red Hat OpenShift 
- Red Hat OpenShift AI 

[anything else used or installed to prepare the environment?]: # 

## Install {#install}

**Please note before you start**

[ie disclaimer section]: #

This example was tested on Red Hat OpenShift 4.16.24 & Red Hat OpenShift AI
v2.16.2.  

[kserve set up a specific way? Anything else to note?]: #

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
