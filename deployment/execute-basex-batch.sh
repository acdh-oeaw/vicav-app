#!/bin/bash
if [ -z "$USERNAME" ]; then
  echo -n 'Username for basex: '
  read USERNAME
else
  echo Using $USERNAME as user name
fi
if [ -z "$PASSWORD" ]; then
  echo -n 'Passowrd:'
  read -s PASSWORD
  echo
else
  echo Using password from environment
fi
if [ -z "$1" ]; then
  echo -n 'Batchfile (*.bxs) in batch folder to execute'
  read BATCHFILE;
else
  BATCHFILE="$1"
fi
pushd ${2:-.}/bin >/dev/null
if [[ "$BATCHFILE" == *.xq* ]]; then
  BATCHFILE=$(realpath "../$BATCHFILE")
else
  BATCHFILE=$(realpath "../$BATCHFILE.bxs")
fi
popd >/dev/null
if [ "$OSTYPE" == "msys" -o "$OSTYPE" == "win32" ]
then
if [[ "$BATCHFILE" == *.xq* ]]; then
   echo "executing XQuery script $BATCHFILE"
   exec bin/basexclient.bat -U$USERNAME -P$PASSWORD -c "XQUERY $(cat $BATCHFILE|tr -d '\r\n')"
else
  echo "executing BaseX script $BATCHFILE"
  exec bin/basexclient.bat -U$USERNAME -P$PASSWORD -c "RUN $(cygpath -w $BATCHFILE)"
fi
else
if [[ "$BATCHFILE" == *.xq* ]]; then
   echo "executing XQuery script $BATCHFILE using $(realpath ${2:-.}/bin/basexclient)"
   exec ${2:-.}/bin/basexclient -U$USERNAME -P$PASSWORD -c "XQUERY $(cat $BATCHFILE|tr -d '\r\n')"
else
  echo "executing BaseX script $BATCHFILE using $(realpath ${2:-.}/bin/basexclient)"
  exec ${2:-.}/bin/basexclient -U$USERNAME -P$PASSWORD -c "RUN $BATCHFILE"
fi
fi