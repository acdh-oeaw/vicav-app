#!/bin/bash
set -euo pipefail

find ./xspec -name "*.xspec" \( -exec ./scripts/run-xspec.sh {} \; -o -quit \)

if [ -f errors ]; then 
	rm errors
	1>&2 echo 'Some tests failed. See artifacts/XUNIT_OUT.txt'
	exit 1
fi

