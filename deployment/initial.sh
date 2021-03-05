#!/bin/bash
cp -R . ../../
cd ../../
mv redeploy.settings.dist redeploy.settings
git clone https://github.com/acdh-oeaw/vicav-content
cd vicav-app
npm install
cd ..
exec ./redeploy.sh