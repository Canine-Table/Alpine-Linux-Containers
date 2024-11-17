cat > script.sh << 'EOS'
# Update the package list
apk --no-cache -U upgrade

apk add --no-cache \
    tini \
    mariadb \
    mariadb-common \
    mariadb-client \
    mariadb-server-utils

mariadb-install-db \
    --user=mysql \
    --group=mysql \
    --auth-root-authentication-method=normal \
    --skip-test-db \
    --basedir=/usr \
    --datadir=/var/lib/mysql

cat > /etc/my.cnf << 'EOF'
[mysqld]
symbolic-links=0
socket=/run/mysqld/mysqld.sock
port=3306
bind-address=0.0.0.0
!includedir /etc/my.cnf.d
EOF









cat > /etc/my.cnf.d/mariadb-server.cnf << 'EOF'
[mariadb]
datadir=/var/lib/mysql
log-basename=mysqld
general-log
log-slow-queries
EOF









cat > /etc/my.cnf.d/mariadb-client.cnf << 'EOF'
[client-mariadb]

EOF








cat > /tmp/deploy.sql << 'EOF' 
CREATE USER 'root'@'%';
GRANT ALL ON *.* TO 'root'@'%';
FLUSH PRIVILEGES;
QUIT;
EOF
EOS


