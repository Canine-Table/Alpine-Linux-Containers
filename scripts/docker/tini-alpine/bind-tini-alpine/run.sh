# Create and run the deployment script
cat > run.sh << 'EOS'

docker build -t alpine:bind .

(
    docker container ls -a | awk '{if($NF ~ /^bind_[[:alnum:]]{16}$/){print $1}}' |
    while read -r i; do
            docker rm -f "$i"
    done
)

(
        CONTAINER_ID="$(
            UNIQUE="$(cat /dev/urandom | tr -dc [:alnum:] | head -c 16)"
            docker container run --detach \
                --network=lab \
                --name bind_${UNIQUE} \
                --label ${UNIQUE} \
                --hostname bind.home.lab \
                --restart unless-stopped \
                --publish 127.0.0.1:8053:53/udp \
                --publish 127.0.0.1:8053:53/tcp \
                --publish 127.0.0.1:8953:953/tcp \
                --publish ::1:8053:53/udp \
                --publish ::1:8053:53/tcp \
                --publish ::1:8953:953/tcp \
                alpine:bind
        )" && {
            docker container exec --interactive --tty ${CONTAINER_ID} ash
        }
)
EOS

chmod +x run.sh
./run.sh
