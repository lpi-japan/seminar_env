#!/bin/bash
set -euo pipefail

# 環境変数が渡されていない場合のデフォルト値設定
CACHE_DNS_IP="${CACHE_DNS_IP:-192.168.0.60}"
CONTENT_DNS_IP="${CONTENT_DNS_IP:-192.168.0.50}"
FORWARDER_IP="${FORWARDER_IP:-192.168.0.254}"

echo "========================================="
echo "キャッシュDNSのセットアップを開始します"
echo "Cache DNS IP:    ${CACHE_DNS_IP}"
echo "Content DNS IP:  ${CONTENT_DNS_IP}"
echo "Forwarder IP:    ${FORWARDER_IP}"
echo "========================================="

# 1. パッケージのインストール
echo "[1/3] BIND パッケージをインストールしています..."
dnf install -y bind bind-chroot

# 2. /etc/named.conf の作成
echo "[2/3] /etc/named.conf を生成しています..."
cat << EOF > /etc/named.conf
options {
	listen-on port 53 { 127.0.0.1; ${CACHE_DNS_IP}; };
	listen-on-v6 port 53 { ::1; };
	directory 	"/var/named";
	dump-file 	"/var/named/data/cache_dump.db";
	statistics-file "/var/named/data/named_stats.txt";
	memstatistics-file "/var/named/data/named_mem_stats.txt";
	secroots-file	"/var/named/data/named.secroots";
	recursing-file	"/var/named/data/named.recursing";
	allow-query     { localhost; 192.168.0.0/24; };

	recursion yes;

	dnssec-validation yes;
	validate-except { "linuc.test"; };

	managed-keys-directory "/var/named/dynamic";
	geoip-directory "/usr/share/GeoIP";

	pid-file "/run/named/named.pid";
	session-keyfile "/run/named/session.key";

	forwarders { ${FORWARDER_IP}; };

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
	type forward;
	forward only;
	forwarders { ${CONTENT_DNS_IP}; };
};

include "/etc/named.rfc1912.zones";
include "/etc/named.root.key";
EOF

# 3. システム設定・所有権・SELinux・サービスの起動
echo "[3/3] 所有権の設定およびサービスを起動しています..."
grubby --update-kernel=ALL --args="console=tty0 console=ttyS0,115200n8" || true
localectl set-keymap jp106

# 所有権と権限の設定
chmod 0640 /etc/named.conf
chown root:named /etc/named.conf

# SELinuxコンテキストの復元
restorecon -Rv /etc/named.conf

# サービスの有効化と起動
systemctl enable --now named-chroot

echo "========================================="
echo "セットアップが正常に完了しました！"
echo "========================================="
