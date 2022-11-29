NGINX_PORT ?= 80
DOCKER_BUILDX_PLATFORM = linux/amd64
DOCKER_TAG ?= 0.0.3
docker-build-nocache:
	docker build --nocache . -t dsrcaapp.azurecr.io/react-demo:$(DOCKER_TAG)
docker-build:
	docker build . -t dsrcaapp.azurecr.io/react-demo:$(DOCKER_TAG)
docker-run: docker-build
	docker run -e NGINX_PORT=$(NGINX_PORT) --rm -p 8080:$(NGINX_PORT) dsrcaapp.azurecr.io/react-demo:$(DOCKER_TAG)

docker-push: login docker-build
	docker push dsrcaapp.azurecr.io/react-demo:$(DOCKER_TAG)

xdocker-build-nocache:
	docker buildx build --nocache --platform=$(DOCKER_BUILDX_PLATFORM) . -t dsrcaapp.azurecr.io/react-demo:$(DOCKER_TAG)
xdocker-build:
	docker buildx build --platform=$(DOCKER_BUILDX_PLATFORM) . -t dsrcaapp.azurecr.io/react-demo:$(DOCKER_TAG)
xdocker-run: docker-push
	docker run --pull -e NGINX_PORT=$(NGINX_PORT) --rm -p 8080:$(NGINX_PORT) dsrcaapp.azurecr.io/react-demo:$(DOCKER_TAG)

xdocker-push: login docker-build
	docker buildx build --push --platform=$(DOCKER_BUILDX_PLATFORM) . -t dsrcaapp.azurecr.io/react-demo:$(DOCKER_TAG)

dive: docker-build
	docker run --rm -it \
    -v /var/run/docker.sock:/var/run/docker.sock \
    wagoodman/dive:latest dsrcaapp.azurecr.io/react-demo:$(DOCKER_TAG)

login:
	az acr login --name dsrcaapp