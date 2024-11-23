docker network rm lab

docker network create \
    --driver=bridge \
    --subnet=172.16.0.0/16 \
    --gateway=172.16.0.1 \
    --subnet=dead:deaf:beef:acad::/64 \
    --gateway=dead:deaf:beef:acad::1 \
    --ipv6 \
    --label="lab=$(cat /dev/urandom | tr -dc [:alnum:] | head -c 16)" \
    lab

docker network inspect lab
