#!/bin/sh

(
        CONTAINER_ID="$(
            UNIQUE="$(cat /dev/urandom | tr -dc [:alnum:] | head -c 16)"
            docker container run --detach \
                --network=bridge \
                --name example_${UNIQUE} \
                --label ${UNIQUE} \
                --hostname ${UNIQUE}.example.lab \
                --publish-all \
                alpine:latest ash -c "while :; do sleep 1; done"
        )" && {
            docker container exec --interactive --tty ${CONTAINER_ID} ash
        }
)
