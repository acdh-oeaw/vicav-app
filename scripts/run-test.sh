#!/bin/bash
set -euo pipefail

${CI_BUILDS_DIR}/../bin/basex -t ${1} 2> errors

if [[ "$(cat errors)" == "" ]]; then
	rm errors
fi