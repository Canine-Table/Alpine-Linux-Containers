docker build -t alpine:bind .

(
    docker container ls -a | awk '{if($NF ~ /^bind_[[:alnum:]]{16}$/){print $1}}' |
    while read -r i; do
            docker rm -f "$i"
    done
)

cat > run.sh << 'EOF'
(
        CONTAINER_ID="$(
            UNIQUE="$(cat /dev/urandom | tr -dc [:alnum:] | head -c 16)"
            docker container run --detach \
                --network=lab \
                --name bind_${UNIQUE} \
                --label ${UNIQUE} \
                --hostname bind.home.lab \
                --restart unless-stopped \
                --publish 53:53 \
                alpine:bind
        )" && {
            docker container exec --interactive --tty ${CONTAINER_ID} ash
        }
)
EOF
./run.sh
