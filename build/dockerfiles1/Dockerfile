FROM golang@sha256:1f13bbbe77d79c5d1f6417f9e49365cd3c381520c79f21255fe8479809f01f84
RUN go version
RUN wget -O- -nv https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s v1.40.1

RUN golangci-lint --version
RUN export GOPATH=$HOME/go
RUN export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin
RUN set -x

RUN export GOPATH=$(go env GOPATH)
#RUN git checkout -- go.mod go.sum
  
RUN apt-get update && apt-get install -y \
    openssh-server \
    nginx \
    fcgiwrap \
    git \
    git-lfs \
    make \
    wget \
    gcc \
    zip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
    
WORKDIR /go/src/github.com/vathsalashetty25/argo-cd


COPY go.mod go.mod
COPY go.sum go.sum
RUN go mod download
 

ADD hack/install.sh .
ADD hack/installers installers
ADD hack/tool-versions.sh .
ADD hack hack

RUN ./install.sh protoc-linux
RUN ./install.sh swagger-linux
RUN ./install.sh jq-linux
RUN ./install.sh kustomize-linux
RUN ./install.sh helm2-linux
RUN ./install.sh helm-linux
#RUN go clean -modcache
#RUN ./hack/update-manifests.sh
#RUN go get sigs.k8s.io/controller-tools/cmd/controller-gen@v0.3.0
#ENV PATH=$PATH:/usr/local/go/bin:$GOPATH/bin
#RUN go mod tidy
#RUN go mod vendor
#RUN ./hack/update-openapi.sh
#RUN ./hack/generate-proto.sh
#RUN ./hack/update-codegen.sh

#RUN go mod vendor
#RUN ./hack/update-codegen.sh
#RUN ./hack/generate-proto.sh
#RUN ./hack/update-codegen.sh
#RUN ./install.sh kustomize-linux
#RUN helm2 init --client-only

#RUN ./hack/update-manifests.sh
#RUN ./hack/generate-proto.sh
RUN ./hack/update-openapi.sh
