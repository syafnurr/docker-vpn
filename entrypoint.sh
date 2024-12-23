#!/bin/sh

openvpn --config /etc/openvpn/vpn-config.ovpn --auth-user-pass /etc/openvpn/auth.txt --daemon

echo "Waiting for VPN connection..."
sleep 120

echo "Checking VPN connection..."
curl ifconfig.me

node app.js