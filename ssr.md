# SSR
**Note**：该服务的所有指令都以 `ubuntu 18.04` 环境为准，其他linux版本的包安装指令可以自行搜索(比如CentOs 用的是 `yum install` …)。

**Note**：所有以 `${}` 包裹起来的内容，都需要你自行替换成你自己的相应配置。

## 安装
第一步，你得先安装一个 `git` 工具：
```sh
apt-get install git
```

接下去，将ssr的git项目clone到本地：
```sh
git clone git@github.com:shadowsocksrr/shadowsocksr.git
```

或者使用https的方式进行clone：
```sh
git clone https://github.com/shadowsocksrr/shadowsocksr.git
```

然后进入这个项目并运行一个shell脚本：
```sh
cd shadowsocksr && bash initcfg.sh
```

而后，你还得安装python3：
```sh
apt-get install python3
```
最后，用python3将ssr服务跑起来：
```sh
cd shadowsocks && python3 server.py
```

## 配置你的SSR
在你的 *shadowsocksr* 文件目录里面，编辑你的 `user-config.json` 文件：
```sh
vi ~/shadowsocksr/user-config.json
```

输入下面的内容：
```json
{
  "server": "0.0.0.0",
  "server_ipv6": "::",
  "server_port": 443,
  "local_address": "127.0.0.1",
  "local_port": 1080,

  "password": "${your_password 连接ssr的密码}",
  "method": "aes-256-cfb",
  "protocol": "origin",
  "protocol_param": "",
  "obfs": "tls1.2_ticket_auth",
  "obfs_param": "${your_domain 你的域名}",
  "speed_limit_per_con": 0,
  "speed_limit_per_user": 0,

  "additional_ports" : {},
  "additional_ports_only" : false,
  "timeout": 120,
  "udp_timeout": 60,
  "dns_ipv6": false,
  "connect_verbose_info": 0,
  "redirect": ["*:443#127.0.0.1:${your_candy_port candy服务启动的端口号}"],
  "fast_open": false
}
```

## 配置你的shadowsocksr.service文件
创建一个 *shadowsocksr.service* 文件：
```sh
touch /etc/systemd/system/shadowsocksr.service
```

然后编辑它：
```sh
vi /etc/systemd/system/shadowsocksr.service
```

shadowsocksr.service 文件配置如下：
```service
[Unit]
Description=Shadowsocks R Server Service
After=default.target

[Service]
WorkingDirectory=/root/shadowsocksr/shadowsocks
ExecStart=/usr/bin/python3 server.py -c ../user-config.json
Restart=on-abnormal

[Install]
WantedBy=default.target
```

而后运行：
```sh
systemctl daemon-reload
```

最后，重启ssr服务并检查你的ssr服务运行状态：
```sh
systemctl restart shadowsocksr

systemctl status shadowsocksr
```

如果返回如下所示的内容，就证明你的ssr服务运行起来了：
```log
shadowsocksr.service - Shadowsocks R Server Service
   Loaded: loaded (/etc/systemd/system/shadowsocksr.service; disabled; vendor preset: enabled)
   Active: active (running) since Sun 2019-10-20 14:15:48 UTC; 1 weeks 4 days ago
 Main PID: 18165 (python3)
    Tasks: 1 (limit: 1109)
   CGroup: /system.slice/shadowsocksr.service
           └─18165 /usr/bin/python3 server.py -c ../user-config.json
```