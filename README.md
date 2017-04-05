# mackerel-agent

A lightweight mackerel-agent Docker image with mackerel-plugin and mkr

## Barge(glibc) base

```
$ vagrant up --no-provision
$ make
```

## Alpine(musl libc) base

```
$ vagrant up --no-provision
$ make alpine
```

## Run

```
$ docker run -d --restart=always --name mackerel-agent -h `hostname` \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v /var/lib/mackerel-agent/:/var/lib/mackerel-agent/ \
    -v /path/to/mackerel-agent.conf:/etc/mackerel-agent/mackerel-agent.conf \
    ailispaw/mackerel-agent
```

- mackerel-agent.conf
```
apikey = "Your API Key Here"

[plugin.metrics.docker]
command = "/usr/bin/mackerel-plugin docker -method API -name-format name"
```

## mkr

```
$ docker exec mackerel-agent mkr update --status poweroff
$ docker exec mackerel-agent mkr retire
```
