# vllm-cpu-blueprint

Welcome to the vLLM CPU Blueprint!  
Use this to quickly get a vLLM up and running in your environment.  
To see how it's done, jump straight to [installation](#install).

## Description 

The vLLM CPU Blueprint is a quick-start template for deploying vLLM on CPU-based infrastructure within Red Hat OpenShift. It’s designed for environments where GPUs are not available or necessary, making it ideal for lightweight inference use cases, prototyping, or constrained environments.  
In this Blueprint, we are utilizing it to easily get an LLM deployed in most environments.

This blueprint includes a Helm chart for deploying:

- An OpenShift AI Project.
- vLLM with CPU support running an instance of TinyLlama.
- AnythingLLM (a versitile chat interface) running as a workbench and connected to the vLLM.

Use this project to quickly spin up a minimal vLLM instance and start serving models like TinyLlama on CPU—no GPU required. 🚀

## Architecture diagrams

![architecture.png](images/architecture.png)

## References 

- The runtime is built from [vLLM CPU](https://docs.vllm.ai/en/latest/getting_started/installation/cpu.html)
- Runtime image is pushed to [quay.io/repository/rh-aiservices-bu/vllm-cpu-openai-ubi9](https://quay.io/repository/rh-aiservices-bu/vllm-cpu-openai-ubi9)
- Code for Runtime image and deployment can be found on [github.com/rh-aiservices-bu/llm-on-openshift](https://github.com/rh-aiservices-bu/llm-on-openshift/tree/main/serving-runtimes/vllm_runtime)

## Minimum hardware requirements 

[Suggestions? deployment dependencies?]: #

- No GPU needed! 🤖
- 2 cores 
- 8 Gi 
- Storage: 5Gi 

## Required software  

- Red Hat OpenShift 
- Red Hat OpenShift AI 
- Dependencies for [Single-model server](https://docs.redhat.com/en/documentation/red_hat_openshift_ai_self-managed/2.16/html/installing_and_uninstalling_openshift_ai_self-managed/installing-the-single-model-serving-platform_component-install#configuring-automated-installation-of-kserve_component-install):
    - Red Hat OpenShift Service Mesh
    - Red Hat OpenShift Serverless

## Required permissions

- Standard user. No elevated cluster permissions required 

## Install

**Please note before you start**

This example was tested on Red Hat OpenShift 4.16.24 & Red Hat OpenShift AI v2.16.2.  

Clone:

```
git clone https://github.com/RHRolun/vllm-cpu-blueprint.git && \
    cd vllm-cpu-blueprint/  
```



Create the project

```bash
PROJECT="tinyllama-cpu-demo"

oc new-project ${PROJECT}
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
