FROM ailispaw/ubuntu-essential:14.04-nodoc

RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get -q update && \
    apt-get -q -y install --no-install-recommends curl ca-certificates git make build-essential && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

ENV GOVERSION=1.8.3 \
    GOROOT=/goroot \
    GOPATH=/gopath
ENV PATH ${PATH}:${GOROOT}/bin:${GOPATH}/bin

RUN mkdir -p ${GOROOT} && \
    curl https://storage.googleapis.com/golang/go${GOVERSION}.linux-amd64.tar.gz \
      | tar xvzf - -C ${GOROOT} --strip-components=1

# Build mackerel-agent
ENV AGENT_VERSION="0.47.0"
RUN mkdir -p "${GOPATH}/src/github.com/mackerelio/" && \
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

    rm -rf "${GOPATH}"

# Build mackerel-plugin
ENV PLUGIN_VERSION="0.37.0"
RUN mkdir -p "${GOPATH}/src/github.com/mackerelio/" && \
    cd "${GOPATH}/src/github.com/mackerelio/" && \
    git clone --depth 1 --branch v${PLUGIN_VERSION} https://github.com/mackerelio/mackerel-agent-plugins && \
    cd mackerel-agent-plugins && \
    make deps && \
    go build -o /usr/bin/mackerel-plugin \
      -ldflags="-w -s \
        -X main.version=${PLUGIN_VERSION} \
        -X main.gitcommit=`git rev-parse --short HEAD`" && \

    rm -rf "${GOPATH}"

# Build mkr
ENV MKR_VERSION="0.21.0"
RUN mkdir -p "${GOPATH}/src/github.com/mackerelio/" && \
    cd "${GOPATH}/src/github.com/mackerelio/" && \
    git clone --depth 1 --branch v${MKR_VERSION} https://github.com/mackerelio/mkr && \
    cd mkr && \
    make deps && \
    go build -o /usr/bin/mkr \
      -ldflags="-w -s \
        -X main.Version=${MKR_VERSION}" && \

    rm -rf "${GOPATH}"

CMD [ "mackerel-agent" ]
