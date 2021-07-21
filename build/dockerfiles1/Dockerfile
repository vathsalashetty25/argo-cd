ARG BASE_IMAGE=ubuntu:20.10
####################################################################################################
# Builder image
# Initial stage which pulls prepares build dependencies and CLI tooling we need for our final image
# Also used as the image in CI jobs so needs all dependencie
####################################################################################################
FROM golang:1.14.12 as builder

RUN echo 'deb http://deb.debian.org/debian buster-backports main' >> /etc/apt/sources.list

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

#ADD hack/install.sh .
#ADD hack/installers installers
#ADD hack/tool-versions.sh .
#ADD hack hack


RUN ./install.sh helm2-linux
RUN ./install.sh helm-linux
RUN ./install.sh kustomize-linux


#COPY go.mod go.mod
#COPY go.sum go.sum

#RUN go mod download


RUN helm2 init --client-only
RUN ./hack/update-manifests.sh

