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
if [ "$OSTYPE" == "msys" -o "$OSTYPE" == "win32" ]
then
if [[ "$BATCHFILE" == *.xql ]]; then
   echo "executing XQuery script $BATCHFILE"
   exec bin/basexclient.bat -U$USERNAME -P$PASSWORD "RUN ../$BATCHFILE" 
else
  echo "executing BaseX script $BATCHFILE"
  exec bin/basexclient.bat -U$USERNAME -P$PASSWORD -c "RUN ../$BATCHFILE.bxs"
fi
else
if [[ "$BATCHFILE" == *.xql ]]; then
   echo "executing XQuery script $BATCHFILE"
   exec bin/basexclient -U$USERNAME -P$PASSWORD "RUN ../$BATCHFILE" 
else
  echo "executing BaseX script $BATCHFILE"
  exec bin/basexclient -U$USERNAME -P$PASSWORD -c "RUN ../$BATCHFILE.bxs"
fi
fi
