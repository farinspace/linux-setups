#!/bin/bash

DIR='/var/www/project/html'

SVNURL='svn://svn.farinspace.net/dimas/project'

WEBUSER='www-data'

CURRENT="$( cd "$( dirname "$0" )" && pwd )"

FILE="$CURRENT/up.sh"
if [ -f $FILE ];
then
   source "$FILE"
fi

