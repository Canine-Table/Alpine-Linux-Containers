# Create and run the deployment script
cat > run.sh << 'EOS'

docker build -t alpine:mariadb .

( # Remove old deployments
    docker container ls -a | awk '{if($NF ~ /^mariadb_[[:alnum:]]{16}$/){print $1}}' |
    while read -r i; do
            docker rm -f "$i"
    done
)

(
        CONTAINER_ID="$(
                UNIQUE="$(cat /dev/urandom | tr -dc [:alnum:] | head -c 16)"
                docker container run --detach \
                    --network=lab \
                    --name mariadb_${UNIQUE} \
                    --label "mariadb=${UNIQUE}" \
                    --hostname mariadb.home.lab \
                    --restart unless-stopped \
                    --publish 127.0.0.1:3306:3306/tcp \
                    --publish ::1:3306:3306/tcp \
                    alpine:mariadb
        )" || echo "Failed to create container" && {
                docker container exec --interactive --tty "$CONTAINER_ID" ash
        }
)
EOS

chmod +x run.sh
./run.sh
