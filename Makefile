DIR = .
FILE = Dockerfile
IMAGE = m2p
TAG = latest

.PHONY: build rebuild test tag pull login push

build:
	docker build -t $(IMAGE) -f $(DIR)/$(FILE) $(DIR)

rebuild:
	docker build --no-cache -t $(IMAGE) -f $(DIR)/$(FILE) $(DIR)

test:
	true

tag:
	docker tag $(IMAGE) $(IMAGE):$(TAG)

login:
	yes | docker login --username $(USER) --password $(PASS)

push:
ifndef TAG
	docker push $(IMAGE)
else
	docker push $(IMAGE):$(TAG)
endif

bash-enter:
	#docker run --rm --name $(subst /,-,$(IMAGE)) -it --privileged --entrypoint=bash -p 9100:9100 -v ${KUBECONFIG}:/etc/kube/config:ro $(ARG) $(IMAGE)
	. ~/.passwords/awsauth.sh remax ;\
	sudo docker run --rm --name $(IMAGE) -it --entrypoint=bash --privileged -p 9100:9100 -v /home/kane/sysconfigs/kubernetes/remax-eksconfig:/etc/kube/config:ro $(ARG) $(IMAGE)

run:
	docker run --rm --name $(subst /,-,$(IMAGE)) -p 9100:9100 -v ${KUBECONFIG}:/etc/kube/config:ro $(ARG) $(IMAGE)
exec:
	docker exec -it $(shell docker ps -q --filter "name=$(subst /,-,$(IMAGE))") bash
