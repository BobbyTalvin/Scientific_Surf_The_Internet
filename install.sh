#!/bin/bash
unamem="$(uname -m)"
unameu="$(tr '[:lower:]' '[:upper:]' <<<$(uname))"

echo "CPU: $unamem"
echo "OS: $unameu"

if [ "$unamem" != "x86_64" -o $unameu != "LINUX" ]
then
  echo "配置要求：x86_64 + ubuntu(>= 18.04)"
  exit 0
fi

# uuid
read -p "请输入UUID: " uuid

while [ -z "$uuid" ]
do
  echo "UUID是必填项！"
  read -p "请输入UUID: " uuid
done

# domain
read -p "请输入域名: " domain

while [ -z "$domain" ]
do
  echo "域名是必填项！"
  read -p "请输入域名: " domain
done

# ipv6
read -p "是否 ipv6-only 服务 [y/N]" ipv6

if [ -z "$ipv6" ] || [ "$ipv6" != "y" -a "$ipv6" != "Y" ]
then
  ipv6="N"
fi

# Cloudflare Warp
read -p "启用Cloudflare Warp [Y/n] (ipv6-only 推荐开启)" warp
if [ -z "$warp" ] || [ "$warp" != "n" -a "$warp" != "N" ]
then
  warp="Y"
fi

# zsh
read -p "是否安装 zsh [Y/n]" zsh
if [ -z "$zsh" ] || [ "$zsh" != "n" -a "$zsh" != "N" ]
then
  zsh="Y"
fi

# install warp
if [ "$warp" == "y" -o "$warp" == "Y" ]
then
  echo "启用 Cloudflare Warp！" &&\
  curl https://pkg.cloudflareclient.com/pubkey.gpg | gpg --yes --dearmor --output /usr/share/keyrings/cloudflare-warp-archive-keyring.gpg &&\
  echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/cloudflare-warp-archive-keyring.gpg] https://pkg.cloudflareclient.com/ bullseye main' | tee /etc/apt/sources.list.d/cloudflare-client.list &&\
  apt-get update &&\
  apt -y install cloudflare-warp &&\
  warp-cli registration new &&\
  warp-cli mode proxy &&\
  warp-cli connect
else
  apt-get update
fi

curl -O https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh &&\
bash install-release.sh &&\
systemctl enable v2ray &&\
systemctl start v2ray &&\
sed -i 'd' /usr/local/etc/v2ray/config.json &&\
([ "$warp" == "y" -o "$warp" == "Y" ] && echo "{
  \"log\" : {
    \"error\": \"/var/log/v2ray/error.log\",
    \"loglevel\": \"warning\"
  },
  \"policy\": {
    \"levels\": {
      \"0\": {
        \"handshake\": 8,
        \"connIdle\": 600,
        \"uplinkOnly\": 4,
        \"downlinkOnly\": 10,
        \"statsUserUplink\": false,
        \"statsUserDownlink\": false,
        \"bufferSize\": 10240
      },
      \"1\": {
        \"handshake\": 4,
        \"connIdle\": 300,
        \"uplinkOnly\": 2,
        \"downlinkOnly\": 5,
        \"statsUserUplink\": false,
        \"statsUserDownlink\": false,
        \"bufferSize\": 2048
      },
      \"2\": {
        \"handshake\": 4,
        \"connIdle\": 120,
        \"uplinkOnly\": 1,
        \"downlinkOnly\": 3,
        \"statsUserUplink\": false,
        \"statsUserDownlink\": false,
        \"bufferSize\": 1024
      },
      \"3\": {
        \"handshake\": 4,
        \"connIdle\": 60,
        \"uplinkOnly\": 1,
        \"downlinkOnly\": 3,
        \"statsUserUplink\": false,
        \"statsUserDownlink\": false,
        \"bufferSize\": 512
      }
    },
    \"system\": {
      \"statsInboundUplink\": false,
      \"statsInboundDownlink\": false
    }
  },
  \"inbound\": {
    \"port\": 10001,
    \"listen\": \"127.0.0.1\",
    \"protocol\": \"vmess\",
    \"settings\": {
      \"clients\": [
        {
          \"id\": \"$uuid\",
          \"level\": 0,
          \"alterId\": 0
        }
      ]
    },
    \"streamSettings\": {
      \"network\": \"ws\",
      \"security\": \"auto\",
      \"wsSettings\": {
        \"path\": \"/ray\"
      }
    }
  },
\"outbounds\": [
    {
      \"protocol\": \"socks\",
      \"settings\": {
        \"servers\": [
          {
            \"address\": \"127.0.0.1\",
            \"port\": 40000
          }
        ]
      }
    },
    {
      \"protocol\": \"blackhole\",
      \"settings\": {},
      \"tag\": \"block\"
    }
  ],
  \"routing\": {
    \"domainStrategy\": \"AsIs\",
    \"rules\": [
      {
        \"type\": \"field\",
        \"outboundTag\": \"block\",
        \"protocol\": [
          \"bittorrent\"
        ]
      }
    ]
  }
}" || echo "{
  \"log\" : {
    \"error\": \"/var/log/v2ray/error.log\",
    \"loglevel\": \"warning\"
  },
  \"policy\": {
    \"levels\": {
      \"0\": {
        \"handshake\": 8,
        \"connIdle\": 600,
        \"uplinkOnly\": 4,
        \"downlinkOnly\": 10,
        \"statsUserUplink\": false,
        \"statsUserDownlink\": false,
        \"bufferSize\": 10240
      },
      \"1\": {
        \"handshake\": 4,
        \"connIdle\": 300,
        \"uplinkOnly\": 2,
        \"downlinkOnly\": 5,
        \"statsUserUplink\": false,
        \"statsUserDownlink\": false,
        \"bufferSize\": 2048
      },
      \"2\": {
        \"handshake\": 4,
        \"connIdle\": 120,
        \"uplinkOnly\": 1,
        \"downlinkOnly\": 3,
        \"statsUserUplink\": false,
        \"statsUserDownlink\": false,
        \"bufferSize\": 1024
      },
      \"3\": {
        \"handshake\": 4,
        \"connIdle\": 60,
        \"uplinkOnly\": 1,
        \"downlinkOnly\": 3,
        \"statsUserUplink\": false,
        \"statsUserDownlink\": false,
        \"bufferSize\": 512
      }
    },
    \"system\": {
      \"statsInboundUplink\": false,
      \"statsInboundDownlink\": false
    }
  },
  \"inbound\": {
    \"port\": 10001,
    \"listen\": \"127.0.0.1\",
    \"protocol\": \"vmess\",
    \"settings\": {
      \"clients\": [
        {
          \"id\": \"$uuid\",
          \"level\": 0,
          \"alterId\": 0
        }
      ]
    },
    \"streamSettings\": {
      \"network\": \"ws\",
      \"security\": \"auto\",
      \"wsSettings\": {
        \"path\": \"/ray\"
      }
    }
  },
\"outbounds\": [
    {
      \"protocol\": \"freedom\",
      \"settings\": {}
    },
    {
      \"protocol\": \"blackhole\",
      \"settings\": {},
      \"tag\": \"block\"
    }
  ],
  \"routing\": {
    \"domainStrategy\": \"AsIs\",
    \"rules\": [
      {
        \"type\": \"field\",
        \"outboundTag\": \"block\",
        \"protocol\": [
          \"bittorrent\"
        ]
      }
    ]
  }
}") > /usr/local/etc/v2ray/config.json &&\
systemctl restart v2ray &&\
apt-get install -y socat &&\
curl  https://get.acme.sh | sh &&\
~/.acme.sh/acme.sh --upgrade --auto-upgrade

if [ "$ipv6" == "y" -o "$ipv6" == "Y" ]
then
  ~/.acme.sh/acme.sh --issue -d $domain --server letsencrypt --days 180 --standalone -k ec-256 --listen-v6
else
  ~/.acme.sh/acme.sh --issue -d $domain --server letsencrypt --days 180 --standalone -k ec-256
fi

~/.acme.sh/acme.sh --installcert -d $domain --fullchainpath /usr/local/etc/v2ray/v2ray.crt --keypath /usr/local/etc/v2ray/v2ray.key --ecc &&\
apt-get install -y nginx &&\
nginx -s stop &&\
sed -i 'd' /etc/nginx/nginx.conf &&\
([ "$ipv6" == "y" -o "$ipv6" == "Y" ] && echo "user www-data;
worker_processes auto;
pid /run/nginx.pid;
include /etc/nginx/modules-enabled/*.conf;

events {
  worker_connections 768;
  # multi_accept on;
}

http {
  server {
    listen 80;
    listen [::]:80 ipv6only=on;
    server_name  $domain;

    location /favicon.ico {
      root /srv/blog;
    }
  }
  server {
      listen 443 ssl;
      listen [::]:443 ssl ipv6only=on;
      ssl_certificate       /usr/local/etc/v2ray/v2ray.crt;
      ssl_certificate_key   /usr/local/etc/v2ray/v2ray.key;
      ssl_protocols         TLSv1 TLSv1.1 TLSv1.2;
      ssl_ciphers           HIGH:!aNULL:!MD5;
      server_name           $domain;
      location /ray {
        proxy_redirect off;
        proxy_pass http://127.0.0.1:10001;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \"WebSocket\";
        proxy_set_header Connection \"Upgrade\";
        proxy_set_header Host \$http_host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
      }
      location /favicon.ico {
        root /srv/blog;
      }
  }
  ##
  # Basic Settings
  ##

  sendfile on;
  tcp_nopush on;
  tcp_nodelay on;
  keepalive_timeout 65;
  types_hash_max_size 2048;
  # server_tokens off;

  # server_names_hash_bucket_size 64;
  # server_name_in_redirect off;

  include /etc/nginx/mime.types;
  default_type application/octet-stream;

  ##
  # SSL Settings
  ##

  ssl_protocols TLSv1 TLSv1.1 TLSv1.2 TLSv1.3; # Dropping SSLv3, ref: POODLE
  ssl_prefer_server_ciphers on;

  ##
  # Logging Settings
  ##

  access_log /var/log/nginx/access.log;
  error_log /var/log/nginx/error.log;

  ##
  # Gzip Settings
  ##

  gzip on;

  # gzip_vary on;
  # gzip_proxied any;
  # gzip_comp_level 6;
  # gzip_buffers 16 8k;
  # gzip_http_version 1.1;
  # gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;

  ##
  # Virtual Host Configs
  ##

  include /etc/nginx/conf.d/*.conf;
  include /etc/nginx/sites-enabled/*;
}" || echo "user www-data;
worker_processes auto;
pid /run/nginx.pid;
include /etc/nginx/modules-enabled/*.conf;

events {
  worker_connections 768;
  # multi_accept on;
}

http {
  server {
    listen       80;
    server_name  $domain;

    location /favicon.ico {
      root /srv/blog;
    }
  }
  server {
      listen  443 ssl;
      ssl_certificate       /usr/local/etc/v2ray/v2ray.crt;
      ssl_certificate_key   /usr/local/etc/v2ray/v2ray.key;
      ssl_protocols         TLSv1 TLSv1.1 TLSv1.2;
      ssl_ciphers           HIGH:!aNULL:!MD5;
      server_name           $domain;
      location /ray {
        proxy_redirect off;
        proxy_pass http://127.0.0.1:10001;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \"WebSocket\";
        proxy_set_header Connection \"Upgrade\";
        proxy_set_header Host \$http_host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
      }
      location /favicon.ico {
        root /srv/blog;
      }
  }
  ##
  # Basic Settings
  ##

  sendfile on;
  tcp_nopush on;
  tcp_nodelay on;
  keepalive_timeout 65;
  types_hash_max_size 2048;
  # server_tokens off;

  # server_names_hash_bucket_size 64;
  # server_name_in_redirect off;

  include /etc/nginx/mime.types;
  default_type application/octet-stream;

  ##
  # SSL Settings
  ##

  ssl_protocols TLSv1 TLSv1.1 TLSv1.2 TLSv1.3; # Dropping SSLv3, ref: POODLE
  ssl_prefer_server_ciphers on;

  ##
  # Logging Settings
  ##

  access_log /var/log/nginx/access.log;
  error_log /var/log/nginx/error.log;

  ##
  # Gzip Settings
  ##

  gzip on;

  # gzip_vary on;
  # gzip_proxied any;
  # gzip_comp_level 6;
  # gzip_buffers 16 8k;
  # gzip_http_version 1.1;
  # gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;

  ##
  # Virtual Host Configs
  ##

  include /etc/nginx/conf.d/*.conf;
  include /etc/nginx/sites-enabled/*;
}") > /etc/nginx/nginx.conf &&\
nginx -c /etc/nginx/nginx.conf &&\
wget --no-check-certificate -O /opt/bbr.sh https://github.com/teddysun/across/raw/master/bbr.sh &&\
chmod 755 /opt/bbr.sh &&\
/opt/bbr.sh

if [ "$zsh" == "y" -o "$zsh" == "Y" ]
then
  apt-get install -y git &&\
  apt-get install -y zsh &&\
  git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh &&\
  cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc &&\
  chsh -s /bin/zsh &&\
  sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="ys"/' /root/.zshrc &&\
  sed -i '$a plugins=(git incr)' /root/.zshrc &&\
  mkdir /root/.oh-my-zsh/plugins/incr &&\
  wget -P /root/.oh-my-zsh/plugins/incr http://mimosa-pudica.net/src/incr-0.2.zsh
fi

if [ "$warp" == "y" -o "$warp" == "Y" ]
then
  crontab -l > conf && echo "0,30 * * * * /bin/systemctl restart warp-svc" >> conf && crontab conf && rm conf &&\
  systemctl restart cron
fi

exit 0