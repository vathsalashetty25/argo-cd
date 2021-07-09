FROM golang:1.14.12-buster as argocd-build



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

RUN ./install.sh packr-linux
RUN ./install.sh kubectl-linux
RUN ./install.sh ksonnet-linux
RUN ./install.sh helm2-linux
RUN ./install.sh helm-linux
RUN ./install.sh kustomize-linux
RUN ./install.sh swagger-linux


COPY go.mod go.mod
COPY go.sum go.sum
RUN go mod download
RUN go mod vendor

RUN ./hack/update-codegen.sh
RUN helm2 init --client-only
RUN ./hack/update-manifests.sh


