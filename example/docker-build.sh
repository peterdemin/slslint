#!/usr/bin/env bash

set -e

ROOT=$(cd "$(dirname ${BASH_SOURCE[0]})/.." && pwd)

docker build --rm -t slslint $ROOT
