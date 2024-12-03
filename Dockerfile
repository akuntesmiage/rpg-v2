# Gunakan Node.js versi LTS berbasis Debian Buster
FROM node:lts-buster

# Perbarui repositori, instal dependensi, dan bersihkan cache
RUN apt-get update && \
  apt-get install -y \
  ffmpeg \
  imagemagick \
  webp && \
  apt-get upgrade -y && \
  rm -rf /var/lib/apt/lists/*

# Instal pm2 sebagai global dependency
RUN npm install -g pm2

# Verifikasi bahwa pm2 berhasil diinstal
RUN which pm2

# Buat direktori kerja
WORKDIR /app

# Salin file package.json terlebih dahulu
COPY package.json ./

# Salin package-lock.json jika ada
COPY package-lock.json* ./

# Instal semua dependensi Node.js dari package.json
RUN npm install && npm install qrcode-terminal

# Salin semua file ke dalam container
COPY . .

# Pastikan izin file dan direktori sesuai agar tidak ada konflik
RUN chmod -R 755 /app

# Tambahkan batasan heap memory untuk Node.js
ENV NODE_OPTIONS="--max-old-space-size=2048"

# Buat lokasi cache tanpa batas
ENV TMP_DIR="/tmp/app_cache"
RUN mkdir -p $TMP_DIR && chmod -R 777 $TMP_DIR

# Tambahkan skrip untuk membersihkan cache secara otomatis saat container dimulai
RUN echo '#!/bin/bash\nrm -rf $TMP_DIR/*\npm install --force\npm2-runtime start.js' > /cleanup-and-start.sh && \
    chmod +x /cleanup-and-start.sh

# Expose port 5000 untuk aplikasi
EXPOSE 5000

# Jalankan aplikasi dengan skrip pembersihan
CMD ["/bin/bash", "/cleanup-and-start.sh"]
