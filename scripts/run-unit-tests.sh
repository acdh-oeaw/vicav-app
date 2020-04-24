#!/bin/bash
set -euo pipefail

find ./xunit -name "*.xqm" -exec ${CI_BUILDS_DIR}/../bin/basex -t {} \;