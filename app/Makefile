# Image URL to use all building/pushing image targets
VERSION ?= 0.0.1
APP_IMG ?= devlikebear/gomma-app:${VERSION}

all: docker-build docker-push

# Build the docker image
docker-build:
	docker build . -t ${APP_IMG}

# Push the docker image
docker-push:
	docker push ${APP_IMG}