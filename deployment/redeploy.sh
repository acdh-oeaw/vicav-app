#!/bin/bash
# Run this script to update the VICAV instance to the latest versions. 
# It ...
# * pulls the current code of the web application from github.
# * pulls the current content of the web application from github.
# * optionally creates a backup of the dictionary data on vle-curation
# * copies it to this basex setup and restores it there
#
# Note: Assumes backup-vicav.bxs, redeploy-run-on-basex-curation.sh,
# clean-redeploy.bxs, deploy-vicav-content.bxs
# and this file are in the root directory of your basex setup.
# It assumes VICAV content is in the vicav-content directory
# and that the VICAV webapp is in the webapp/vicav-app directory
# Needs git and ssh for contacting the curation instance (see switches).

cd $(dirname $0)

TEMP=$(getopt -o 'cn' --long 'from-curation,no-ssh' -n $0 -- "$@")

if [ $? -ne 0 ]; then
        echo 'Terminating...' >&2
        exit 1
fi

# Note the quotes around "$TEMP": they are essential!
eval set -- "$TEMP"
unset TEMP

while true; do
        case "$1" in
                '-c'|'--from-curation')
                        export fromcuration='true'
                        shift
                        continue
                ;;
                '-n'|'--no-ssh')
                        export nossh='true'
                        shift
                        continue
                ;;
                '--')
                        shift
                        break
                ;;
                *)
                        echo 'Internal error!' >&2
                        exit 1
        esac
done

#------ For Password only once -------
if [ "$nossh"x = x  ]
then
if [ -z ${SSH_AUTH_SOCK+x} ]
then if [ "$OSTYPE" = "msys" -o "$OSTYPE" = "win32" ]
 then ssh-pageant ./redeploy.sh; exit $?
 else ssh-agent ./redeploy.sh; exit $?
 fi
fi
fi

if [ ! -f redeploy.settings ]
then echo Missing settings file. Please copy redeploy.settings.dist to redeploy.settings and fill in the credentials.
fi

. redeploy.settings

if [ "$local_username"x = x -o "$local_password"x = x ]; then echo Missing credentials for local BaseX; exit 1; fi
#------ Settings ---------------------
export USERNAME=$local_username
export PASSWORD=$local_password
curation=$curation
access_id=$curation_access_id
#-------------------------------------

if [ "$access_id"x != x ]
then if [ -r $access_id ]
then
#------ Stops if passphrase is wrong -
  ssh-add $access_id
  ret=$?
  if [ $ret != "0" ]; then exit $ret; fi
#-------------------------------------
fi
fi

#------ Update XQuery code -----------
if [ -d webapp/wde_basex ]
then
pushd webapp/wde_basex
git reset --hard
git pull
if [ "$onlytags"x = 'truex' ]
then
latesttag=$(git describe --tags --abbrev=0)
else
latesttag=$(git describe --tags --always)
fi
echo checking out ${latesttag}
git -c advice.detachedHead=false checkout ${latesttag}
popd
fi
if [ -d ${BUILD_DIR:-../webapp/vicav-app} ]
then
  pushd ${BUILD_DIR:-../webapp/vicav-app}
  git reset --hard
  git pull
  ret=$?
  if [ $ret != "0" ]; then exit $ret; fi
  if [ "$onlytags"x = 'truex' ]
  then
    uiversion=$(git describe --tags --abbrev=0)
  else
    uiversion=$(git describe --tags --always)
  fi
  echo checking out UI ${uiversion}
  git -c advice.detachedHead=false checkout ${uiversion}
  find ./ -type f -and \( -name '*.js' -or -name '*.html' \) -not \( -path './node_modules/*' -or -path './cypress/*' \) -exec sed -i "s~\@version@~$uiversion~g" {} \;
  popd
fi
#-------------------------------------

#------ Update content data from redmine git repository 
echo updating vicav_content 
if [ ! -d vicav-content/.git ]; then echo "vicav_content does not exist or is not a git repository"; fi
pushd vicav-content
git reset --hard
git pull
ret=$?
if [ $ret != "0" ]; then exit $ret; fi
if [ "$onlytags"x = 'truex' ]
then
dataversion=$(git describe --tags --abbrev=0)
else
dataversion=$(git describe --tags --always)
fi
echo checking out data ${dataversion}
git -c advice.detachedHead=false checkout ${dataversion}
who=$(git show -s --format='%cN')
when=$(git show -s --format='%as')
message=$(git show -s --format='%B')
revisionDesc=$(sed ':a;N;$!ba;s/\n/\\n/g' <<EOF
<revisionDesc>
  <change n="$dataversion" who="$who" when="$when">
$message
   </change>
</revisionDesc>
EOF
)
#------- copy all images into the "images" directory in the web application directory
echo "copying image files from vicav_content to vicav-webapp"
for d in $(ls -d vicav_*)
do echo "Directory $d:"
   find "$d" -type f -and \( -name '*.jpg' -or -name '*.JPG' -or -name '*.png' -or -name '*.PNG' -or -name '*.svg' \) -exec cp -v {} ${BUILD_DIR:-../webapp/vicav-app}/images \;
   if [ "$onlytags"x = 'truex' ]
   then
     find "$d" -type f -and -name '*.xml' -exec sed -i "s~\(</teiHeader>\)~$revisionDesc\\n\1~g" {} \;
   fi
done
#------- copy all sound files into the "/sounds" directory in BaseX' static directory
#------- this solves problems with MacOS Safari which wants the audio files in chunks
#------- else it claims they are not available/broken
echo "copying sound files from vicav_content to BaseX static/sound"
mkdir -p ${BUILD_DIR:-../webapp}/static/sound
for d in $(ls -d vicav_*)
do echo "Directory $d:"
   find "$d" -type f -and \( -name '*.m4a' \) -exec cp -v {} ${BUILD_DIR:-../webapp}/static/sound \;
done
#------- copy the apkg file into the "/anki" directory in BaseX' static directory
echo "copying anki files from vicav_content to BaseX static/anki"
mkdir -p ${BUILD_DIR:-../webapp}/static/anki
for d in $(ls -d vicav_*)
do echo "Directory $d:"
   find "$d" -type f -and \( -name '*.apkg' \) -exec cp -v {} ${BUILD_DIR:-../webapp}/static/anki \;
done
popd
pushd ${BUILD_DIR:-webapp/vicav-app}
find ./ -type f -and \( -name '*.js' -or -name '*.html' \) -not \( -path './node_modules/*' -or -path './cypress/*' \) -exec sed -i "s~\@data-version@~$dataversion~g" {} \;
popd
sed -i "s~webapp/vicav-app/~${BUILD_DIR:-webapp/vicav-app}/~g" deploy-vicav-content.bxs
./execute-basex-batch.sh deploy-vicav-content
pushd vicav-content
popd

#-------------------------------------
if [ "$fromcuration"x = 'truex' ]
then if [ "$curation_username"x != x -a "$curation_password"x != x ]
then
if [ "$nossh"x = x ]
then
#------ Update dictionary data from BaseX curation ------------
scp redeploy-run-on-basex-curation.sh $curation:~/redeploy.sh
scp backup-vicav.bxs $curation:~/basex/
ssh $curation "export USERNAME=$curation_username; export PASSWORD=$curation_password; bash ~/redeploy.sh"
scp $curation:~/redeploy/* data/
ssh $curation rm -rfv ~/redeploy
fi
ls data/*.zip 2>&1
./execute-basex-batch.sh clean-redeploy # 2>&1
echo restore command deletes the zip files
ls data/*.zip 2>&1
# rm -v ~/basex/data/*.zip 2>&1
else echo No credentials for curation BaseX but fromcuration was requested; exit 1
fi
fi
