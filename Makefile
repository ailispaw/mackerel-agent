IMAGE   := ailispaw/mackerel-agent
VERSION := 0.44.2

barge: barge/mackerel-agent barge/mackerel-agent.conf barge/mackerel-plugin barge/mkr
	docker build -t $(IMAGE):prometheus $@
	docker tag $(IMAGE):prometheus $(IMAGE):$(VERSION)-prometheus

barge/mackerel-agent barge/mackerel-plugin barge/mkr: | ubuntu
	docker create --name mackerel-agent-ubuntu $(IMAGE):ubuntu-prometheus
	docker cp mackerel-agent-ubuntu:/usr/bin/$(@F) $@
	docker rm mackerel-agent-ubuntu

barge/mackerel-agent.conf: | ubuntu
	docker create --name mackerel-agent-ubuntu $(IMAGE):ubuntu-prometheus
	docker cp mackerel-agent-ubuntu:/etc/mackerel-agent/$(@F) $@
	docker rm mackerel-agent-ubuntu

ubuntu: ubuntu/Dockerfile
	docker build -t $(IMAGE):$@-prometheus $@

alpine: alpine/Dockerfile
	docker build -t $(IMAGE):$@-prometheus $@
	docker tag $(IMAGE):$@-prometheus $(IMAGE):$(VERSION)-$@-prometheus

armhf: armhf/Dockerfile
	docker build -t $(IMAGE):$@-prometheus $@
	docker tag $(IMAGE):$@-prometheus $(IMAGE):$(VERSION)-$@-prometheus

vagrant:
	vagrant up --no-provision

release:
	-docker push $(IMAGE):$(VERSION)-alpine-prometheus
	-docker push $(IMAGE):alpine-prometheus
	-docker push $(IMAGE):$(VERSION)-prometheus
	-docker push $(IMAGE):prometheus
	-docker push $(IMAGE):$(VERSION)-armhf-prometheus
	-docker push $(IMAGE):armhf-prometheus

clean:
	-docker rm -f mackerel-agent-ubuntu
	-$(RM) barge/mackerel-agent barge/mackerel-agent.conf barge/mackerel-plugin barge/mkr

.PHONY: barge ubuntu alpine armhf vagrant clean
