cat > script.sh << 'EOS'
# Update the package list
apk --no-cache -U upgrade

apk add --no-cache \
    tini \
    mariadb \
    mariadb-common \
    openssl \
    ca-certificates \
    mariadb-server-utils

cat > /tmp/deploy.sql << 'EOF'
CREATE USER 'root'@'%';
GRANT ALL ON *.* TO 'root'@'%';
FLUSH PRIVILEGES;
QUIT;
EOF

mariadb-install-db \
    --user=mysql \
    --group=mysql \
    --auth-root-authentication-method=normal \
    --skip-test-db \
    --basedir=/usr \
    --datadir=/var/lib/mysql

cat > /etc/my.cnf << 'EOF'
[mysqld]
init_file=/tmp/deploy.sql

[mariadbd-safe]
plugin-load-add=auth_socket.so=OFF
symbolic-links=0
port=3306
bind-address=0.0.0.0
!includedir /etc/my.cnf.d/
EOF

cd /etc/ssl
tar xfj /etc/ssl/ssl.tbz
rm -f /etc/ssl/ssl.tbz
chown root:root /etc/ssl/lab.cert /etc/ssl/home.lab.cert
mv /etc/ssl/lab.cert /usr/local/share/ca-certificates/
update-ca-certificates

chown -R root:root /etc/ssl/mariadb.home.lab
chown mysql:mysql /etc/ssl/mariadb.home.lab/key/mariadb.home.lab.key
openssl verify -CAfile /etc/ssl/home.lab.cert /etc/ssl/mariadb.home.lab/chain/mariadb.home.lab.chain

cat > /etc/my.cnf.d/mariadb-server.cnf << 'EOF'
[mariadb]
unix_socket=OFF
ssl_cert=/etc/ssl/mariadb.home.lab/chain/mariadb.home.lab.chain
ssl_key=/etc/ssl/mariadb.home.lab/key/mariadb.home.lab.key
ssl_ca=/etc/ssl/home.lab.cert
tls_version=TLSv1.2,TLSv1.3
ssl-cipher=ECDHE-ECDSA-AES128-SHA256
ssl
EOF







cat > /etc/my.cnf.d/mariadb-client.cnf << 'EOF'
[client-mariadb]
ssl-verify-server-cert
EOF

EOS
