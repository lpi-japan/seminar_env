# LinuCレベル2 ドメインネームサーバー 演習環境

2026年7月10日〜7月17日に開催された「LinuCレベル2 ドメインネームサーバー」セミナーのハンズオン演習環境です。  
BIND等のDNSサーバー構築・設定の学習や、セミナーの復習にご活用ください。

---

## 📌 セミナー概要

* **対象レベル**: LinuC レベル2（201 / 202試験相当）
* **テーマ**: DNSの仕組み、BINDの構築・ゾーンファイル設定・動作検証

---

## 🛠️ 演習環境の構築手順

### 1. 構築方法の選択

本セミナーでは、以下の方法で演習環境を提供しています。ご自身の環境に合わせていずれかを選択してください。

| 構築方法 | 対象 | 概要 |
| :--- | :--- | :--- |
| 構築方法A: スクリプト実行 | Linux環境（VM）をお持ちの方 | 付属の `setup*.sh` を実行して環境を自動構築します |

### 2. セットアップ手順

#### 構築方法A：スクリプト実行 (`setup*.sh`)

1. 以下のコマンドを実行してセットアップを行います。

- 権威DNSサーバー
```bash
# 権威DNSサーバーのIPアドレスを指定してください
export CONTENT_DNS_IP=192.168.0.50

curl -sSL https://raw.githubusercontent.com/lpi-japan/seminar_env/main/seminar/20260710/setup_content_dns.sh | sudo bash
```

- キャッシュDNSサーバー
```bash
# 権威DNSサーバーのIPアドレスを指定してください
export CONTENT_DNS_IP=192.168.0.50

# キャッシュDNSサーバーのIPアドレスを指定してください
export CACHE_DNS_IP=192.168.0.60

curl -sSL https://raw.githubusercontent.com/lpi-japan/seminar_env/main/seminar/20260710/setup_cache_dns.sh | sudo bash
```

## 🔍 動作確認
環境構築が正しく完了しているか、以下のコマンドで確認してください。

```bash
systemctl status named-chroot
```
