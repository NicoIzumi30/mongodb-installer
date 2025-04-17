# Panduan Instalasi dan Konfigurasi MongoDB dengan Docker pada Ubuntu Server

## Langkah-langkah Instalasi

### 1. Update Repository Ubuntu
```bash
sudo apt update
```

### 2. Instal Docker
```bash
sudo apt install -y docker.io
```

### 3. Aktifkan dan Jalankan Layanan Docker
```bash
sudo systemctl enable --now docker
```

### 4. Instal Docker Compose
```bash
sudo apt install -y docker-compose
```

### 5. Tambahkan User ke Grup Docker
```bash
sudo usermod -aG docker $USER
```

### 6. Terapkan Perubahan Grup Tanpa Logout
```bash
newgrp docker
```

### 7. Buat Direktori untuk Data MongoDB
```bash
mkdir -p ~/mongodb/data
```

### 8. Buat File docker-compose.yml
```bash
nano ~/mongodb/docker-compose.yml
```

### 9. Isi File docker-compose.yml
```yaml
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
```

### 10. Jalankan MongoDB Container
```bash
cd ~/mongodb
docker-compose up -d
```

## Verifikasi Instalasi

### 11. Cek Status Container MongoDB
```bash
docker ps | grep mongodb
```

### 12. Lihat Log MongoDB
```bash
docker logs mongodb
```

### 13. Tes Koneksi ke MongoDB
```bash
docker exec -it mongodb mongosh --host localhost -u admin -p password
```

### 14. Dapatkan IP Address Server (untuk Koneksi dari Windows)
```bash
hostname -I
```

## Koneksi dari Windows

Gunakan MongoDB Compass dengan string koneksi:
```
mongodb://admin:password@IP_SERVER:27017/
```
