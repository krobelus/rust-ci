#!/bin/bash

ORDER=$(
    for FILE in *.Dockerfile; do
        echo ${FILE%.*} ${FILE%.*};
        sed "s/^# dep /${FILE%.*} /;t;d" $FILE;
    done | tsort | tac
)


for IMAGE in $ORDER; do
    echo $IMAGE
    CACHE=$(sed "s/^# dep /jixone\/rust-ci:/;t;d" $IMAGE.Dockerfile | tr '\n' ',')jixone/rust-ci:$IMAGE

    docker pull jixone/rust-ci:$IMAGE  || true

    docker build --cache-from $CACHE -t jixone/rust-ci:$IMAGE -f $IMAGE.Dockerfile .

    docker push jixone/rust-ci:$IMAGE
done
