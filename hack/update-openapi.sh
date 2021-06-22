set -x
set -o errexit
set -o nounset
#set -o pipefail

PROJECT_ROOT=$(cd $(dirname "$0")/.. ; pwd)
CODEGEN_PKG=${PROJECT_ROOT}/vendor/k8s.io/kube-openapi
VERSION="v1alpha1"

export GO111MODULE=off
go build -o dist/openapi-gen ${CODEGEN_PKG}/cmd/openapi-gen

./dist/openapi-gen \
  --go-header-file ${PROJECT_ROOT}/hack/custom-boilerplate.go.txt \
  --input-dirs github.com/argoproj/argo-cd/pkg/apis/application/${VERSION} \
  --output-package github.com/argoproj/argo-cd/pkg/apis/application/${VERSION} \
  

