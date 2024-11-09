#!/bin/sh

(
        for I in $(
                docker container ls -a --format='{{.Names}} {{.ID}}' | awk '{
                        if ($1 ~ /^example_[[:alnum:]]{16}$/) {
                                print $2
                        }   
                }'
        ); do
                (
                    docker container stop $I
                    docker container rm $I
                ) &
        done
)
