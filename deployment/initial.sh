#!/bin/bash

CONTENT_REPO=${CONTENT_REPO:-https://github.com/acdh-oeaw/vicav-content}
CONTENT_BRANCH=${CONTENT_BRANCH:-master}
branch_name=$(git rev-parse --abbrev-ref HEAD)
cp -Rv ./deployment/* ${1:-../../}
npm install
pushd ${1:-../../}
source data/credentials
local_password=${BASEX_admin_pw:-admin}
git clone $CONTENT_REPO -b $CONTENT_BRANCH
cp -Rv ./*-{content,data}/deployment/* .
mv redeploy.settings.dist redeploy.settings
sed -e "s/local_password=.*/local_password='$local_password'/g" -i'' redeploy.settings
popd
if [ $branch_name == "59-add-interactive-openapi-documentation" ]
then

pushd ${1:-../../} 
sed -e 's/onlytags=true.*/onlytags=false # enable for production/g' -i'' redeploy.settings
popd
  
pushd 3rd-party/openapi4restxq
git checkout master_basex
git pull
popd

pushd 3rd-party/vleserver_basex
git checkout main
git pull
popd

fi
pushd ${1:-../../} 
echo 'redeploy.settings content:'
cat redeploy.settings
popd

pushd 3rd-party/openapi4restxq
npm install
mv node_modules resources
rm content/openapi-test*.xqm
popd

pushd ${1:-../../}
if [ "${STACK}x" = "x" ]; then
pushd lib/custom
curl -LO https://repo1.maven.org/maven2/net/sf/saxon/Saxon-HE/12.2/Saxon-HE-12.2.jar
curl -LO https://repo1.maven.org/maven2/org/xmlresolver/xmlresolver/5.1.3/xmlresolver-5.1.3.jar
popd

if [ "$OSTYPE" == "msys" -o "$OSTYPE" == "win32" ]
then
  cd bin
  start basexhttp.bat
else
  cd bin
  ./basexhttp &
fi
cd ..
fi
exec ./redeploy.sh
