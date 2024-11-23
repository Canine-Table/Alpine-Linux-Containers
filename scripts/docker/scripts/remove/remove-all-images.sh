#!/bin/sh

(
        docker image ls -a | sed -n '2,$p' | awk '{print $3}' |
        while read -r i; do
                docker image rm -f "$i" &
        done > /dev/null
)
