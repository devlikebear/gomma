VERSION ?= 0.0.1
APP_IMG ?= devlikebear/gomma-app:${VERSION}
OPERATOR_IMG ?= devlikebear/gomma-operator:${VERSION}

K8S_NAMESPACE ?= default

all: docker-build-app docker-push-app docker-build-operator docker-push-operator

# Build the docker image for app
docker-build-app:
	$(MAKE) -C ./app docker-build VERSION=${VERSION} APP_IMG=${APP_IMG}

# Push the docker image for app
docker-push-app:
	$(MAKE) -C ./app docker-push VERSION=${VERSION} APP_IMG=${APP_IMG}

# Build the docker image for operator
docker-build-operator:
	$(MAKE) -C ./operator docker-build VERSION=${VERSION} IMG=${OPERATOR_IMG}

# Push the docker image for operator
docker-push-operator:
	$(MAKE) -C ./operator docker-push VERSION=${VERSION} IMG=${OPERATOR_IMG}

# Install Helm
helm-install:
	curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
	chmod 700 get_helm.sh
	./get_helm.sh

# Install Prometheus
prometheus-repo: helm-install
	helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
	helm repo update

prometheus-values:
	helm show values prometheus-community/prometheus > prometheus-values.yaml

prometheus-install: 
	helm install prometheus prometheus-community/prometheus -f prometheus-values.yaml --namespace ${K8S_NAMESPACE}

prometheus-uninstall:
	helm uninstall prometheus --namespace ${K8S_NAMESPACE}

prometheus-port-forward:
	kubectl port-forward -n ${K8S_NAMESPACE} svc/prometheus-server 9090:80


