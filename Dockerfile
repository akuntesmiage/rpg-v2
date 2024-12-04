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

# Setel direktori kerja
WORKDIR /app

# Salin file package.json terlebih dahulu
COPY package.json ./

# Salin package-lock.json jika ada
COPY package-lock.json* ./

# Instal semua dependensi Node.js
RUN npm install

# Salin semua file aplikasi ke dalam container
COPY . .

# Expose port untuk aplikasi (misalnya port 5000)
EXPOSE 5000

# Jalankan aplikasi dengan PM2
CMD ["pm2", "start", "start.js", "--name", "rpg-v2", "--watch", "--autorestart"]
