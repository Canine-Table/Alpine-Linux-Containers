#!/bin/sh

( # lab
    for i in key cert; do
        mkdir -p /etc/ssl/lab/lab.d/$i
    done

    openssl ecparam \
        -name prime256v1 \
        -genkey \
        -out /etc/ssl/lab/lab.d/key/lab.key

    openssl req -new -days 18250 -nodes -x509 \
        -key /etc/ssl/lab/lab.d/key/lab.key \
        -subj "/C=CA/ST=Ontario/L=Ottawa/O=Labs/CN=lab/emailAddress=root@lab" \
        -out /etc/ssl/lab/lab.d/cert/lab.cert

    openssl x509 -text -in /etc/ssl/lab/lab.d/cert/lab.cert -noout

    cp /etc/ssl/lab/lab.d/cert/lab.cert /etc/ca-certificates/trust-source/anchors/
    update-ca-trust
)

( # home.lab
        j=home.lab
    
        for i in key cert req pem chain; do
            mkdir -p /etc/ssl/lab/$j/$j.d/$i
        done

        openssl ecparam \
            -name prime256v1 \
            -genkey \
            -out /etc/ssl/lab/$j/$j.d/key/$j.key;

    openssl req -new -days 18250 -nodes -x509 \
        -key /etc/ssl/lab/$j/$j.d/key/$j.key \
        -subj "/C=CA/ST=Ontario/L=Ottawa/O=Home Labs/CN=$j/emailAddress=root@$j" \
        -out /etc/ssl/lab/$j/$j.d/cert/$j.cert;

    openssl x509 -text -in /etc/ssl/lab/$j/$j.d/cert/$j.cert -noout;

    openssl x509 -x509toreq -days 18250 \
        -in /etc/ssl/lab/$j/$j.d/cert/$j.cert \
        -out /etc/ssl/lab/$j/$j.d/req/$j.req \
        -signkey /etc/ssl/lab/$j/$j.d/key/$j.key

    openssl x509 -req -days 18250 \
        -in /etc/ssl/lab/$j/$j.d/req/$j.req \
        -CA /etc/ssl/lab/lab.d/cert/lab.cert \
        -CAkey /etc/ssl/lab/lab.d/key/lab.key \
        -out /etc/ssl/lab/$j/$j.d/pem/$j.pem

    openssl x509 -text -in /etc/ssl/lab/$j/$j.d/pem/$j.pem -noout;

    cat /etc/ssl/lab/$j/$j.d/pem/$j.pem \
        /etc/ssl/lab/lab.d/cert/lab.cert \
        > /etc/ssl/lab/$j/$j.d/chain/$j.chain

    openssl x509 -text -in /etc/ssl/lab/$j/$j.d/chain/$j.chain -noout;

    openssl verify -CAfile /etc/ssl/lab/lab.d/cert/lab.cert /etc/ssl/lab/$j/$j.d/pem/$j.pem

)

( # www.home.lab
        j=home.lab
    
        for i in key cert req pem chain; do
            mkdir -p /etc/ssl/lab/home.lab/$j.lab/$i
        done

        openssl ecparam \
            -name prime256v1 \
            -genkey \
            -out /etc/ssl/lab/$j/www.$j/key/www.$j.key;

    openssl req -new -days 18250 -nodes -x509 \
        -key /etc/ssl/lab/$j/www.$j/key/www.$j.key \
        -subj "/C=CA/ST=Ontario/L=Ottawa/O=Home Labs/CN=www.$j/emailAddress=root@$j" \
        -out /etc/ssl/lab/$j/www.$j/cert/www.$j.cert;

    openssl x509 -text -in /etc/ssl/lab/$j/www.$j/cert/www.$j.cert -noout;

    openssl x509 -x509toreq -days 18250 \
        -in /etc/ssl/lab/$j/www.$j/cert/www.$j.cert \
        -out /etc/ssl/lab/$j/www.$j/req/www.$j.req \
        -signkey /etc/ssl/lab/$j/www.$j/key/www.$j.key

    openssl x509 -req -days 18250 \
        -in /etc/ssl/lab/$j/www.$j/req/www.$j.req \
        -CA /etc/ssl/lab/$j/$j.d/pem/$j.pem \
        -CAkey /etc/ssl/lab/$j/$j.d/key/$j.key \
        -out /etc/ssl/lab/$j/www.$j/pem/www.$j.pem

    openssl x509 -text -in /etc/ssl/lab/$j/www.$j/pem/www.$j.pem -noout;

    cat /etc/ssl/lab/$j/www.$j/pem/www.$j.pem \
        /etc/ssl/lab/$j/$j.d/pem/$j.pem \
        /etc/ssl/lab/lab.d/cert/lab.cert \
        > /etc/ssl/lab/$j/www.$j/chain/www.$j.chain

    openssl x509 -text -in /etc/ssl/lab/$j/www.$j/chain/www.$j.chain -noout;

    openssl verify -CAfile /etc/ssl/lab/$j/$j.d/cert/$j.cert /etc/ssl/lab/$j/www.$j/chain/www.$j.chain
)
