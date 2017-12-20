FROM alpine:3.6

ENV GOPATH="/tmp/go"

# Build mackerel-agent
ENV AGENT_VERSION="0.48.2"
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
    rm -rf "${GOPATH}" && \
    rm -rf /tmp/* /var/cache/apk/*

# Build mackerel-plugin
ENV PLUGIN_VERSION="0.41.1"
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
    rm -rf "${GOPATH}" && \
    rm -rf /tmp/* /var/cache/apk/*

# Build mkr
ENV MKR_VERSION="0.24.1"
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
    rm -rf "${GOPATH}" && \
    rm -rf /tmp/* /var/cache/apk/*

RUN set -e && \
    apk --no-cache --update add ca-certificates docker && \
    cp /usr/bin/docker /usr/bin/docker.org && \
    apk del docker && \
    mv /usr/bin/docker.org /usr/bin/docker && \
    rm -rf /tmp/* /var/cache/apk/*

CMD [ "mackerel-agent" ]
