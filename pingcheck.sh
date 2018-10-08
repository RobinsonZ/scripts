#!/usr/bin/env bash

# A short script to test internet connectivity. Pings (in succession) loopback/localhost, 
# whatever the default gateway is (if it exists) and Google's public DNS.
# Requires netstat and sed.

echo "Starting ping test"

docheck() {
  if ping -o -t 5 $1 > /dev/null
  then
    echo "$1 is up"
  else
    echo "Could not ping $1"
  fi
}

echo "Checking localhost..."
docheck localhost

if command -v netstat > /dev/null && command -v sed > /dev/null ;
then
GATEWAY_ADDR=`netstat -r -f inet | sed -n -e 's/^default \+\([^ ]\+\).*$/\1/p'`
if [[ ! -z $GATEWAY_ADDR ]] ; then
  echo "Checking gateway..."
  docheck $GATEWAY_ADDR
else
  echo "Could not determine gateway"
fi
else
echo "Could not determine gateway; make sure netstat and sed are installed"
fi

echo "Checking internet (Google DNS)..."
docheck 8.8.8.8
