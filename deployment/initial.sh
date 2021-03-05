#!/bin/bash
cp -Rv ./deployment/* ../../
npm install
cd ../../
mv redeploy.settings.dist redeploy.settings
git clone https://github.com/acdh-oeaw/vicav-content
pushd lib/custom
curl -LO https://repo1.maven.org/maven2/net/sf/saxon/Saxon-HE/10.3/Saxon-HE-10.3.jar
popd
if [ "$OSTYPE" == "msys" -o "$OSTYPE" == "win32" ]
then
  cd bin
  start basexhttp.bat
else
  cd bin
  basexhttp &
fi
cd ..
exec ./redeploy.sh