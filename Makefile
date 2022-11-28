docker-build-nocache:
	docker build --no-cache -t react-demo .
docker-build:
	docker build . -t react-demo

docker-run: docker-build
	docker run --rm -p 3000:3000 react-demo

dive: docker-build
	docker run --rm -it \
    -v /var/run/docker.sock:/var/run/docker.sock \
    wagoodman/dive:latest react-demo
