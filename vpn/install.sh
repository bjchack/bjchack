#!/bin/bash
apt update && apt upgrade -y
apt install -y curl wget unzip

# download Xray
mkdir -p /usr/local/etc/xray
cd /tmp
wget -O xray.zip https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip
unzip xray.zip -d /usr/local/bin/
chmod +x /usr/local/bin/xray

# copy config
cp ~/vless-server/xray_config.json /usr/local/etc/xray/config.json

# create systemd service
cat > /etc/systemd/system/xray.service <<EOF
[Unit]
Description=Xray Service
After=network.target

[Service]
ExecStart=/usr/local/bin/xray run -config /usr/local/etc/xray/config.json
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

systemctl enable xray
systemctl start xray
