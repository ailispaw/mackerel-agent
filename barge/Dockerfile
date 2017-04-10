FROM ailispaw/barge:docker

COPY mackerel-agent /usr/bin/mackerel-agent
COPY mackerel-agent.conf /etc/mackerel-agent/mackerel-agent.conf
COPY mackerel-plugin /usr/bin/mackerel-plugin
COPY mackerel-check /usr/bin/mackerel-check
COPY mkr /usr/bin/mkr

CMD [ "mackerel-agent" ]
