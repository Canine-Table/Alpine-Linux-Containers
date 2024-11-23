#!/bin/sh

( # lab
    for i in key cert; do
        mkdir -p "$HOME"/.config/ssl/lab/lab.d/$i
    done

    openssl ecparam \
        -name prime256v1 \
        -genkey \
        -out "$HOME"/.config/ssl/lab/lab.d/key/lab.key

    openssl req -new -days 18250 -nodes -x509 \
        -key "$HOME"/.config/ssl/lab/lab.d/key/lab.key \
        -subj "/C=CA/ST=Ontario/L=Ottawa/O=Labs/CN=lab/emailAddress=root@lab" \
        -out "$HOME"/.config/ssl/lab/lab.d/cert/lab.cert

    openssl x509 -text -in "$HOME"/.config/ssl/lab/lab.d/cert/lab.cert -noout

    cp "$HOME"/.config/ssl/lab/lab.d/cert/lab.cert /etc/ca-certificates/trust-source/anchors/
    update-ca-trust
)

( # home.lab
        j=home.lab
    
        for i in key cert req pem chain; do
            mkdir -p "$HOME"/.config/ssl/lab/$j/$j.d/$i
        done

        openssl ecparam \
            -name prime256v1 \
            -genkey \
            -out "$HOME"/.config/ssl/lab/$j/$j.d/key/$j.key;

    openssl req -new -days 18250 -nodes -x509 \
        -key "$HOME"/.config/ssl/lab/$j/$j.d/key/$j.key \
        -subj "/C=CA/ST=Ontario/L=Ottawa/O=Home Labs/CN=$j/emailAddress=root@$j" \
        -out "$HOME"/.config/ssl/lab/$j/$j.d/cert/$j.cert;

    openssl x509 -text -in "$HOME"/.config/ssl/lab/$j/$j.d/cert/$j.cert -noout;

    openssl x509 -x509toreq -days 18250 \
        -in "$HOME"/.config/ssl/lab/$j/$j.d/cert/$j.cert \
        -out "$HOME"/.config/ssl/lab/$j/$j.d/req/$j.req \
        -signkey "$HOME"/.config/ssl/lab/$j/$j.d/key/$j.key

    openssl x509 -req -days 18250 \
        -in "$HOME"/.config/ssl/lab/$j/$j.d/req/$j.req \
        -CA "$HOME"/.config/ssl/lab/lab.d/cert/lab.cert \
        -CAkey "$HOME"/.config/ssl/lab/lab.d/key/lab.key \
        -out "$HOME"/.config/ssl/lab/$j/$j.d/pem/$j.pem

    openssl x509 -text -in "$HOME"/.config/ssl/lab/$j/$j.d/pem/$j.pem -noout;

    cat "$HOME"/.config/ssl/lab/$j/$j.d/pem/$j.pem \
        "$HOME"/.config/ssl/lab/lab.d/cert/lab.cert \
        > "$HOME"/.config/ssl/lab/$j/$j.d/chain/$j.chain

    openssl x509 -text -in "$HOME"/.config/ssl/lab/$j/$j.d/chain/$j.chain -noout;

    openssl verify -CAfile "$HOME"/.config/ssl/lab/lab.d/cert/lab.cert "$HOME"/.config/ssl/lab/$j/$j.d/pem/$j.pem

)

( # www.home.lab
        j=home.lab

        for i in key cert req pem chain; do
            mkdir -p "$HOME"/.config/ssl/lab/home.lab/$j.lab/$i
        done

        openssl ecparam \
            -name prime256v1 \
            -genkey \
            -out "$HOME"/.config/ssl/lab/$j/www.$j/key/www.$j.key;

        openssl req -new -days 18250 -nodes -x509 \
            -key "$HOME"/.config/ssl/lab/$j/www.$j/key/www.$j.key \
            -subj "/C=CA/ST=Ontario/L=Ottawa/O=Home Labs/CN=www.$j/emailAddress=root@$j" \
            -out "$HOME"/.config/ssl/lab/$j/www.$j/cert/www.$j.cert;

        openssl x509 -text -in "$HOME"/.config/ssl/lab/$j/www.$j/cert/www.$j.cert -noout;

        openssl x509 -x509toreq -days 18250 \
            -in "$HOME"/.config/ssl/lab/$j/www.$j/cert/www.$j.cert \
            -out "$HOME"/.config/ssl/lab/$j/www.$j/req/www.$j.req \
            -signkey "$HOME"/.config/ssl/lab/$j/www.$j/key/www.$j.key

        openssl x509 -req -days 18250 \
            -in "$HOME"/.config/ssl/lab/$j/www.$j/req/www.$j.req \
            -CA "$HOME"/.config/ssl/lab/$j/$j.d/pem/$j.pem \
            -CAkey "$HOME"/.config/ssl/lab/$j/$j.d/key/$j.key \
            -out "$HOME"/.config/ssl/lab/$j/www.$j/pem/www.$j.pem

        openssl x509 -text -in "$HOME"/.config/ssl/lab/$j/www.$j/pem/www.$j.pem -noout;

        cat "$HOME"/.config/ssl/lab/$j/www.$j/pem/www.$j.pem \
            "$HOME"/.config/ssl/lab/$j/$j.d/pem/$j.pem \
            "$HOME"/.config/ssl/lab/lab.d/cert/lab.cert \
            > "$HOME"/.config/ssl/lab/$j/www.$j/chain/www.$j.chain

        openssl x509 -text -in "$HOME"/.config/ssl/lab/$j/www.$j/chain/www.$j.chain -noout;

        openssl verify -CAfile "$HOME"/.config/ssl/lab/$j/$j.d/cert/$j.cert "$HOME"/.config/ssl/lab/$j/www.$j/chain/www.$j.chain
)

( # alpine.home.lab
        j=home.lab
    
        for i in key cert req pem chain; do
            mkdir -p "$HOME"/.config/ssl/lab/home.lab/alpine.$j/$i
        done

        openssl ecparam \
            -name prime256v1 \
            -genkey \
            -out "$HOME"/.config/ssl/lab/$j/alpine.$j/key/alpine.$j.key;

        openssl req -new -days 18250 -nodes -x509 \
            -key "$HOME"/.config/ssl/lab/$j/alpine.$j/key/alpine.$j.key \
            -subj "/C=CA/ST=Ontario/L=Ottawa/O=Home Labs/CN=alpine.$j/emailAddress=root@$j" \
            -out "$HOME"/.config/ssl/lab/$j/alpine.$j/cert/alpine.$j.cert;

        openssl x509 -text -in "$HOME"/.config/ssl/lab/$j/alpine.$j/cert/alpine.$j.cert -noout;

        openssl x509 -x509toreq -days 18250 \
            -in "$HOME"/.config/ssl/lab/$j/alpine.$j/cert/alpine.$j.cert \
            -out "$HOME"/.config/ssl/lab/$j/alpine.$j/req/alpine.$j.req \
            -signkey "$HOME"/.config/ssl/lab/$j/alpine.$j/key/alpine.$j.key

        openssl x509 -req -days 18250 \
            -in "$HOME"/.config/ssl/lab/$j/alpine.$j/req/alpine.$j.req \
            -CA "$HOME"/.config/ssl/lab/$j/$j.d/pem/$j.pem \
            -CAkey "$HOME"/.config/ssl/lab/$j/$j.d/key/$j.key \
            -out "$HOME"/.config/ssl/lab/$j/alpine.$j/pem/alpine.$j.pem

        openssl x509 -text -in "$HOME"/.config/ssl/lab/$j/alpine.$j/pem/alpine.$j.pem -noout;

        cat "$HOME"/.config/ssl/lab/$j/alpine.$j/pem/alpine.$j.pem \
            "$HOME"/.config/ssl/lab/$j/$j.d/pem/$j.pem \
            "$HOME"/.config/ssl/lab/lab.d/cert/lab.cert \
            > "$HOME"/.config/ssl/lab/$j/alpine.$j/chain/alpine.$j.chain

        openssl x509 -text -in "$HOME"/.config/ssl/lab/$j/alpine.$j/chain/alpine.$j.chain -noout;

        openssl verify -CAfile "$HOME"/.config/ssl/lab/$j/$j.d/cert/$j.cert "$HOME"/.config/ssl/lab/$j/alpine.$j/chain/alpine.$j.chain
)

( # server.home.lab
        j=home.lab
    
        for i in key cert req pem chain; do
            mkdir -p "$HOME"/.config/ssl/lab/home.lab/server.$j/$i
        done

        openssl ecparam \
            -name prime256v1 \
            -genkey \
            -out "$HOME"/.config/ssl/lab/$j/server.$j/key/server.$j.key;

        openssl req -new -days 18250 -nodes -x509 \
            -key "$HOME"/.config/ssl/lab/$j/server.$j/key/server.$j.key \
            -subj "/C=CA/ST=Ontario/L=Ottawa/O=Home Labs/CN=server.$j/emailAddress=root@$j" \
            -out "$HOME"/.config/ssl/lab/$j/server.$j/cert/server.$j.cert;

        openssl x509 -text -in "$HOME"/.config/ssl/lab/$j/server.$j/cert/server.$j.cert -noout;

        openssl x509 -x509toreq -days 18250 \
            -in "$HOME"/.config/ssl/lab/$j/server.$j/cert/server.$j.cert \
            -out "$HOME"/.config/ssl/lab/$j/server.$j/req/server.$j.req \
            -signkey "$HOME"/.config/ssl/lab/$j/server.$j/key/server.$j.key

        openssl x509 -req -days 18250 \
            -in "$HOME"/.config/ssl/lab/$j/server.$j/req/server.$j.req \
            -CA "$HOME"/.config/ssl/lab/$j/$j.d/pem/$j.pem \
            -CAkey "$HOME"/.config/ssl/lab/$j/$j.d/key/$j.key \
            -out "$HOME"/.config/ssl/lab/$j/server.$j/pem/server.$j.pem

        openssl x509 -text -in "$HOME"/.config/ssl/lab/$j/server.$j/pem/server.$j.pem -noout;

        cat "$HOME"/.config/ssl/lab/$j/server.$j/pem/server.$j.pem \
            "$HOME"/.config/ssl/lab/$j/$j.d/pem/$j.pem \
            "$HOME"/.config/ssl/lab/lab.d/cert/lab.cert \
            > "$HOME"/.config/ssl/lab/$j/server.$j/chain/server.$j.chain

        openssl x509 -text -in "$HOME"/.config/ssl/lab/$j/server.$j/chain/server.$j.chain -noout;

        openssl verify -CAfile "$HOME"/.config/ssl/lab/$j/$j.d/cert/$j.cert "$HOME"/.config/ssl/lab/$j/server.$j/chain/server.$j.chain
)

( # mariadb.home.lab
        j=home.lab
    
        for i in key cert req pem chain; do
            mkdir -p "$HOME"/.config/ssl/lab/home.lab/mariadb.$j/$i
        done

        openssl ecparam \
            -name prime256v1 \
            -genkey \
            -out "$HOME"/.config/ssl/lab/$j/mariadb.$j/key/mariadb.$j.key;

        openssl req -new -days 18250 -nodes -x509 \
            -key "$HOME"/.config/ssl/lab/$j/mariadb.$j/key/mariadb.$j.key \
            -subj "/C=CA/ST=Ontario/L=Ottawa/O=Home Labs/CN=mariadb.$j/emailAddress=root@$j" \
            -out "$HOME"/.config/ssl/lab/$j/mariadb.$j/cert/mariadb.$j.cert;

        openssl x509 -text -in "$HOME"/.config/ssl/lab/$j/mariadb.$j/cert/mariadb.$j.cert -noout;

        openssl x509 -x509toreq -days 18250 \
            -in "$HOME"/.config/ssl/lab/$j/mariadb.$j/cert/mariadb.$j.cert \
            -out "$HOME"/.config/ssl/lab/$j/mariadb.$j/req/mariadb.$j.req \
            -signkey "$HOME"/.config/ssl/lab/$j/mariadb.$j/key/mariadb.$j.key

        openssl x509 -req -days 18250 \
            -in "$HOME"/.config/ssl/lab/$j/mariadb.$j/req/mariadb.$j.req \
            -CA "$HOME"/.config/ssl/lab/$j/$j.d/pem/$j.pem \
            -CAkey "$HOME"/.config/ssl/lab/$j/$j.d/key/$j.key \
            -out "$HOME"/.config/ssl/lab/$j/mariadb.$j/pem/mariadb.$j.pem

        openssl x509 -text -in "$HOME"/.config/ssl/lab/$j/mariadb.$j/pem/mariadb.$j.pem -noout;

        cat "$HOME"/.config/ssl/lab/$j/mariadb.$j/pem/mariadb.$j.pem \
            "$HOME"/.config/ssl/lab/$j/$j.d/pem/$j.pem \
            "$HOME"/.config/ssl/lab/lab.d/cert/lab.cert \
            > "$HOME"/.config/ssl/lab/$j/mariadb.$j/chain/mariadb.$j.chain

        openssl x509 -text -in "$HOME"/.config/ssl/lab/$j/mariadb.$j/chain/mariadb.$j.chain -noout;

        openssl verify -CAfile "$HOME"/.config/ssl/lab/$j/$j.d/cert/$j.cert "$HOME"/.config/ssl/lab/$j/mariadb.$j/chain/mariadb.$j.chain
)

( # bind.home.lab
        j=home.lab
    
        for i in key cert req pem chain; do
            mkdir -p "$HOME"/.config/ssl/lab/home.lab/bind.$j/$i
        done

        openssl ecparam \
            -name prime256v1 \
            -genkey \
            -out "$HOME"/.config/ssl/lab/$j/bind.$j/key/bind.$j.key;

        openssl req -new -days 18250 -nodes -x509 \
            -key "$HOME"/.config/ssl/lab/$j/bind.$j/key/bind.$j.key \
            -subj "/C=CA/ST=Ontario/L=Ottawa/O=Home Labs/CN=bind.$j/emailAddress=root@$j" \
            -out "$HOME"/.config/ssl/lab/$j/bind.$j/cert/bind.$j.cert;

        openssl x509 -text -in "$HOME"/.config/ssl/lab/$j/bind.$j/cert/bind.$j.cert -noout;

        openssl x509 -x509toreq -days 18250 \
            -in "$HOME"/.config/ssl/lab/$j/bind.$j/cert/bind.$j.cert \
            -out "$HOME"/.config/ssl/lab/$j/bind.$j/req/bind.$j.req \
            -signkey "$HOME"/.config/ssl/lab/$j/bind.$j/key/bind.$j.key

        openssl x509 -req -days 18250 \
            -in "$HOME"/.config/ssl/lab/$j/bind.$j/req/bind.$j.req \
            -CA "$HOME"/.config/ssl/lab/$j/$j.d/pem/$j.pem \
            -CAkey "$HOME"/.config/ssl/lab/$j/$j.d/key/$j.key \
            -out "$HOME"/.config/ssl/lab/$j/bind.$j/pem/bind.$j.pem

        openssl x509 -text -in "$HOME"/.config/ssl/lab/$j/bind.$j/pem/bind.$j.pem -noout;

        cat "$HOME"/.config/ssl/lab/$j/bind.$j/pem/bind.$j.pem \
            "$HOME"/.config/ssl/lab/$j/$j.d/pem/$j.pem \
            "$HOME"/.config/ssl/lab/lab.d/cert/lab.cert \
            > "$HOME"/.config/ssl/lab/$j/bind.$j/chain/bind.$j.chain

        openssl x509 -text -in "$HOME"/.config/ssl/lab/$j/bind.$j/chain/bind.$j.chain -noout;

        openssl verify -CAfile "$HOME"/.config/ssl/lab/$j/$j.d/cert/$j.cert "$HOME"/.config/ssl/lab/$j/bind.$j/chain/bind.$j.chain
)

( # phpmyadmin.home.lab
        j=home.lab
    
        for i in key cert req pem chain; do
            mkdir -p "$HOME"/.config/ssl/lab/home.lab/phpmyadmin.$j/$i
        done

        openssl ecparam \
            -name prime256v1 \
            -genkey \
            -out "$HOME"/.config/ssl/lab/$j/phpmyadmin.$j/key/phpmyadmin.$j.key;

        openssl req -new -days 18250 -nodes -x509 \
            -key "$HOME"/.config/ssl/lab/$j/phpmyadmin.$j/key/phpmyadmin.$j.key \
            -subj "/C=CA/ST=Ontario/L=Ottawa/O=Home Labs/CN=phpmyadmin.$j/emailAddress=root@$j" \
            -out "$HOME"/.config/ssl/lab/$j/phpmyadmin.$j/cert/phpmyadmin.$j.cert;

        openssl x509 -text -in "$HOME"/.config/ssl/lab/$j/phpmyadmin.$j/cert/phpmyadmin.$j.cert -noout;

        openssl x509 -x509toreq -days 18250 \
            -in "$HOME"/.config/ssl/lab/$j/phpmyadmin.$j/cert/phpmyadmin.$j.cert \
            -out "$HOME"/.config/ssl/lab/$j/phpmyadmin.$j/req/phpmyadmin.$j.req \
            -signkey "$HOME"/.config/ssl/lab/$j/phpmyadmin.$j/key/phpmyadmin.$j.key

        openssl x509 -req -days 18250 \
            -in "$HOME"/.config/ssl/lab/$j/phpmyadmin.$j/req/phpmyadmin.$j.req \
            -CA "$HOME"/.config/ssl/lab/$j/$j.d/pem/$j.pem \
            -CAkey "$HOME"/.config/ssl/lab/$j/$j.d/key/$j.key \
            -out "$HOME"/.config/ssl/lab/$j/phpmyadmin.$j/pem/phpmyadmin.$j.pem

        openssl x509 -text -in "$HOME"/.config/ssl/lab/$j/phpmyadmin.$j/pem/phpmyadmin.$j.pem -noout;

        cat "$HOME"/.config/ssl/lab/$j/phpmyadmin.$j/pem/phpmyadmin.$j.pem \
            "$HOME"/.config/ssl/lab/$j/$j.d/pem/$j.pem \
            "$HOME"/.config/ssl/lab/lab.d/cert/lab.cert \
            > "$HOME"/.config/ssl/lab/$j/phpmyadmin.$j/chain/phpmyadmin.$j.chain

        openssl x509 -text -in "$HOME"/.config/ssl/lab/$j/phpmyadmin.$j/chain/phpmyadmin.$j.chain -noout;

        openssl verify -CAfile "$HOME"/.config/ssl/lab/$j/$j.d/cert/$j.cert "$HOME"/.config/ssl/lab/$j/phpmyadmin.$j/chain/phpmyadmin.$j.chain
)

( # apache2.home.lab
            j=home.lab
    
        for i in key cert req pem chain; do
            mkdir -p "$HOME"/.config/ssl/lab/home.lab/apache2.$j/$i
        done

        openssl ecparam \
            -name prime256v1 \
            -genkey \
            -out "$HOME"/.config/ssl/lab/$j/apache2.$j/key/apache2.$j.key;

        openssl req -new -days 18250 -nodes -x509 \
            -key "$HOME"/.config/ssl/lab/$j/apache2.$j/key/apache2.$j.key \
            -subj "/C=CA/ST=Ontario/L=Ottawa/O=Home Labs/CN=apache2.$j/emailAddress=root@$j" \
            -out "$HOME"/.config/ssl/lab/$j/apache2.$j/cert/apache2.$j.cert;

        openssl x509 -text -in "$HOME"/.config/ssl/lab/$j/apache2.$j/cert/apache2.$j.cert -noout;

        openssl x509 -x509toreq -days 18250 \
            -in "$HOME"/.config/ssl/lab/$j/apache2.$j/cert/apache2.$j.cert \
            -out "$HOME"/.config/ssl/lab/$j/apache2.$j/req/apache2.$j.req \
            -signkey "$HOME"/.config/ssl/lab/$j/apache2.$j/key/apache2.$j.key

        openssl x509 -req -days 18250 \
            -in "$HOME"/.config/ssl/lab/$j/apache2.$j/req/apache2.$j.req \
            -CA "$HOME"/.config/ssl/lab/$j/$j.d/pem/$j.pem \
            -CAkey "$HOME"/.config/ssl/lab/$j/$j.d/key/$j.key \
            -out "$HOME"/.config/ssl/lab/$j/apache2.$j/pem/apache2.$j.pem

        openssl x509 -text -in "$HOME"/.config/ssl/lab/$j/apache2.$j/pem/apache2.$j.pem -noout;

        cat "$HOME"/.config/ssl/lab/$j/apache2.$j/pem/apache2.$j.pem \
            "$HOME"/.config/ssl/lab/$j/$j.d/pem/$j.pem \
            "$HOME"/.config/ssl/lab/lab.d/cert/lab.cert \
            > "$HOME"/.config/ssl/lab/$j/apache2.$j/chain/apache2.$j.chain

        openssl x509 -text -in "$HOME"/.config/ssl/lab/$j/apache2.$j/chain/apache2.$j.chain -noout;

        openssl verify -CAfile "$HOME"/.config/ssl/lab/$j/$j.d/cert/$j.cert "$HOME"/.config/ssl/lab/$j/apache2.$j/chain/apache2.$j.chain
)

( # jellyfin.home.lab
        j=home.lab
    
        for i in key cert req pem chain; do
            mkdir -p "$HOME"/.config/ssl/lab/home.lab/jellyfin.$j/$i
        done

        openssl ecparam \
            -name prime256v1 \
            -genkey \
            -out "$HOME"/.config/ssl/lab/$j/jellyfin.$j/key/jellyfin.$j.key;

        openssl req -new -days 18250 -nodes -x509 \
            -key "$HOME"/.config/ssl/lab/$j/jellyfin.$j/key/jellyfin.$j.key \
            -subj "/C=CA/ST=Ontario/L=Ottawa/O=Home Labs/CN=jellyfin.$j/emailAddress=root@$j" \
            -out "$HOME"/.config/ssl/lab/$j/jellyfin.$j/cert/jellyfin.$j.cert;

        openssl x509 -text -in "$HOME"/.config/ssl/lab/$j/jellyfin.$j/cert/jellyfin.$j.cert -noout;

        openssl x509 -x509toreq -days 18250 \
            -in "$HOME"/.config/ssl/lab/$j/jellyfin.$j/cert/jellyfin.$j.cert \
            -out "$HOME"/.config/ssl/lab/$j/jellyfin.$j/req/jellyfin.$j.req \
            -signkey "$HOME"/.config/ssl/lab/$j/jellyfin.$j/key/jellyfin.$j.key

        openssl x509 -req -days 18250 \
            -in "$HOME"/.config/ssl/lab/$j/jellyfin.$j/req/jellyfin.$j.req \
            -CA "$HOME"/.config/ssl/lab/$j/$j.d/pem/$j.pem \
            -CAkey "$HOME"/.config/ssl/lab/$j/$j.d/key/$j.key \
            -out "$HOME"/.config/ssl/lab/$j/jellyfin.$j/pem/jellyfin.$j.pem

        openssl x509 -text -in "$HOME"/.config/ssl/lab/$j/jellyfin.$j/pem/jellyfin.$j.pem -noout;

        cat "$HOME"/.config/ssl/lab/$j/jellyfin.$j/pem/jellyfin.$j.pem \
            "$HOME"/.config/ssl/lab/$j/$j.d/pem/$j.pem \
            "$HOME"/.config/ssl/lab/lab.d/cert/lab.cert \
            > "$HOME"/.config/ssl/lab/$j/jellyfin.$j/chain/jellyfin.$j.chain

        openssl x509 -text -in "$HOME"/.config/ssl/lab/$j/jellyfin.$j/chain/jellyfin.$j.chain -noout;

        openssl verify -CAfile "$HOME"/.config/ssl/lab/$j/$j.d/cert/$j.cert "$HOME"/.config/ssl/lab/$j/jellyfin.$j/chain/jellyfin.$j.chain
)

( # nextcloud.home.lab
        j=home.lab
    
        for i in key cert req pem chain; do
            mkdir -p "$HOME"/.config/ssl/lab/home.lab/nextcloud.$j/$i
        done

        openssl ecparam \
            -name prime256v1 \
            -genkey \
            -out "$HOME"/.config/ssl/lab/$j/nextcloud.$j/key/nextcloud.$j.key;

        openssl req -new -days 18250 -nodes -x509 \
            -key "$HOME"/.config/ssl/lab/$j/nextcloud.$j/key/nextcloud.$j.key \
            -subj "/C=CA/ST=Ontario/L=Ottawa/O=Home Labs/CN=nextcloud.$j/emailAddress=root@$j" \
            -out "$HOME"/.config/ssl/lab/$j/nextcloud.$j/cert/nextcloud.$j.cert;

        openssl x509 -text -in "$HOME"/.config/ssl/lab/$j/nextcloud.$j/cert/nextcloud.$j.cert -noout;

        openssl x509 -x509toreq -days 18250 \
            -in "$HOME"/.config/ssl/lab/$j/nextcloud.$j/cert/nextcloud.$j.cert \
            -out "$HOME"/.config/ssl/lab/$j/nextcloud.$j/req/nextcloud.$j.req \
            -signkey "$HOME"/.config/ssl/lab/$j/nextcloud.$j/key/nextcloud.$j.key

        openssl x509 -req -days 18250 \
            -in "$HOME"/.config/ssl/lab/$j/nextcloud.$j/req/nextcloud.$j.req \
            -CA "$HOME"/.config/ssl/lab/$j/$j.d/pem/$j.pem \
            -CAkey "$HOME"/.config/ssl/lab/$j/$j.d/key/$j.key \
            -out "$HOME"/.config/ssl/lab/$j/nextcloud.$j/pem/nextcloud.$j.pem

        openssl x509 -text -in "$HOME"/.config/ssl/lab/$j/nextcloud.$j/pem/nextcloud.$j.pem -noout;

        cat "$HOME"/.config/ssl/lab/$j/nextcloud.$j/pem/nextcloud.$j.pem \
            "$HOME"/.config/ssl/lab/$j/$j.d/pem/$j.pem \
            "$HOME"/.config/ssl/lab/lab.d/cert/lab.cert \
            > "$HOME"/.config/ssl/lab/$j/nextcloud.$j/chain/nextcloud.$j.chain

        openssl x509 -text -in "$HOME"/.config/ssl/lab/$j/nextcloud.$j/chain/nextcloud.$j.chain -noout;

        openssl verify -CAfile "$HOME"/.config/ssl/lab/$j/$j.d/cert/$j.cert "$HOME"/.config/ssl/lab/$j/nextcloud.$j/chain/nextcloud.$j.chain
)

( # archlinux.home.lab
        j=home.lab
    
        for i in key cert req pem chain; do
            mkdir -p "$HOME"/.config/ssl/lab/home.lab/archlinux.$j/$i
        done

        openssl ecparam \
            -name prime256v1 \
            -genkey \
            -out "$HOME"/.config/ssl/lab/$j/archlinux.$j/key/archlinux.$j.key;

        openssl req -new -days 18250 -nodes -x509 \
            -key "$HOME"/.config/ssl/lab/$j/archlinux.$j/key/archlinux.$j.key \
            -subj "/C=CA/ST=Ontario/L=Ottawa/O=Home Labs/CN=archlinux.$j/emailAddress=root@$j" \
            -out "$HOME"/.config/ssl/lab/$j/archlinux.$j/cert/archlinux.$j.cert;

        openssl x509 -text -in "$HOME"/.config/ssl/lab/$j/archlinux.$j/cert/archlinux.$j.cert -noout;

        openssl x509 -x509toreq -days 18250 \
            -in "$HOME"/.config/ssl/lab/$j/archlinux.$j/cert/archlinux.$j.cert \
            -out "$HOME"/.config/ssl/lab/$j/archlinux.$j/req/archlinux.$j.req \
            -signkey "$HOME"/.config/ssl/lab/$j/archlinux.$j/key/archlinux.$j.key

        openssl x509 -req -days 18250 \
            -in "$HOME"/.config/ssl/lab/$j/archlinux.$j/req/archlinux.$j.req \
            -CA "$HOME"/.config/ssl/lab/$j/$j.d/pem/$j.pem \
            -CAkey "$HOME"/.config/ssl/lab/$j/$j.d/key/$j.key \
            -out "$HOME"/.config/ssl/lab/$j/archlinux.$j/pem/archlinux.$j.pem

        openssl x509 -text -in "$HOME"/.config/ssl/lab/$j/archlinux.$j/pem/archlinux.$j.pem -noout;

        cat "$HOME"/.config/ssl/lab/$j/archlinux.$j/pem/archlinux.$j.pem \
            "$HOME"/.config/ssl/lab/$j/$j.d/pem/$j.pem \
            "$HOME"/.config/ssl/lab/lab.d/cert/lab.cert \
            > "$HOME"/.config/ssl/lab/$j/archlinux.$j/chain/archlinux.$j.chain

        openssl x509 -text -in "$HOME"/.config/ssl/lab/$j/archlinux.$j/chain/archlinux.$j.chain -noout;

        openssl verify -CAfile "$HOME"/.config/ssl/lab/$j/$j.d/cert/$j.cert "$HOME"/.config/ssl/lab/$j/archlinux.$j/chain/archlinux.$j.chain
)

( # phpldapadmin.home.lab
        j=home.lab
    
        for i in key cert req pem chain; do
            mkdir -p "$HOME"/.config/ssl/lab/home.lab/phpldapadmin.$j/$i
        done

        openssl ecparam \
            -name prime256v1 \
            -genkey \
            -out "$HOME"/.config/ssl/lab/$j/phpldapadmin.$j/key/phpldapadmin.$j.key;

        openssl req -new -days 18250 -nodes -x509 \
            -key "$HOME"/.config/ssl/lab/$j/phpldapadmin.$j/key/phpldapadmin.$j.key \
            -subj "/C=CA/ST=Ontario/L=Ottawa/O=Home Labs/CN=phpldapadmin.$j/emailAddress=root@$j" \
            -out "$HOME"/.config/ssl/lab/$j/phpldapadmin.$j/cert/phpldapadmin.$j.cert;

        openssl x509 -text -in "$HOME"/.config/ssl/lab/$j/phpldapadmin.$j/cert/phpldapadmin.$j.cert -noout;

        openssl x509 -x509toreq -days 18250 \
            -in "$HOME"/.config/ssl/lab/$j/phpldapadmin.$j/cert/phpldapadmin.$j.cert \
            -out "$HOME"/.config/ssl/lab/$j/phpldapadmin.$j/req/phpldapadmin.$j.req \
            -signkey "$HOME"/.config/ssl/lab/$j/phpldapadmin.$j/key/phpldapadmin.$j.key

        openssl x509 -req -days 18250 \
            -in "$HOME"/.config/ssl/lab/$j/phpldapadmin.$j/req/phpldapadmin.$j.req \
            -CA "$HOME"/.config/ssl/lab/$j/$j.d/pem/$j.pem \
            -CAkey "$HOME"/.config/ssl/lab/$j/$j.d/key/$j.key \
            -out "$HOME"/.config/ssl/lab/$j/phpldapadmin.$j/pem/phpldapadmin.$j.pem

        openssl x509 -text -in "$HOME"/.config/ssl/lab/$j/phpldapadmin.$j/pem/phpldapadmin.$j.pem -noout;

        cat "$HOME"/.config/ssl/lab/$j/phpldapadmin.$j/pem/phpldapadmin.$j.pem \
            "$HOME"/.config/ssl/lab/$j/$j.d/pem/$j.pem \
            "$HOME"/.config/ssl/lab/lab.d/cert/lab.cert \
            > "$HOME"/.config/ssl/lab/$j/phpldapadmin.$j/chain/phpldapadmin.$j.chain

        openssl x509 -text -in "$HOME"/.config/ssl/lab/$j/phpldapadmin.$j/chain/phpldapadmin.$j.chain -noout;

        openssl verify -CAfile "$HOME"/.config/ssl/lab/$j/$j.d/cert/$j.cert "$HOME"/.config/ssl/lab/$j/phpldapadmin.$j/chain/phpldapadmin.$j.chain
)

( # kea.home.lab
        j=home.lab
    
        for i in key cert req pem chain; do
            mkdir -p "$HOME"/.config/ssl/lab/home.lab/kea.$j/$i
        done

        openssl ecparam \
            -name prime256v1 \
            -genkey \
            -out "$HOME"/.config/ssl/lab/$j/kea.$j/key/kea.$j.key;

        openssl req -new -days 18250 -nodes -x509 \
            -key "$HOME"/.config/ssl/lab/$j/kea.$j/key/kea.$j.key \
            -subj "/C=CA/ST=Ontario/L=Ottawa/O=Home Labs/CN=kea.$j/emailAddress=root@$j" \
            -out "$HOME"/.config/ssl/lab/$j/kea.$j/cert/kea.$j.cert;

        openssl x509 -text -in "$HOME"/.config/ssl/lab/$j/kea.$j/cert/kea.$j.cert -noout;

        openssl x509 -x509toreq -days 18250 \
            -in "$HOME"/.config/ssl/lab/$j/kea.$j/cert/kea.$j.cert \
            -out "$HOME"/.config/ssl/lab/$j/kea.$j/req/kea.$j.req \
            -signkey "$HOME"/.config/ssl/lab/$j/kea.$j/key/kea.$j.key

        openssl x509 -req -days 18250 \
            -in "$HOME"/.config/ssl/lab/$j/kea.$j/req/kea.$j.req \
            -CA "$HOME"/.config/ssl/lab/$j/$j.d/pem/$j.pem \
            -CAkey "$HOME"/.config/ssl/lab/$j/$j.d/key/$j.key \
            -out "$HOME"/.config/ssl/lab/$j/kea.$j/pem/kea.$j.pem

        openssl x509 -text -in "$HOME"/.config/ssl/lab/$j/kea.$j/pem/kea.$j.pem -noout;

        cat "$HOME"/.config/ssl/lab/$j/kea.$j/pem/kea.$j.pem \
            "$HOME"/.config/ssl/lab/$j/$j.d/pem/$j.pem \
            "$HOME"/.config/ssl/lab/lab.d/cert/lab.cert \
            > "$HOME"/.config/ssl/lab/$j/kea.$j/chain/kea.$j.chain

        openssl x509 -text -in "$HOME"/.config/ssl/lab/$j/kea.$j/chain/kea.$j.chain -noout;

        openssl verify -CAfile "$HOME"/.config/ssl/lab/$j/$j.d/cert/$j.cert "$HOME"/.config/ssl/lab/$j/kea.$j/chain/kea.$j.chain
)
