set -x
set -o errexit
set -o nounset
#set -o pipefail

PROJECT_ROOT=$(cd $(dirname "$0")/.. ; pwd)
CODEGEN_PKG=${PROJECT_ROOT}/vendor/k8s.io/kube-openapi
VERSION="v1alpha1"

export GO111MODULE=off
go build -o dist/openapi-gen ${CODEGEN_PKG}/cmd/openapi-gen
go build -o dist/gen-crd-spec ${CODEGEN_PKG}/cmd/gen-crd-spec


./dist/openapi-gen \
  --go-header-file ${PROJECT_ROOT}/hack/custom-boilerplate.go.txt \
  --input-dirs github.com/vathsalashetty25/argo-cd/pkg/apis/application/${VERSION} \
  --output-package github.com/vathsalashetty25/argo-cd/pkg/apis/application/${VERSION} \
  --report-filename pkg/apis/api-rules/violation_exceptions.list \
  $@

./dist/gen-crd-spec \
  --report-filename ${PACKAGES}/hack/installers/gen-crd-spec \
  
./dist/gen-crd-spec
