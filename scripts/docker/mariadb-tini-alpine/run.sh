docker build -t alpine:mariadb .

( # Remove old deployments
    docker container ls -a | awk '{if($NF ~ /^mariadb_[[:alnum:]]{16}$/){print $1}}' |
    while read -r i; do
            docker rm -f "$i"
    done
)

# Create and run the deployment script
cat > run.sh << 'EOF'
(
        CONTAINER_ID="$(
                UNIQUE="$(cat /dev/urandom | tr -dc [:alnum:] | head -c 16)"
                docker container run --detach \
                    --network=lab \
                    --name mariadb_${UNIQUE} \
                    --label "mariadb=${UNIQUE}" \
                    --hostname mariadb.home.lab \
                    --restart unless-stopped \
                    --publish 3306:3306 \
                    alpine:mariadb
        )" || echo "Failed to create container" && {
                docker container exec --interactive --tty "$CONTAINER_ID" ash -c '
                        {
                            rm -f /tmp/deploy.sql
                            apk del --purge mariadb-client
                        } || echo "An error occurred D:"
                ' 
        }
)
EOF

mariadb -u root -e /tmp/deploy.sql

chmod +x run.sh
./run.sh
