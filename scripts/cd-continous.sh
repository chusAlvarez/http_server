#!/bin/bash

CURRENT=$1
HELMDIR=$2
REGISTRY="index.docker.io"
REPOSITORY="chusalvarez/adjust"
re='^[0-9]+$'

CURRENT=`echo $CURRENT | tr -d '"'`

while [ 1 ]
do

    TAGS="`wget -qO- http://$REGISTRY/v1/repositories/$REPOSITORY/tags`"

    NAMES=`echo $TAGS | jq .[].name`

    for TAG in $NAMES
    do
        echo $TAG
        TAG=`echo $TAG | tr -d '"'`

        if ! [[ $TAG =~ $re ]] ; then
            continue
        fi
        if [[ $TAG -gt $CURRENT ]]; then
            echo "found higer"
            cd $HELMDIR
            helm upgrade adjust  -f values.yaml --set image.tag=$TAG .
            $CURRENT = $TAG
        fi
    done
    sleep 5
done