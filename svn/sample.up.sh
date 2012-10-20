#!/bin/bash

DIR='/var/www/project/html'

SVNURL='svn://svn.farinspace.net/dimas/project'

WEBUSER='wwww-data'

CURRENT="$( cd "$( dirname "$0" )" && pwd )"

source "$CURRENT/up.sh"
