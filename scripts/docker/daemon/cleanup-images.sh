(
    docker image ls -a | awk '{print $3}' |
    while read -r i; do
        docker rmi -f "$i" &
    done
)