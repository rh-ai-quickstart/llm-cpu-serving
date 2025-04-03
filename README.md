# vllm-cpu-blueprint

Clone:

```
git clone https://github.com/RHRolun/vllm-cpu-blueprint.git && \
    cd vllm-cpu-blueprint/  
```

Install:

```
# donde esta "project.yaml"?
# oc apply -f project.yaml 

PROJECT="tinyllama-cpu-demo"
oc new-project ${PROJECT} && \
helm install vllm-cpu . \
    --namespace tinyllama-cpu-demo
```

wait for pods:

```
oc get pods -w
```


Uninstall:
```
helm uninstall vllm-cpu --namespace tinyllama-cpu-demo
```
