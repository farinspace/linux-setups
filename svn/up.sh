#!/bin/bash

if [ -z "$WEBUSER" ];
then
    echo "Web user url required (the user the web server runs as), can not continue ..."
    exit 1
fi

if [ -z "$SVNURL" ];
then
    echo "SVN url required (the projects root url), can not continue ..."
    exit 1
fi

while getopts ":b:" opt; do
    case $opt in
        b)
            BRANCH=$OPTARG
            ;;
        \?)
            echo "Invalid option: -$OPTARG"
            exit 1
            ;;
        :)
            echo "Option -$OPTARG requires a value"
            exit 1
            ;;
    esac
done

if [ $(whoami) != 'root' ];
then
    echo "You can not run this script as \"$(whoami)\" ..."
    exit 1
fi

if [ -z "$DIR" ];
then
    echo "Root directory required (the web app root directory), can not continue ..."
    exit 1
fi

if ! hash svn 2>/dev/null;
then
    echo "SVN client required (the svn command is not available), can not continue ..."
    exit 1
fi

if [ -d "$DIR" ];
then
    if [ -z "$BRANCH" ];
    then
        echo -n "Branch to switch to? [e.g. branches/custom] "
        read BRANCH
    fi

    if [ -z "$BRANCH" ];
    then
        echo "Branch required, can not continue ..."
        exit 1
    fi

    if [ "$DIR" ];
    then
        echo "Switching to \"$BRANCH\" ..."

        svn switch $SVNURL/$BRANCH $DIR

        svn info $DIR > $DIR/version.txt

        svn info $DIR >> $DIR/version-history.txt

        chown -R $WEBUSER:$WEBUSER $DIR
    fi
fi
