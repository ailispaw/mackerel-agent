IMAGE   := ailispaw/mackerel-agent
VERSION := 0.42.0
BARGE   := 2.4.4

barge: barge/mackerel-agent barge/mackerel-agent.conf barge/mackerel-plugin barge/mkr
	docker build -t $(IMAGE) $@
	docker tag $(IMAGE) $(IMAGE):$(VERSION)

barge/mackerel-agent barge/mackerel-plugin barge/mkr: | ubuntu
	docker create --name mackerel-agent-ubuntu $(IMAGE):ubuntu
	docker cp mackerel-agent-ubuntu:/usr/bin/$(@F) $@
	docker rm mackerel-agent-ubuntu

barge/mackerel-agent.conf: | ubuntu
	docker create --name mackerel-agent-ubuntu $(IMAGE):ubuntu
	docker cp mackerel-agent-ubuntu:/etc/mackerel-agent/$(@F) $@
	docker rm mackerel-agent-ubuntu

ubuntu: ubuntu/Dockerfile
	docker build -t $(IMAGE):$@ $@

alpine: alpine/Dockerfile
	docker build -t $(IMAGE):$@ $@
	docker tag $(IMAGE):$@ $(IMAGE):$(VERSION)-$@

armhf: armhf/Dockerfile
	docker build -t $(IMAGE):$@ $@
	docker tag $(IMAGE):$@ $(IMAGE):$(VERSION)-$@

vagrant:
	vagrant up --no-provision

release:
	-docker push $(IMAGE):$(VERSION)-alpine
	-docker push $(IMAGE):alpine
	-docker push $(IMAGE):$(VERSION)
	-docker push $(IMAGE):latest
	-docker push $(IMAGE):$(VERSION)-armhf
	-docker push $(IMAGE):armhf

clean:
	-docker rm -f mackerel-agent-ubuntu
	-$(RM) barge/mackerel-agent barge/mackerel-agent.conf barge/mackerel-plugin barge/mkr

.PHONY: barge ubuntu alpine armhf vagrant clean
