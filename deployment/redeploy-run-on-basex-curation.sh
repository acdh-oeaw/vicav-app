#!/bin/bash
# Note: The authorative verion of this file is called redeploy-run-on-basex-curation.sh and lives on
# the production instance (currently: vicav project on apollo). When running redeploy.sh on the 
# it will be copied over to the curation instance, renamed to "redeploy.sh" and executed there. 
#
# So if you are editing "redeploy.sh" on the curation instance, be aware that any change 
# will be overwritten by the authorative version on the production instance.
# needs export USERNAME and export PASSWORD
~/execute-basex-batch.sh backup-vicav 2>&1
mkdir -p ~/redeploy
rm -v ~/redeploy/* 2>&1
mv -v ~/basex/data/*.zip ~/redeploy 2>&1
rm -v ~/redeploy/*__hist* 2>&1
rm -v ~/redeploy/*__lcks* 2>&1
