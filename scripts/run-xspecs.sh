#!/bin/bash
set -euo pipefail

find ./xspec -name "*.xspec" \( -exec ./scripts/run-xspec.sh {} \; -o -quit \)

if [ -f errors ]; then 
	rm errors
	echo 'Some tests failed. See artifacts/xspec'
	exit 1
fi

