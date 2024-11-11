#!/bin/sh

rename_interface()
{
        ip link show "$1" > /dev/null 2>&1 && ip link set dev "$1" name "$2"
        return 0
}

up_interface()
{
        ip link show "$1" > /dev/null 2>&1 && ip link set "$1" up
}

down_interface()
{
        ip link show "$1" > /dev/null 2>&1 && ip link set "$1" down
}

del_alt()
{
        ip link property del dev "$1" altname "$2"
        return 0
}

add_alt()
{
        ip link property add dev "$1" altname "$2"
        return 0
}

add_alias()
{
        ip link set dev "$1" alias "$2"
}

interfaces()
{
        down_interface eth0

        rename_interface eth0 intel

        up_interface intel && {
                add_alt intel wired
                add_alias intel "Intel is the wired interface."
        }

        add_alt lo loopback
        add_alias lo "lo is the Loopback interface for internal traffic"

        return 0
}

interfaces > /dev/null 2>&1
exit 0

