FROM node:18-alpine

RUN apk add --no-cache openvpn curl bash iproute2

COPY vpn.ovpn /etc/openvpn/vpn-config.ovpn
COPY auth.txt /etc/openvpn/auth.txt

WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 3003

ENTRYPOINT ["/entrypoint.sh"]