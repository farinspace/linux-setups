#!/bin/bash

CURRENT="$( cd "$( dirname "$0" )" && pwd )"

FILE="$CURRENT/dev.up.sh"
if [ -f $FILE ];
then
   source "$FILE"
fi

FILE="$CURRENT/dev2.up.sh"
if [ -f $FILE ];
then
   source "$FILE"
fi
