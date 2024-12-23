FROM node:18-alpine

# Mendefinisikan argumen untuk file VPN dan autentikasi
ARG VPN_CONFIG
ARG AUTH_FILE

# Install dependencies
RUN apk add --no-cache openvpn curl bash iproute2

# Menyalin file VPN dan autentikasi menggunakan argumen build
COPY ${VPN_CONFIG} /etc/openvpn/vpn-config.ovpn
COPY ${AUTH_CONFIG} /etc/openvpn/auth.txt

WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .

# Menjalankan OpenVPN dan menunggu koneksi VPN dalam Dockerfile
RUN openvpn --config /etc/openvpn/vpn-config.ovpn --auth-user-pass /etc/openvpn/auth.txt --daemon && \
    echo "Waiting for VPN connection..." && \
    sleep 120 && \
    echo "Checking VPN connection..." && \
    curl ifconfig.me

# Menjalankan aplikasi Node.js setelah VPN siap
CMD ["node", "app.js"]

EXPOSE 3003