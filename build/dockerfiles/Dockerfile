FROM golang:1.14.12-buster as argocd-build

WORKDIR /go/src/github.com/vathsalashetty25/argo-cd
RUN go get golang.org/x/tools/cmd/goimports

COPY go.mod go.mod
COPY go.sum go.sum

RUN go mod download

# Perform the build
COPY . .
RUN make cli-local server controller repo-server argocd-util

ARG BUILD_ALL_CLIS=true
RUN if [ "$BUILD_ALL_CLIS" = "true" ] ; then \
    make CLI_NAME=argocd-linux-ppc64le GOOS=linux cli-local && \
    make CLI_NAME=argocd-linux-ppc64le.exe GOOS=linux cli-local \
    ; fi

  
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




ADD hack/install.sh .
ADD hack/installers installers
ADD hack/tool-versions.sh .
ADD hack hack


RUN ./install.sh protoc-linux
RUN ./install.sh swagger-linux
RUN ./install.sh jq-linux

COPY go.mod go.mod
COPY go.sum go.sum
RUN go mod download
#RUN go clean -modcache
#RUN ./hack/update-manifests.sh
#RUN go get sigs.k8s.io/controller-tools/cmd/controller-gen@v0.3.0
#ENV PATH=$PATH:/usr/local/go/bin:$GOPATH/bin
#RUN go mod tidy
#RUN go mod vendor
#RUN ./hack/update-openapi.sh
#RUN ./hack/generate-proto.sh
RUN ./hack/update-codegen.sh

RUN go mod vendor 


#RUN set -x
#RUN export GOPATH=$(go env GOPATH)
#RUN export GO111MODULE=off
#RUN ./hack/update-codegen.sh
#RUN ./hack/generate-proto.sh
#RUN ./hack/update-codegen.sh
#RUN ./install.sh kustomize-linux
#RUN helm2 init --client-only

#RUN ./hack/update-manifests.sh
RUN ./hack/generate-proto.sh
#RUN ./hack/update-openapi.sh
