#!/bin/bash

# Script: install_mongodb.sh
# Description: Instalasi MongoDB Community Server 8.0 untuk Ubuntu 24.04 (Noble)

# Update sistem dan instal dependensi
echo "Menginstal gnupg dan curl..."
sudo apt-get update
sudo apt-get install -y gnupg curl

# Import MongoDB public key
echo "Mengimpor kunci publik MongoDB..."
curl -fsSL https://www.mongodb.org/static/pgp/server-8.0.asc | \
    sudo gpg -o /usr/share/keyrings/mongodb-server-8.0.gpg --dearmor

# Tambahkan repo MongoDB ke sources.list
echo "Menambahkan repository MongoDB..."
echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-8.0.gpg ] https://repo.mongodb.org/apt/ubuntu noble/mongodb-org/8.0 multiverse" | \
    sudo tee /etc/apt/sources.list.d/mongodb-org-8.0.list

# Perbarui daftar paket
echo "Memperbarui database paket..."
sudo apt-get update

# Instal MongoDB
echo "Menginstal MongoDB Community Server..."
sudo apt-get install -y mongodb-org

echo "Instalasi selesai. Kamu bisa memulai MongoDB dengan: sudo systemctl start mongod"
