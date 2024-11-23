#!/bin/sh

(
        docker image ls -a | sed -n '2,$p' | awk '{
                if ($1 == $2 && $2 == "<none>")
                        print $3
        }' | while read -r i; do
                docker image rm -f "$i" &
        done > /dev/null
)
