#docker network create --subnet 172.16.0.0/16 --gateway 172.16.0.1 lab

(
        CONTAINER_ID="$(
            UNIQUE="$(cat /dev/urandom | tr -dc [:alnum:] | head -c 16)"
            docker container run --detach \
                --network=lab \
                --name example_${UNIQUE} \
                --label ${UNIQUE} \
                --hostname ${UNIQUE}.home.lab \
                --dns 192.168.1.113 \
                --dns dead:deaf:beef::1803:7334:16d7 \
                --publish-all \
                alpine:latest ash -c "while :; do sleep 1; done"
        )" && {
            docker container exec --interactive --tty ${CONTAINER_ID} ash
        }
)

# ip link add link intel name intel.10 type vlan id 10
# ip addr add 172.16.0.1/16 dev intel.10
# ip link set dev intel.10 up
