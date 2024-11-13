#!/bin/sh

sanitize() {
        echo -n $* | awk '{
                for (i = 1; i <= length($0); i++) {
                        str = substr($0, i, 1)
                        
                        if (str == "\x3a" || str == "\x5c" || str == "\x27" || str == "\x22" || str == "\x5e" || str == "\x7e"  || str == "\x40"  || str == "\x3f"  || str == "\x7c"  || str == "\x7d"  || str == "\x7b"  || str == "\x5d"  || str == "\x5b"  || str == "\x3e"  || str == "\x3c"  || str == "\x21"  || str == "\x60"  || str == "\x2c"  || str == "\x2b"  || str == "\x2a"  || str == "\x26"  || str == "\x24"  || str == "\x23"  || str == "\x25"  || str == "\x20"  || str == "\x3b"  || str == "\x29"  || str == "\x28")
                                printf("_")
                        else
                                printf("%s", str)
                }
        }'
        
}
