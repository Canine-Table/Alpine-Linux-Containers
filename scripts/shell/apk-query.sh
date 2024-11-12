#!/bin/sh

(
        # Navigate to the temporary directory
        cd /tmp

        # Create a combined APKINDEX tar file from all matching files in /var/cache/apk/
        [ -f '/tmp/APKINDEX' ] || {
                for I in $(ls /var/cache/apk/ | awk '{
                        for (i = 0; i < NF; i++) {
                                if($i ~ /^APKINDEX[.][a-f0-9]{8}[.]tar[.]gz$/) 
                                        print $i
                        }
                }'); do
                        cat /var/cache/apk/$I
                done > /tmp/APKINDEX.tar.gz

                # Extract the combined APKINDEX file
                tar -xf /tmp/APKINDEX.tar.gz
        }

        # Find the package entry in the APKINDEX file
        I=$(($(
                grep -n '^P:' APKINDEX | awk -F ':' -v package="$1" '{
                        if ($3 == package) {
                                print $1
                                exit 0
                        }
                }') - 1
        ))

        # Display the package metadata
        sed -n $I',${
                s/^C:/Checksum:\n\t/; t cnt
                s/^P:/Package Name:\n\t/; t cnt
                s/^V:/Version and Release Number:\n\t/; t cnt
                s/^A:/Architecture:\n\t/; t cnt
                s/^S:/Package Size (Bytes):\n\t/; t cnt
                s/^I:/Install Size (Bytes):\n\t/; t cnt
                s/^T:/Package Description:\n\t/; t cnt
                s/^U:/URL:\n\t/; t cnt
                s/^L:/Licence:\n\t/; t cnt
                s/^o:/Origin:\n\t/; t cnt
                s/^m:/Maintainers:\n\t/; t cnt
                s/^t:/Build Timestamp (epoch):\n\t/; t cnt
                s/^c:/Commit Identifier:\n\t/; t cnt
                s/^D:/Dependencies:\n\t/; t cnt
                s/^p:/Provided Packages:\n\t/; t cnt
                s/^k:/Subpackages:\n\t/; t cnt
                s/^M:/Message:\n\t/; t cnt
                s/^i:/Installed Files:\n\t/; t cnt
                s/^e:/ABI Compatibility:\n\t/; t cnt
                p; q
                :cnt
                p
        }' APKINDEX 2>/dev/null || {
                grep '^P:' APKINDEX | awk -F ':' -v package="$1" '{
                        if ($2 ~ package)
                                print $2
                }'
        }

        # Clean up temporary files unless the keep flag is provided
        [ "$2" = -k -o "$2" = '--keep' ] || {
                for I in APKINDEX.tar.gz APKINDEX DESCRIPTION; do
                        rm -f $I
                done
        } &
) | $(
        # Display the output using less, more, or tee
        for I in less more tee; do
                command -v $I && exit;
        done

        # If no display command is found, fall back to true (does nothing) true
        true
)
