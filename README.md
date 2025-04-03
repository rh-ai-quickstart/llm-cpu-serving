# vllm-cpu-blueprint

Install:
```
oc apply -f project.yaml && helm install vllm-cpu . --namespace tinyllama-cpu-demo
```

Uninstall:
```
helm uninstall vllm-cpu --namespace tinyllama-cpu-demo
```
