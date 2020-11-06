#!/bin/bash

out=$(${CI_BUILDS_DIR}/../xspec/bin/xspec.sh ${1} 2>&1)

if [[ "$(echo $out | grep 'failed: 0')" == '' ]]; then
	echo $out > errors
	exit 1
fi