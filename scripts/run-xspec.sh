#!/bin/bash
set -euo pipefail

${CI_BUILDS_DIR}/../xspec/bin/xspec.sh ${1} 2>&1

success=$(${CI_BUILDS_DIR}/../xspec/bin/xspec.sh ${1} 2>&1)

if [[ "$(echo ${success} | grep 'failed: 0')" == "" ]]; then
	echo ${success} >> errors
	exit 1
fi