#!/usr/bin/env bash

set -e

HERE=$(cd "$(dirname ${BASH_SOURCE[0]})" && pwd)

docker build --rm -t slslint $HERE
