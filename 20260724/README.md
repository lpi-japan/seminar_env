# LinuCレベル1 1.01：Linuxのインストールと仮想マシン・コンテナの利用

2026年7月24日に開催された「LinuCレベル1 1.01：Linuxのインストールと仮想マシン・コンテナの利用」セミナーのハンズオン演習環境です。  

---

## 📌 セミナー概要

* **対象レベル**: LinuC レベル1（101 / 102試験相当）
* **テーマ**: Linuxのインストールと仮想マシン・コンテナの利用

---

## 🛠️ 演習環境の構築手順

### 1. 構築方法の選択

本セミナーでは、以下の方法で演習環境を提供しています。ご自身の環境に合わせていずれかを選択してください。

| 構築方法 | 対象 | 概要 |
| :--- | :--- | :--- |
| 構築方法A: スクリプト実行 | Linux環境（VM）をお持ちの方 | 付属の `setup*.sh` を実行して環境を自動構築します |
| 構築方法B: OVAイメージ | VirtualBoxを利用する方 | 事前構築済みの仮想マシンイメージ（.ova）をインポートします |

### 2. セットアップ手順

#### 構築方法A：スクリプト実行 (`setup*.sh`)

1. Debian 13に対して以下のコマンドを実行してセットアップを行います。

- virshおよびdockerコマンドの確認用サーバー
```bash
curl -sSL https://raw.githubusercontent.com/lpi-japan/seminar_env/main/20260724/setup.sh | sudo -E bash

# スクリプトを実行したら再起動してください
sudo reboot
```

#### 構築方法B：OVAイメージ

[OVAイメージ](https://linuc-assets.sukimaru.com/20260724/Debian13-Docker-Virsh-Lab.ova)をダウンロードして、VirtualBoxにインポートします。

## 🔍 動作確認
環境構築が正しく完了しているか、以下のコマンドで確認してください。

```bash
virsh list
docker container ls
```
