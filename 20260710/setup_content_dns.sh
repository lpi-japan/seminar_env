#!/bin/bash
set -euo pipefail

# 環境変数が渡されていない場合のデフォルト値設定
CONTENT_DNS_IP="${CONTENT_DNS_IP:-192.168.0.50}"

echo "========================================="
echo "コンテンツDNSのセットアップを開始します"
echo "DNS Server IP: ${CONTENT_DNS_IP}"
echo "========================================="

# 1. パッケージのインストール
echo "[1/3] BIND パッケージをインストールしています..."
dnf install -y bind bind-chroot

# 2. /etc/named.conf の作成
echo "[2/3] /etc/named.conf を生成しています..."
cat << EOF > /etc/named.conf
options {
	listen-on port 53 { 127.0.0.1; ${CONTENT_DNS_IP}; };
	listen-on-v6 port 53 { ::1; };
	directory 	"/var/named";
	dump-file 	"/var/named/data/cache_dump.db";
	statistics-file "/var/named/data/named_stats.txt";
	memstatistics-file "/var/named/data/named_mem_stats.txt";
	secroots-file	"/var/named/data/named.secroots";
	recursing-file	"/var/named/data/named.recursing";
	allow-query     { localhost; 192.168.0.0/24; };

	recursion no;

	dnssec-validation yes;

	managed-keys-directory "/var/named/dynamic";
	geoip-directory "/usr/share/GeoIP";

	pid-file "/run/named/named.pid";
	session-keyfile "/run/named/session.key";

	/* https://fedoraproject.org/wiki/Changes/CryptoPolicy */
	include "/etc/crypto-policies/back-ends/bind.config";
};

logging {
        channel default_debug {
                file "data/named.run";
                severity dynamic;
        };
};

zone "." IN {
	type hint;
	file "named.ca";
};

zone "linuc.test." IN {
	type master;
	file "linuc.test.zone";
};

include "/etc/named.rfc1912.zones";
include "/etc/named.root.key";
EOF

# 3. ゾーンファイルの作成
echo "[3/4] /var/named/linuc.test.zone を生成しています..."
cat << EOF > /var/named/linuc.test.zone
\$TTL 3H
\$ORIGIN linuc.test.
@ IN SOA @ admin.linuc.test. (
          0     ; serial
          1D    ; refresh
          1H    ; retry
          1W    ; expire
          1M )  ; minimum

@    IN NS ns1.linuc.test.
ns1  IN A ${CONTENT_DNS_IP}
a    IN A 192.0.2.1
aaaa IN AAAA 2001:db8::1
@    IN TXT "v=spf1 ip4:192.0.2.0/24 -all"
EOF

# 所有権と権限の設定
chmod 0640 /etc/named.conf /var/named/linuc.test.zone
chown root:named /etc/named.conf /var/named/linuc.test.zone

# SELinuxコンテキストの復元
restorecon -Rv /etc/named.conf /var/named/

# サービスの有効化と起動
systemctl enable --now named-chroot

echo "========================================="
echo "セットアップが正常に完了しました！"
echo "========================================="
