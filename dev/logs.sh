#!/usr/bin/env sh

set -x

NAME=${1:-sweguide-dev}
docker logs -f ${NAME}
