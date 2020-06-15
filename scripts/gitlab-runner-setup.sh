#!/bin/bash
set -euo pipefail

cd ${CI_BUILDS_DIR} # this is usually the webapp directory of the BaseX instance
rm -rf xspec

rm -rf vicav_content 2>/dev/null
git clone ${VICAV_CONTENT_REPO} --branch master vicav_content
cd vicav_content
#for d in $(ls | grep vicav_); do cp -rv ${d} ${GIT_CLONE_PATH}; done;
for d in vicav_*; do echo "Directory $d:"; find "$d" -type f -regextype posix-egrep -regex '.*(jpg|JPG|png|PNG|svg)' -exec cp {} ${GIT_CLONE_PATH}/images -v \; ; done

${CI_BUILDS_DIR}/../bin/basexclient -Uadmin -Padmin -c "DROP DATABASE vicav_biblio; DROP DATABASE vicav_profiles; DROP DATABASE vicav_corpus; \
DROP DATABASE vicav_samples; DROP DATABASE vicav_lingfeatures"

echo "<commands>
	<set option='CHOP'>false</set>
	<create-db name='vicav_corpus'>${CI_BUILDS_DIR}/vicav_content/vicav_corpus</create-db>
	<create-db name='vicav_lingfeatures'>${GIT_CLONE_PATH}/fixtures/vicav_lingfeatures</create-db>
	<create-db name='vicav_profiles'>${CI_BUILDS_DIR}/vicav_content/vicav_profiles</create-db>
	<create-db name='vicav_texts'>${CI_BUILDS_DIR}/vicav_content/vicav_texts</create-db>
	<create-db name='vicav_samples'>${GIT_CLONE_PATH}/fixtures/vicav_samples/sampletexts.xml</create-db>
	<create-db name='vicav_biblio'>${CI_BUILDS_DIR}/vicav_content/vicav_biblio</create-db>
</commands>" > deploy-vicav.bxs

${CI_BUILDS_DIR}/../bin/basexclient -Uadmin -Padmin -c ./deploy-vicav.bxs

cd ${CI_BUILDS_DIR}/..
git clone "https://github.com/xspec/xspec.git" "xspec" 2> /dev/null || (cd xspec ; git pull)
export SAXON_CP=${CI_BUILDS_DIR}/../lib/custom/saxon9he.jar
