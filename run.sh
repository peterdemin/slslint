#!/bin/bash -x

ROOT=$(cd "$(dirname ${BASH_SOURCE[0]})/.." && pwd)

docker run -it -v $ROOT/srv:/srv -v $ROOT/linter/logs:/logs salt-linter slslint
