#!/bin/bash
set -euo pipefail

find ./xspec -name "*.xspec" \( -exec ./scripts/run-xspec.sh {} \; -o -quit \)

if [ -f errors ]; then 
	rm errors
	1>&2 echo 'Some tests failed. See artifacts/xspec'
	exit 1
else 
	1>&2 echo 'All tests passed. See artifacts/xspec for details.'	
fi

