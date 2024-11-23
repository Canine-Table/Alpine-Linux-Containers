#!/bin/sh

(
        docker container ls -a | sed -n '2,$p' | awk '{print $1}' |
        while read -r i; do
                docker container rm -f "$i" &
        done > /dev/null
)
