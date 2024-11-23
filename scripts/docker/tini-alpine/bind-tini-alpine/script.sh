cat > script.sh << 'EOS'
apk --no-cache -U upgrade

apk add --no-cache \
    tini \
    bind \
    bind-libs \
    bind-tools

mkdir -p /etc/bind/named.d
cat > /etc/bind/named.conf << 'EOF'
include "/etc/bind/named.d/options.conf";
include "/etc/bind/named.d/logging.conf";

// root name servers in "hints" file
zone "." IN {
    type hint;
    file "named.ca";
};

// primary forward lookup zone home.lab.
zone "home.lab" IN {
    type primary;
    file "pri/fwd.home.lab";

    allow-update {
        none;
    };
};

// primary reverse lookup zone for 192.168.1.0/24 within home.lab.
zone "1.168.192.in-addr.arpa" IN {
    type primary;
    file "pri/rvs.home.lab.1.168.192.in-addr.arpa";

    allow-update {
        none;
    };
};

// primary reverse lookup zone for 172.16.0.0/16 within home.lab.
zone "0.16.172.in-addr.arpa" IN {
    type primary;
    file "pri/rvs.home.lab.0.16.172.in-addr.arpa";

    allow-update {
        none;
    };
};

// primary reverse lookup zone for dead:deaf:beef::/64 within home.lab.
zone "e.f.e.b.f.a.e.d.d.a.e.d.ip6.arpa" IN {
    type primary;
    file "pri/rvs.home.lab.f.e.e.b.f.a.e.d.d.a.e.d.ip6.arpa";

    allow-update {
        none;
    };
};

// primary reverse lookup zone for dead:deaf:beef:acad/64 within home.lab.
zone "d.a.c.a.f.e.e.b.f.a.e.d.d.a.e.d.ip6.arpa" IN {
    type primary;
    file "pri/rvs.home.lab.d.a.c.a.f.e.e.b.f.a.e.d.d.a.e.d.ip6.arpa";

    allow-update {
        none;
    };
};

include "/etc/bind/bind.keys";
include "/etc/bind/rndc.key";
EOF

cat > /var/bind/pri/fwd.home.lab << 'EOF'
; Time To Live: 1D
$TTL 1D

; Origin: home.lab.
; Primary Name Server: ns1.home.lab.
; Email Address: admin.home.lab.

; Serial Number: 0
; Refresh Interval: 1D
; Retry Interval: 1H
; Expire Interval: 1W
; Minimum Time To Live: 3H

; SOA Record
@   IN  SOA ns1.home.lab. admin.home.lab. (
    0    ; Serial Number
    1D   ; Refresh Interval
    1H   ; Retry Interval
    1W   ; Expire Interval
    3H )  ; Minimum Time To Live

; NS Records
@   IN  NS  ns1.home.lab.

; A Records
ns1             IN  A   172.16.0.3
mariadb         IN  A   172.16.0.2
docker          IN  A   172.16.0.1
alpine          IN  A   192.168.1.113
server          IN  A   192.168.1.112
router          IN  A   192.168.1.1

; AAAA Records
alpine          IN  AAAA    dead:deaf:beef::1803:7334:16d7
server          IN  AAAA    dead:deaf:beef::f079:5991:f4ba

; CNAME Records
bind            IN  CNAME   ns1
EOF








cat > /etc/bind/named.d/options.conf << 'EOF'
options {
    directory "/var/bind";

    listen-on port 53 {
        172.16.0.3;
    };

    listen-on-v6 port 53 {
        dead:deaf:beef:acad::3;
    };

    forwarders {
        192.168.1.1;
        127.0.0.11;
    };

    allow-update {
       any;
    };

    allow-query {
        any;
    };

    allow-recursion {
        any;
    };

    recursion yes;
    pid-file "/var/run/named/named.pid";
    session-keyfile "/run/named/session.key";
    dump-file "data/cache_dump.db";
    statistics-file "data/named_stats.txt";
    memstatistics-file "data/named_mem_stats.txt";
    secroots-file "data/secroots.txt";
    recursing-file "data/recursing.txt";
    managed-keys-directory "dyn";
    dnssec-validation yes;
    auth-nxdomain no;
};

controls { 
    inet 172.16.0.3 port 953 allow { 172.16.0.0/16; 127.0.0.1; }; 
    inet dead:deaf:beef:acad::3 port 953 allow { dead:deaf:beef:acad::/64; ::1/128; }; 
};
EOF




cat > /etc/bind/named.d/logging.conf << 'EOF'
logging {
     channel default_log {
          file "/var/log/bind/default.log" versions 3 size 2048m;
          print-time yes;
          print-category yes;
          print-severity yes;
          severity info;
     };

    channel auth_servers_log {
          file "/var/log/bind/auth_servers.log" versions 100 size 2048m;
          print-time yes;
          print-category yes;
          print-severity yes;
          severity info;
     };

    channel dnssec_log {
          file "/var/log/bind/dnssec.log" versions 3 size 2048m;
          print-time yes;
          print-category yes;
          print-severity yes;
          severity info;
     };

    channel zone_transfers_log {
          file "/var/log/bind/zone_transfers.log" versions 3 size 2048m;
          print-time yes;
          print-category yes;
          print-severity yes;
          severity info;
     };

    channel ddns_log {
          file "/var/log/bind/ddns.log" versions 3 size 2048m;
          print-time yes;
          print-category yes;
          print-severity yes;
          severity info;
     };

     channel client_security_log {
          file "/var/log/bind/client_security.log" versions 3 size 2048m;
          print-time yes;
          print-category yes;
          print-severity yes;
          severity info;
     };

     channel rate_limiting_log {
          file "/var/log/bind/rate_limiting.log" versions 3 size 2048m;
          print-time yes;
          print-category yes;
          print-severity yes;
          severity info;
     };

     channel rpz_log {
          file "/var/log/bind/rpz.log" versions 3 size 2048m;
          print-time yes;
          print-category yes;
          print-severity yes;
          severity info;
     };

    channel dnstap_log {
          file "/var/log/bind/dnstap.log" versions 3 size 2048m;
          print-time yes;
          print-category yes;
          print-severity yes;
          severity info;
     };

     channel queries_log {
          file "/var/log/bind/queries.log" versions 600 size 2048m;
          print-time yes;
          print-category yes;
          print-severity yes;
          severity info;
     };

     channel query-errors_log {
          file "/var/log/bind/query-errors.log" versions 5 size 2048m;
          print-time yes;
          print-category yes;
          print-severity yes;
          severity dynamic;
     };

     channel default_syslog {
          print-time yes;
          print-category yes;
          print-severity yes;
          syslog daemon;
          severity info;
     };

     channel default_debug {
          print-time yes;
          print-category yes;
          print-severity yes;
          file "data/named.run";
          severity dynamic;
     };

     category default { default_syslog; default_debug; default_log; };
     category config { default_syslog; default_debug; default_log; };
     category dispatch { default_syslog; default_debug; default_log; };
     category network { default_syslog; default_debug; default_log; };
     category general { default_syslog; default_debug; default_log; };
     category zoneload { default_syslog; default_debug; default_log; };
     category resolver { auth_servers_log; default_debug; };
     category cname { auth_servers_log; default_debug; };
     category delegation-only { auth_servers_log; default_debug; };
     category lame-servers { auth_servers_log; default_debug; };
     category edns-disabled { auth_servers_log; default_debug; };
     category notify { zone_transfers_log; default_debug; };
     category xfer-in { zone_transfers_log; default_debug; };
     category xfer-out { zone_transfers_log; default_debug; };
     category update{ ddns_log; default_debug; };
     category update-security { ddns_log; default_debug; };
     category client{ client_security_log; default_debug; };
     category security { client_security_log; default_debug; };
     category rate-limit { rate_limiting_log; default_debug; };
     category spill { rate_limiting_log; default_debug; };
     category database { rate_limiting_log; default_debug; };
     category rpz { rpz_log; default_debug; };
     category dnstap { dnstap_log; default_debug; };
     category trust-anchor-telemetry { default_syslog; default_debug; default_log; };
     category queries { queries_log; };
     category query-errors {query-errors_log; };
};
EOF








cat > /var/bind/pri/d.a.c.a.f.e.e.b.f.a.e.d.d.a.e.d.ip6.arpa << 'EOF'
; Time To Live: 1D
$TTL 1D

; Origin: d.a.c.a.f.e.e.b.f.a.e.d.d.a.e.d.ip6.arpa.
; Primary Name Server: ns1.home.lab.
; Email Address: admin.home.lab.

; Serial Number: 0
; Refresh Interval: 1D
; Retry Interval: 1H
; Expire Interval: 1W
; Minimum Time To Live: 3H

; SOA Record
@   IN  SOA ns1.home.lab. admin.home.lab. (
    0    ; Serial Number
    1D   ; Refresh Interval
    1H   ; Retry Interval
    1W   ; Expire Interval
    3H )  ; Minimum Time To Live

; NS Records
@   IN  NS  ns1.home.lab.

; PTR Records
1.0.1.6.1.7.2   IN  PTR docker.home.lab.
2.0.1.6.1.7.2   IN  PTR mariab.home.lab.
3.0.1.6.1.7.2   IN  PTR bind.home.lab.
EOF










cat > /var/bind/pri/rvs.home.lab.1.168.192.in-addr.arpa << 'EOF'
; Time To Live: 1D
$TTL 1D

; Origin: 1.168.192.in-addr.arpa.
; Primary Name Server: ns1.home.lab.
; Email Address: admin.home.lab.

; Serial Number: 0
; Refresh Interval: 1D
; Retry Interval: 1H
; Expire Interval: 1W
; Minimum Time To Live: 3H

; SOA Record
@   IN  SOA ns1.home.lab. admin.home.lab. (
    0    ; Serial Number
    1D   ; Refresh Interval
    1H   ; Retry Interval
    1W   ; Expire Interval
    3H )  ; Minimum Time To Live

; NS Records
@   IN  NS  ns1.home.lab.

; PTR Records
113 IN  PTR ns1.home.lab.
113 IN  PTR alpine.home.lab.
112 IN  PTR server.home.lab.
EOF









cat > /var/bind/pri/rvs.home.lab.0.16.172.in-addr.arpa << 'EOF'
; Time To Live: 1D
$TTL 1D

; Origin: 0.16.172.in-addr.arpa.
; Primary Name Server: ns1.home.lab.
; Email Address: admin.home.lab.

; Serial Number: 0
; Refresh Interval: 1D
; Retry Interval: 1H
; Expire Interval: 1W
; Minimum Time To Live: 3H

; SOA Record
@   IN  SOA ns1.home.lab. admin.home.lab. (
    0    ; Serial Number
    1D   ; Refresh Interval
    1H   ; Retry Interval
    1W   ; Expire Interval
    3H )  ; Minimum Time To Live

; NS Records
@   IN  NS  ns1.home.lab.

; PTR Records
1   IN  PTR docker.home.lab.
2   IN  PTR mariab.home.lab.
3   IN  PTR bind.home.lab.
EOF









cat > /var/bind/pri/rvs.home.lab.f.e.e.b.f.a.e.d.d.a.e.d.ip6.arpa << 'EOF'
; Time To Live: 1D
$TTL 1D

; Origin: f.e.e.b.f.a.e.d.d.a.e.d.ip6.arpa.
; Primary Name Server: ns1.home.lab.
; Email Address: admin.home.lab.

; Serial Number: 0
; Refresh Interval: 1D
; Retry Interval: 1H
; Expire Interval: 1W
; Minimum Time To Live: 3H

; SOA Record
@   IN  SOA ns1.home.lab. admin.home.lab. (
    0    ; Serial Number
    1D   ; Refresh Interval
    1H   ; Retry Interval
    1W   ; Expire Interval
    3H )  ; Minimum Time To Live

; NS Records
@   IN  NS  ns1.home.lab.

; PTR Records
7.d.6.1.4.3.3.7.3.0.8.1.0.0.0.0.0.0.0.0   IN  PTR alpine.home.lab.
a.b.4.f.1.9.9.5.9.7.0.f.0.0.0.0.0.0.0.0   IN  PTR server.home.lab.
EOF








(
	mkdir -p /var/log/bind/
	mkdir -p /var/bind/data/

	for i in \
		default \
		auth_servers \
		zone_transfers \
		dnssec \
		ddns \
		client_security \
		rate_limiting \
		rpz \
		dnstap \
		queries \
		query-errors
	do
		touch /var/log/bind/$i.log
	done

	for i in \
		recursing \
		cache_dump.db \
		secroots \
		named_mem_stats \
		named_stats
	do
		touch /var/bind/data/$i.txt
	done

	chown -R named:root /var/bind/
	find /var/bind/ -type d -exec chmod 775 '{}' \;
	find /var/bind/ -type f -exec chmod 664 '{}' \;

	chown -R named:root /var/log/bind/
	find /var/log/bind/ -type d -exec chmod 775 '{}' \;
	find /var/log/bind/ -type f -exec chmod 664 '{}' \;

	chown -R named:root /etc/bind/
	find /etc/bind/ -type f -exec chmod 664 '{}' \;
	find /etc/bind/ -type d -exec chmod 775 '{}' \;
)
EOS