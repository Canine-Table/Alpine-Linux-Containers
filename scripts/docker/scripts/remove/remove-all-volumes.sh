#!/bin/sh

(
        docker volume ls | awk '{print $2}' | sed -n '2,$p' |
        while read -r i; do
                docker volume rm -f "$i" &
        done > /dev/null
)
