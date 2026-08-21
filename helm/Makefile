NAMESPACE ?= llm-cpu-serving
RELEASE ?= vllm-cpu

.PHONY: install uninstall

install:
	helm install $(RELEASE) . \
		--namespace $(NAMESPACE) \
		--create-namespace \
		--set username=$$(oc whoami) \
		--wait --timeout 10m

uninstall:
	helm uninstall $(RELEASE) --namespace $(NAMESPACE)
