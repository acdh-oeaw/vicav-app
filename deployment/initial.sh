#!/bin/bash

cp -Rv ./deployment/* ${1:-../../}
npm install
cd ${1:-../../}
mv redeploy.settings.dist redeploy.settings
git clone https://github.com/acdh-oeaw/vicav-content
if [ "${STACK}x" = "x" ]; then
pushd lib/custom
curl -LO https://repo1.maven.org/maven2/net/sf/saxon/Saxon-HE/11.3/Saxon-HE-11.3.jar
curl -LO https://repo1.maven.org/maven2/org/xmlresolver/xmlresolver/4.3.0/xmlresolver-4.3.0.jar
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
