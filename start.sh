#!/usr/bin/env bash

set -e

export PLATFORM='unknown'
unamestr="$(uname)"
if [ "$unamestr" == 'Linux' ]; then
     export PLATFORM='linux'
elif [ "$unamestr" == 'FreeBSD' ]; then
     export PLATFORM='freebsd'
elif [ "$unamestr" == 'Darwin' ]; then
    export PLATFORM='osx'
fi

if [ -f platforms/$PLATFORM ]; then
  . platforms/$PLATFORM
fi
