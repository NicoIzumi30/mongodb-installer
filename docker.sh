#!/bin/bash

# Script untuk instalasi dan konfigurasi MongoDB menggunakan Docker
# Dibuat pada: April 18, 2025

# Warna untuk output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}=== Menginstall MongoDB dengan Docker pada Ubuntu Server ===${NC}"

# Update repository
echo -e "${GREEN}[1/7]${NC} Mengupdate repository..."
sudo apt update

# Install Docker jika belum terinstall
echo -e "${GREEN}[2/7]${NC} Menginstall Docker..."
if ! command -v docker &> /dev/null; then
    sudo apt install -y docker.io
    sudo systemctl enable --now docker
    echo -e "${GREEN}Docker berhasil diinstall${NC}"
else
    echo -e "${GREEN}Docker sudah terinstall${NC}"
fi

# Install Docker Compose jika belum terinstall
echo -e "${GREEN}[3/7]${NC} Menginstall Docker Compose..."
if ! command -v docker-compose &> /dev/null; then
    sudo apt install -y docker-compose
    echo -e "${GREEN}Docker Compose berhasil diinstall${NC}"
else
    echo -e "${GREEN}Docker Compose sudah terinstall${NC}"
fi

# Tambahkan user saat ini ke grup docker
echo -e "${GREEN}[4/7]${NC} Menambahkan user ke grup docker..."
sudo usermod -aG docker $USER
echo -e "${YELLOW}Catatan: Anda perlu logout dan login kembali agar perubahan grup berlaku${NC}"

# Buat direktori untuk MongoDB
echo -e "${GREEN}[5/7]${NC} Membuat direktori untuk data MongoDB..."
mkdir -p ~/mongodb/data

# Buat file docker-compose.yml
echo -e "${GREEN}[6/7]${NC} Membuat file konfigurasi docker-compose.yml..."
cat > ~/mongodb/docker-compose.yml << 'EOF'
version: '3'
services:
  mongodb:
    image: mongo:4.4
    container_name: mongodb
    restart: always
    ports:
      - "27017:27017"
    environment:
      - MONGO_INITDB_ROOT_USERNAME=admin
      - MONGO_INITDB_ROOT_PASSWORD=password
    volumes:
      - ./data:/data/db
    command: mongod --bind_ip_all
EOF

echo -e "${GREEN}File docker-compose.yml berhasil dibuat di ~/mongodb/docker-compose.yml${NC}"
echo -e "${YELLOW}Username default: admin${NC}"
echo -e "${YELLOW}Password default: password${NC}"
echo -e "${YELLOW}Jika ingin mengubah kredensial, silakan edit file docker-compose.yml${NC}"

# Jalankan container MongoDB
echo -e "${GREEN}[7/7]${NC} Menjalankan container MongoDB..."
cd ~/mongodb
docker-compose up -d

# Verifikasi status
if [ $? -eq 0 ]; then
    echo -e "${GREEN}MongoDB berhasil dijalankan!${NC}"
    echo -e "${GREEN}Status container:${NC}"
    docker ps | grep mongodb
    
    # Dapatkan IP address
    IP_ADDRESS=$(hostname -I | awk '{print $1}')
    
    echo -e "\n${GREEN}=== INFORMASI KONEKSI ===${NC}"
    echo -e "MongoDB berjalan pada port: ${YELLOW}27017${NC}"
    echo -e "String koneksi: ${YELLOW}mongodb://admin:password@$IP_ADDRESS:27017/${NC}"
    echo -e "\nUntuk menghubungkan dari Windows, gunakan MongoDB Compass dengan string koneksi di atas"
    echo -e "Pastikan port 27017 sudah di-forward jika menggunakan NAT di VirtualBox"
else
    echo -e "${RED}Gagal menjalankan MongoDB container. Silakan cek pesan error di atas.${NC}"
fi

echo -e "\n${YELLOW}Untuk melihat log MongoDB:${NC} docker logs mongodb"
echo -e "${YELLOW}Untuk menghentikan MongoDB:${NC} cd ~/mongodb && docker-compose down"
echo -e "${YELLOW}Untuk memulai ulang MongoDB:${NC} cd ~/mongodb && docker-compose restart"
