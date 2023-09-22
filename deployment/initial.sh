#!/bin/bash

CONTENT_REPO=${CONTENT_REPO:-https://github.com/acdh-oeaw/vicav-content}
CONTENT_BRANCH=${CONTENT_BRANCH:-master}
PORT=${PORT:-8984}
branch_name=$(git rev-parse --abbrev-ref HEAD)
# Just do that again in case the user didn't remember
git submodule update --init
cp -Rv ./deployment/* ${1:-../../}
npm install --production
pushd ${1:-../../}
source data/credentials
local_password=${BASEX_admin_pw:-admin}
git clone $CONTENT_REPO -b $CONTENT_BRANCH
cp -Rv ./*-{content,data}/deployment/* .
mv redeploy.settings.dist redeploy.settings
sed -e "s~local_password=.*~local_password='$local_password'~g" -i'' redeploy.settings
popd
if [ $branch_name == "devel" ]
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
sed -i 's~https://petstore.swagger.io/v2/swagger.json~/vicav/openapi.json~g' resources/swagger-ui-dist/index.html
rm content/openapi-test*.xqm
popd

pwd=$(pwd)
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
else
sed -i "s~^WEBPATH.*~WEBPATH = $pwd~" $1/.basex
fi

curl --connect-timeout 5 --max-time 10 --retry 3 --retry-delay 0  --retry-max-time 40 --retry-connrefused 3 \
     -X POST "http://localhost:$PORT/restvle/dicts" -H "accept: application/vnd.wde.v2+json" -H "Content-Type: application/json" -d "{\"name\":\"dict_users\"}"
curl -X POST "http://localhost:$PORT/restvle/dicts/dict_users/users" -H "accept: application/vnd.wde.v2+json" -H "Content-Type: application/json" -d "{\"id\":\"\",\"userID\":\"admin\",\"pw\":\"$local_password\",\"read\":\"y\",\"write\":\"y\",\"writeown\":\"n\",\"table\":\"dict_users\"}"
exec ./redeploy.sh
