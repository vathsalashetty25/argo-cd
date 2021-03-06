#! /usr/bin/env bash
set -x
set -o errexit
set -o nounset
set -o pipefail

KUSTOMIZE=kustomize

SRCROOT="$( CDPATH='' cd -- "$(dirname "$0")/.." && pwd -P )"
AUTOGENMSG="# This is an auto-generated file. DO NOT EDIT"

cd ${SRCROOT}/hack/manifests/ha/base/redis-ha && ./generate.sh

IMAGE_NAMESPACE="${IMAGE_NAMESPACE:-docker.pkg.github.com/vathsalashetty25/repo-for-images/argocd}"
IMAGE_TAG="${IMAGE_TAG:-1.9.0-c74c6979}"

# if the tag has not been declared, and we are on a release branch, use the VERSION file.
if [ "$IMAGE_TAG" = "" ]; then
  branch=$(git rev-parse --abbrev-ref HEAD)
  if [[ $branch = release-* ]]; then
    pwd
    IMAGE_TAG=v$(cat $SRCROOT/VERSION)
  fi
fi
# otherwise, use latest
if [ "$IMAGE_TAG" = "" ]; then
  IMAGE_TAG=latest
fi

$KUSTOMIZE version

cd ${SRCROOT}/hack/manifests/base && $KUSTOMIZE edit set image quay.io/argoproj/argocd=${IMAGE_NAMESPACE}/argocd:${IMAGE_TAG}
cd ${SRCROOT}/hack/manifests/ha/base && $KUSTOMIZE edit set image quay.io/argoproj/argocd=${IMAGE_NAMESPACE}/argocd:${IMAGE_TAG}

echo "${AUTOGENMSG}" > "${SRCROOT}/hack/manifests/install.yaml"
$KUSTOMIZE build "${SRCROOT}/hack/manifests/cluster-install" >> "${SRCROOT}/hack/manifests/install.yaml"

echo "${AUTOGENMSG}" > "${SRCROOT}/hack/manifests/namespace-install.yaml"
$KUSTOMIZE build "${SRCROOT}/hack/manifests/namespace-install" >> "${SRCROOT}/hack/manifests/namespace-install.yaml"

echo "${AUTOGENMSG}" > "${SRCROOT}/hack/manifests/ha/install.yaml"
$KUSTOMIZE build "${SRCROOT}/hack/manifests/ha/cluster-install" >> "${SRCROOT}/hack/manifests/ha/install.yaml"

echo "${AUTOGENMSG}" > "${SRCROOT}/hack/manifests/ha/namespace-install.yaml"
$KUSTOMIZE build "${SRCROOT}/hack/manifests/ha/namespace-install" >> "${SRCROOT}/hack/manifests/ha/namespace-install.yaml"

