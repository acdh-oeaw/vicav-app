#!/bin/bash

CONTENT_REPO=${CONTENT_REPO:-https://github.com/acdh-oeaw/vicav-content}
cp -Rv ./deployment/* ${1:-../../}
npm install
cd ${1:-../../}
git clone $CONTENT_REPO
cp -Rv ./*-content/deployment/* .
mv redeploy.settings.dist redeploy.settings
if [ "${STACK}x" = "x" ]; then
pushd lib/custom
curl -LO https://repo1.maven.org/maven2/net/sf/saxon/Saxon-HE/11.4/Saxon-HE-11.4.jar
curl -LO https://repo1.maven.org/maven2/org/xmlresolver/xmlresolver/4.6.4/xmlresolver-4.6.4.jar
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
