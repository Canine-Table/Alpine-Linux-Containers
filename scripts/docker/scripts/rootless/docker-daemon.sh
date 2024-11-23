#!/bin/sh

mkdir -p /home/sandbox/.config/docker/
cat > /home/sandbox/.config/docker/daemon.conf << 'EOS'
{
        "userns-remap": "sandbox",
        "exec-opts": [
                "native.cgroupdriver=cgroup2"
        ],
        "network": { "driver": "bypass4netns" },
        "storage-driver": "overlay2",
        "iptables": true,
        "ip6tables": true,
        "experimental": false,
        "live-restore": true,
        "ipv6": true,
        "no-new-privileges": false
}
EOS
