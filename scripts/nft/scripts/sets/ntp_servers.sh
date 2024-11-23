mkdir -p "$HOME"/.local/bin
cat > "$HOME"/.local/bin/ntp_servers.sh << 'EOS'
#!/bin/sh

. /etc/profile.d/00-functions.sh

mkdir -p /etc/nftables.d/ip
cat > /etc/nftables.d/ip/ntp.nft << EOF

set ip-ntp-servers {
        type ipv4_addr
        $(elements \
            pool.ntp.org \
            1.pool.ntp.org \
            2.pool.ntp.org \
            3.pool.ntp.org \
            0.openwrt.pool.ntp.org \
            1.openwrt.pool.ntp.org \
            2.openwrt.pool.ntp.org \
            3.openwrt.pool.ntp.org
        )
}

EOF

mkdir -p /etc/nftables.d/ip6
cat > /etc/nftables.d/ip6/ntp.nft << EOF

set ip6-ntp-servers {
        type ipv6_addr
        $(elements -t AAAA \
                2.pool.ntp.org \
                2.openwrt.pool.ntp.org)
}

EOF

nft -f /etc/nftables.nft

EOS