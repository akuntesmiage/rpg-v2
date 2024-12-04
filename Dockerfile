# Use Node.js LTS based on Debian Buster
FROM node:lts-buster

# Update repositories, install dependencies, and clean cache
RUN apt-get update && \
  apt-get install -y \
  ffmpeg \
  imagemagick \
  webp && \
  apt-get upgrade -y && \
  rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /app

# Copy package.json first
COPY package.json ./

# Copy package-lock.json if available
COPY package-lock.json* ./

# Install Node.js dependencies
RUN npm install

# Install PM2 globally
RUN npm install pm2 -g

# Copy all files to the container
COPY . .

# Expose port 5000 for your app
EXPOSE 5000

# Use PM2 to start the app and ensure it's auto-restarted
CMD ["pm2", "start", "start.js", "--name", "rpg-v2", "--watch", "--autorestart"]
