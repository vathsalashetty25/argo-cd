FROM golang:1.14.12-buster as argocd-build

WORKDIR /go/src/github.com/argoproj/argo-cd

RUN go get golang.org/x/tools/cmd/goimports

COPY go.mod go.mod
COPY go.sum go.sum


RUN go mod download

#RUN go mod vendor
#RUN go mod download

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
    
WORKDIR /go/src/github.com/argoproj/argo-cd




ADD hack/install.sh .
ADD hack/installers installers
ADD hack/tool-versions.sh .
ADD hack hack

#RUN go clean -modcache

#RUN go get sigs.k8s.io/controller-tools/cmd/controller-gen@v0.3.0
#ENV PATH=$PATH:/usr/local/go/bin:$GOPATH/bin
#RUN ./hack/update-codegen.sh
RUN go mod vendor

RUN go get sigs.k8s.io/controller-tools/cmd/controller-gen@v0.3.0

#RUN ./hack/update-codegen.sh
#RUN ./hack/update-manifests.sh
#RUN ./hack/generate-proto.sh
RUN ./hack/update-openapi.sh
