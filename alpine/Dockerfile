FROM alpine:3.5

ENV GOPATH="/tmp/go"

# Build mackerel-agent
ENV AGENT_VERSION="0.44.0"
RUN set -e && \
    apk --no-cache --update add --virtual build-deps git go build-base && \

    mkdir -p "${GOPATH}/src/github.com/mackerelio/" && \
    cd "${GOPATH}/src/github.com/mackerelio/" && \
    git clone --depth 1 --branch v${AGENT_VERSION} https://github.com/mackerelio/mackerel-agent && \
    cd mackerel-agent && \
    make deps && \
    go build -o /usr/bin/mackerel-agent \
      -ldflags="-w -s \
        -X github.com/mackerelio/mackerel-agent/version.GITCOMMIT=`git rev-parse --short HEAD` \
        -X github.com/mackerelio/mackerel-agent/version.VERSION=${AGENT_VERSION}" && \

    mkdir -p /etc/mackerel-agent && \
    cp mackerel-agent.sample.conf /etc/mackerel-agent/mackerel-agent.conf && \

    apk del build-deps && \
    rm -rf /usr/lib/go && \
    rm -rf "${GOPATH}"

# Build mackerel-plugin
ENV PLUGIN_VERSION="0.29.0"
RUN set -e && \
    apk --no-cache --update add --virtual build-deps git go build-base && \

    mkdir -p "${GOPATH}/src/github.com/mackerelio/" && \
    cd "${GOPATH}/src/github.com/mackerelio/" && \
    git clone --depth 1 --branch v${PLUGIN_VERSION} https://github.com/mackerelio/mackerel-agent-plugins && \
    cd mackerel-agent-plugins && \
    make deps && \
    go build -o /usr/bin/mackerel-plugin \
      -ldflags="-w -s \
        -X main.version=${PLUGIN_VERSION} \
        -X main.gitcommit=`git rev-parse --short HEAD`" && \

    apk del build-deps && \
    rm -rf /usr/lib/go && \
    rm -rf "${GOPATH}"

# Build mkr
ENV MKR_VERSION="0.16.1"
RUN set -e && \
    apk --no-cache --update add --virtual build-deps git go build-base && \

    mkdir -p "${GOPATH}/src/github.com/mackerelio/" && \
    cd "${GOPATH}/src/github.com/mackerelio/" && \
    git clone --depth 1 --branch v${MKR_VERSION} https://github.com/mackerelio/mkr && \
    cd mkr && \
    make deps && \
    go build -o /usr/bin/mkr \
      -ldflags="-w -s \
        -X main.Version=${MKR_VERSION}" && \

    apk del build-deps && \
    rm -rf /usr/lib/go && \
    rm -rf "${GOPATH}"

RUN set -e && \
    apk --no-cache --update add ca-certificates docker && \
    cp /usr/bin/docker /usr/bin/docker.org && \
    apk del docker && \
    mv /usr/bin/docker.org /usr/bin/docker

CMD [ "mackerel-agent" ]
