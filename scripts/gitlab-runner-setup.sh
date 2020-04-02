#!/bin/bash
set -euo pipefail

cd ${CI_BUILDS_DIR} # this is usually the webapp directory of the BaseX instance
rm -rf vicav_content 2>/dev/null
git clone ${VICAV_CONTENT_REPO} --branch master vicav_content
cd vicav_content
#for d in $(ls | grep vicav_); do cp -rv ${d} ${GIT_CLONE_PATH}; done;
for d in vicav_*; do echo "Directory $d:"; find "$d" -type f -regextype posix-egrep -regex '.*(jpg|JPG|png|PNG|svg)' -exec cp {} ${GIT_CLONE_PATH}/images -v \; ; done

cd ${GIT_CLONE_PATH}/cypress/fixtures
for d in $(ls | grep vicav_); do cp -rv ${d} ${CI_BUILDS_DIR}/vicav_content; done;

echo "<commands>
	<set option='CHOP'>false</set>
	<create-db name='vicav_corpus'>${CI_BUILDS_DIR}/vicav_content/vicav_corpus</create-db>
	<create-db name='vicav_lingfeatures'>${CI_BUILDS_DIR}/vicav_content/vicav_lingfeatures</create-db>
	<create-db name='vicav_profiles'>${CI_BUILDS_DIR}/vicav_content/vicav_profiles</create-db>
	<create-db name='vicav_samples'>${CI_BUILDS_DIR}/vicav_content/vicav_samples</create-db>
	<create-db name='vicav_texts'>${CI_BUILDS_DIR}/vicav_content/vicav_texts</create-db>
	<create-db name='vicav_biblio'>${CI_BUILDS_DIR}/vicav_content/vicav_biblio</create-db>
</commands>" > deploy-vicav.bxs

${CI_BUILDS_DIR}/../bin/basexclient -Uadmin -Padmin -c ./deploy-vicav.bxs

