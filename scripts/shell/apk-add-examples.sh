#!/bin/sh

bmv() {
        (
                for I in "$(pwd)/"*; do
                        mv "$I" "$(date +"%s")_$(echo $I | sed '
                                s/[)( ]/_/g;
                        ' | tr -dc [:alnum:]\._-)_$(cat /dev/urandom | tr -dc [:alnum:] | head -c 16)"
                done
        )
}
