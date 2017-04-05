IMAGE   := ailispaw/mackerel-agent
VERSION := 0.41.3
BARGE   := 2.4.4

barge: barge/rootfs.tar.xz \
		barge/mackerel-agent barge/mackerel-agent.conf barge/mackerel-plugin barge/mkr
	docker build -t $(IMAGE):$@ $@
	docker create --name mackerel-agent-$@ $(IMAGE):$@
	docker export mackerel-agent-$@ | docker import \
		-c 'ENTRYPOINT [ "dumb-init" ]' \
		-c 'CMD [ "mackerel-agent" ]' \
		-m 'https://github.com/ailispaw/mackerel-agent' \
		- $(IMAGE)
	docker rm mackerel-agent-$@
	docker tag $(IMAGE) $(IMAGE):$(VERSION)

barge/rootfs.tar.xz:
	curl -L -o $@ https://github.com/bargees/barge-os/releases/download/$(BARGE)/$(@F)

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

vagrant:
	vagrant up --no-provision

release:
	-docker push $(IMAGE):$(VERSION)-alpine
	-docker push $(IMAGE):alpine
	-docker push $(IMAGE):$(VERSION)
	-docker push $(IMAGE):latest

clean:
	-docker rm -f mackerel-agent-barge
	-docker rm -f mackerel-agent-ubuntu

.PHONY: barge mackerel-agent-ubuntu ubuntu alpine vagrant clean
