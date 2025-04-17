#!/bin/bash

echo "🚀 Menghapus MongoDB lama dan datanya..."
sudo systemctl stop mongod
sudo apt purge -y mongodb-org*
sudo rm -rf /var/log/mongodb
sudo rm -rf /var/lib/mongodb

echo "📦 Menambahkan repository MongoDB 4.4..."
wget -qO - https://www.mongodb.org/static/pgp/server-4.4.asc | sudo apt-key add -

echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu $(lsb_release -cs)/mongodb-org/4.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.4.list

echo "🔄 Melakukan update repo..."
sudo apt update

echo "⬇️ Menginstall MongoDB 4.4..."
sudo apt install -y mongodb-org

echo "🟢 Menyalakan dan mengaktifkan layanan MongoDB..."
sudo systemctl start mongod
sudo systemctl enable mongod

echo "✅ MongoDB 4.4 telah berhasil diinstal dan dijalankan!"
