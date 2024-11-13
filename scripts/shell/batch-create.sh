#!/bin/sh

# Example 1
for i in $(seq 10); do
        for j in $(seq 10); do
                for k in $(seq 10); do
                        touch "$i $j ($k)"
                done

                touch "$i $k()"
        done
done

# Example 2
for i in $(seq 16); do
        touch "$i_$(cat /dev/urandom | tr -dc [:punct:][:alnum:] | head -c 16).txt" 2>/dev/null
done
