#!/bin/bash

sudo apt-get update
sudo apt-get install -y ca-certificates curl libvirt-clients libvirt-daemon-system virtinst qemu-system-x86
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian trixie stable" | sudo tee /etc/apt/sources.list.d/docker.list
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo systemctl enable --now docker
sudo virsh net-info default | grep -q 'Active: *yes' || sudo virsh net-start default
sudo virsh net-info default | grep -q 'Autostart: *yes' || sudo virsh net-autostart default
sudo usermod -aG docker,kvm,libvirt linuc
grep -qF 'export LIBVIRT_DEFAULT_URI="qemu:///system"' /home/linuc/.bashrc || echo 'export LIBVIRT_DEFAULT_URI="qemu:///system"' >> /home/linuc/.bashrc
