# Serve a lightweight HR assistant

![chat-example.png](docs/images/chat-example.png)

Replace hours spent searching policy documents with higher-value relational work. 

## Detailed description 

The *Assistant to the HR Representative* is a lightweight quickstart designed to
give HR Representatives in Financial Services a trusted sounding board for discussions and decisions. 
Chat with this assistant for quick insights and actionable advice. 

This quickstart was designed for environments where GPUs are not available or
necessary, making it ideal for lightweight inference use cases, prototyping, or
constrained environments. By making the most of vLLM on CPU-based
infrastructure, this Assistant to the HR Representative can be deployed to almost any OpenShift AI
environment. 

This quickstart includes a Helm chart for deploying:

- An OpenShift AI Project.
- vLLM with CPU support running an instance of TinyLlama.
- AnythingLLM, a versatile chat interface, running as a workbench and connected
  to the vLLM.
  
Use this project to quickly spin up a minimal vLLM instance and start serving
models like TinyLlama on CPU—no GPU required. 🚀


<!-- ### See it in action

Red Hat uses Arcade software to create interactive demos. Check out 
[Quickstart with TinyLlama on CPU](https://interact.redhat.com/share/zsT3j9cgPt9yyPchb7EJ)
 to see it in action. -->


### Architecture diagrams

![Architecture showcasing how both the playground an AnythingLLM uses the model hosted with vLLM CPU](docs/images/architecture.png)


## Requirements 


### Minimum hardware requirements 

- No GPU needed! 🤖
- 2 cores 
- 4 Gi 
- Storage: 5Gi 

### Recommended hardware requirements 

- No GPU needed! 🤖
- 32 cores 
- 64 Gi 
- Storage: 5Gi

Adjust the value of CPU and memory in `helm/values.yaml` as desired.

Note: This version is compiled for Intel CPU's (preferably with AVX512 enabled to be able to run compressed models as well, but optional).  
Here's an example machine from AWS that works well: [https://instances.vantage.sh/aws/ec2/m6i.4xlarge](https://instances.vantage.sh/aws/ec2/m6i.4xlarge)

### Minimum software requirements

- Red Hat OpenShift 4.16.24 or later
- Red Hat OpenShift AI 3.4.0 or later
- Dependencies for Single-model server:
    - Red Hat OpenShift Service Mesh
    - Red Hat OpenShift Serverless

### Required user permissions

- Standard user. No elevated cluster permissions required.


## Deploy

Follow the below steps to deploy and test the HR assistant.

This example was tested on Red Hat OpenShift 4.21.8 & Red Hat OpenShift AI v3.4.0.

### Clone

```
git clone https://github.com/rh-ai-quickstart/llm-cpu-serving.git && \
    cd llm-cpu-serving/  
```

### (Optional) Update storage class name

If needed, update storage class name in `helm/values.yaml`.
```
storageClassName: gp3-csi
```

### (Optional) Configure LD_PRELOAD

The default LD_PRELOAD for this image is setting an unsupported memory
allocator jemalloc. So setting this LD_PRELOAD to libomp overrides that
setting. jemalloc is set for pyarrow compatibility, if you require pyarrow
usage in this image jemalloc should be set in LD_PRELOAD alongside libomp
but vLLM will have degraded performance.

If needed, configure the LD_PRELOAD variable in `helm/templates/servingruntime.yaml`
```
env:
  - name: LD_PRELOAD
    value: "/usr/lib64/libomp.so"
```

### Create the project

```bash
PROJECT="hr-assistant"

oc new-project ${PROJECT}
``` 

### Install with Helm

```
helm install ${PROJECT} helm/ --namespace  ${PROJECT} 
```

### Wait for pods

```
oc -n ${PROJECT}  get pods -w
```

```
(Output)
NAME                                         READY   STATUS    RESTARTS   AGE
anythingllm-0                                 3/3     Running     0          76s
anythingllm-seed-lchf6                        0/1     Completed   0          76s
tinyllama-1b-cpu-predictor-544bdf75f9-x9fwh   2/2     Running     0          75s
```

## Chat with the model

From the OpenShift Console, go to the App Switcher / Waffle in the upper right and go to the Red Hat OpenShift AI Dashboard.

After that you have two choices, to chat with the model through the RHOAI playground or to chat with it through the AnythingLLM UI (deployed as a workbench).

### Chat through RHOAI Playground

> ⚠️ Note: This only works if you have the Early Access feature "Playground" enabled.

Once inside the dashboard, navigate to Gen AI studio -> Playground -> Project tinyllama-cpu-demo (or what you called your ${PROJECT} if you changed from default).

Click on the Knowledge tab and enable RAG, then you can start chatting with your documents.  
You can also customize the prompt in the Prompt tab, if you want to copy what is used in the values.yaml file for AnythingLLM.

Try for example asking it:
```
Hi, one of our employees is going to get a raise, what do I need to keep in mind for this?
```
It will provide you a reply and some citations related to the question.

![An example of asking a question to the playground with RAG enabled so it answers based on the documents](docs/images/playground-rag.png)

### Chat through AnythingLLM


Once inside the dashboard, navigate to Data Science Projects -> tinyllama-cpu-demo (or what you called your ${PROJECT} if you changed from default).

![Shows the OpenShift AI projects view](docs/images/rhoai-1.png)

Inside the project you can see Workbenches, open up the one for AnythingLLM.

![How AnythingLLM looks like when you just open it up](docs/images/rhoai-2.png)

Finally, click on the **Assistant to the HR Representative** Workspace that's pre-created for you and you can start chatting with your Assistant to the HR Representative! :)  
Try for example asking it:
```
Hi, one of our employees is going to get a raise, what do I need to keep in mind for this?
```
It will provide you a reply and some citations related to the question.

![An example of asking a question in AnythingLLM and getting an answer based on some documents](docs/images/anythingllm-1.png)



### Delete
```
helm uninstall ${PROJECT} --namespace ${PROJECT} 
```


## Tags

* **Industry:** Banking and securities
* **Product:** OpenShift AI 
* **Use case:** Productivity
