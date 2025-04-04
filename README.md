# vllm-cpu-blueprint

Install:
```
oc new-project tinyllama-cpu-demo && helm install vllm-cpu . --namespace tinyllama-cpu-demo
```

Uninstall:
```
helm uninstall vllm-cpu --namespace tinyllama-cpu-demo
```
