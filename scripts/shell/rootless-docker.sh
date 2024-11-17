#!/bin/sh

[ "$((getent passwd) | awk -F ':' '{
        if ($1 == "sandbox") {
                print "sandbox"
                exit 0
        }
}')" = 'sandbox' ] || {
        useradd -Nrm \
            -c rootless \
            -s /bin/sh \
            -g nobody \
            sandbox
}

yes | pacman -Syu nftables curl shadow git base-devel fuse-overlayfs docker docker-compose

cat > /etc/sysctl.d/99-docker-rootless.conf << 'EOF'
net.ipv4.ip_unprivileged_port_start=80
net.ipv4.ip_forward=1
net.ipv6.conf.all.forwarding=1
net/ipv6/conf/default/forwarding=1
net.ipv4.ping_group_range = 0 2147483647
user.max_user_namespaces = 63463
EOF

(
        command -v sudo 1>/dev/null 2>&1 || exit 1
        USER="$(getent group | grep wheel | awk -F ':' '{print $NF}' | awk '{print $1}')"
        [ -n "$USER" ] || exit 2
        su -l $USER -c '
                git clone https://aur.archlinux.org/yay.git && cd yay && yes | makepkg -si
                yes | yay -S docker-rootless-extras        
        '
)

(
        i="sandbox:100000:65536"

        for j in gid uid; do
                grep -q '^$i$' '/etc/sub$j' || echo '$i' >> '/etc/sub$j'
        done
)

mkdir /etc/docker && cat > /etc/docker/daemon.json << 'EOF'
{
        "userns-remap": "sandbox",
        "experimental": false,
        "live-restore": true,
        "ipv6": true,
        "icc": false,
        "no-new-privileges": false
}
EOF

su -l sandbox -c "
cd /tmp
curl -fsSL https://get.docker.com/rootless | sh
cat > /home/sandbox/.profile << 'EOF'
export DOCKER_HOST=unix:///home/sandbox/.docker/run/docker.sock
export XDG_RUNTIME_DIR=/home/sandbox/.docker/run
append_path() {
        case \":\${PATH}:\" in
                *:\"\${1}\":*) return 1;;
                *) export PATH=\"\${PATH:+\${PATH}:}\${1}\";;
        esac

        return 0
}
append_path /home/sandbox/bin
EOF
systemctl --user enable --now docker.socket
"

exit 0;

# Example Deployment
docker network create --subnet 172.30.58.0/25 --gateway 172.30.58.1 pacific58

( # Deploy with sandbox user
        CONTAINER_ID="$(
            UNIQUE="$(cat /dev/urandom | tr -dc [:alnum:] | head -c 16)"
            docker container run --detach \
                --network=pacific58 \
                --name pacific_${UNIQUE} \
                --label ${UNIQUE} \
                --hostname ${UNIQUE}.pacific.lab \
                --dns 172.30.58.4 \
                --publish-all \
                alpine:latest ash -c "while :; do sleep 1; done"
        )" && {
            docker container exec --interactive --tty ${CONTAINER_ID} ash
        }
)
