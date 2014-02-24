#!/bin/bash
for file in *.rpm; do 
  package=`expr match "$file" '\(.*\)\.[a-z0-9]*\.rpm'`
  if ! rpm -qi $package > /dev/null; then 
    echo "$file"
  fi
done
