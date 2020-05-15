#!/bin/bash
set -euo pipefail

success=$(${CI_BUILDS_DIR}/../bin/xspec ${1} 2>&1)

if [[ "$(echo ${success} | grep 'failure: 0')" == "" ]]; then
	echo ${success} >> errors
	exit 1
fi