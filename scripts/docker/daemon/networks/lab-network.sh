docker network remove lab

docker network create \
    --driver=bridge \
    --subnet=172.16.0.0/16 \
    --gateway=172.16.0.1 \
    --label="lab=$(cat /dev/urandom | tr -dc [:alnum:] | head -c 16)" \
    lab

docker network inspect lab

    # --subnet=dead:deaf:beef:acad::/64 \
    # --gateway=dead:deaf:beef:acad::1 \
