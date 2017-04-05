FROM scratch

ADD rootfs.tar.xz /
RUN rm -rf /lib/modules /lib/firmware

COPY mackerel-agent /usr/bin/mackerel-agent
COPY mackerel-agent.conf /etc/mackerel-agent/mackerel-agent.conf
COPY mackerel-plugin /usr/bin/mackerel-plugin
COPY mkr /usr/bin/mkr

CMD [ "mackerel-agent" ]
