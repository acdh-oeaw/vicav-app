#!/bin/bash
set -euo pipefail

find ./xunit -name "*.xqm" \( -exec ./scripts/run-test.sh {} \; -o -quit \)

if [ -f errors ]; then 
	rm errors
	1>&2 echo 'Some tests failed. See artifacts/XUNIT_OUT.txt'
	exit 1
fi
