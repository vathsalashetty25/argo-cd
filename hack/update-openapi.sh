set -x
set -o errexit
set -o nounset
#set -o pipefail

PROJECT_ROOT=$(cd $(dirname "$0")/.. ; pwd)


go build -o ./dist/gen-crd-spec ${PROJECT_ROOT}/hack/gen-crd-spec
./dist/gen-crd-spec
