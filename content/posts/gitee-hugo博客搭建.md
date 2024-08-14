---
title: "hugo博客搭建部署"
date: 2020-10-11T21:36:00+08:00
draft: true
image: 
tags: ["hugo","gitee"]
categories: [技术]
---

## Hugo 构建

### Hugo 安装

- 下载[安装包](https://github.com/gohugoio/hugo/releases)
- `hugo version` 查看是否安装成功

### 生成站点基础框架

- 进入自己指定文件夹下执行 `hugo new site solejay-blog`
- 创建仓库

```bash
cd solejay-blog
git init
```

### 主题配置

- 进入 [Hugo 主题页面](https://themes.gohugo.io/) 选择主题并下载 

> 个人喜欢的两个主题：[meme](https://github.com/reuixiy/hugo-theme-meme)、[newsroom](https://themes.gohugo.io/newsroom/)、[Swift](https://themes.gohugo.io/hugo-swift-theme/)

```bash
# 下载主题
git submodule add --depth 1 https://github.com/reuixiy/hugo-theme-meme.git themes/meme
# 替换toml文件
rm config.toml && cp themes/meme/config-examples/en/config.toml config.toml
```
### 新建博客

```bash
hugo new posts/first-post.md
```

### 本地调试和打包构建

- 本地调试

```bash
hugo server -D
```

即可在本地 http://localhost:1313/ 看到静态页面

- 打包构建

调试没有问题运行 `hugo` 在当前目录下生成 `public` 子目录

## Gitee 部署

- 新建仓库

添加一个空白 repository，注意不要添加如 `README`，`.gitignore` 等文档。仓库名最好与个人空间地址一致

推送项目到 master 分支

- 进入 [Gitee](https://gitee.com/) 创建的仓库页面，从 `服务` 栏里选择 `Gitee Pages`，部署分支选择 `master`，然后点击 `启动`

## 服务器部署

1. 保证 80 端口和 443 端口没有被禁用（可查看防火墙策略）

2. 安装并启动 nginx

```bash
# 安装
sudo yum install -y nginx

# 设置开机启动
sudo systemctl enable nginx

# 启动
sudo systemctl start nginx

# 浏览器访问公网 IP 查看是否安装成功
```

3. 将 public 目录传输到服务器

```bash
# 创建同步目录
mkdir /home/solejay/blog

# 使用 rsync 方式同步
cd BLOG_FOLDER # 本地
rsync -avuz --progress --delete public/ root@ip地址:/home/solejay/blog
```

4. [申请 ssl 证书](https://console.cloud.tencent.com/ssl/dsc/apply)

- 申请免费证书
- 下载 nginx 证书
- 将证书上传到服务器

```bash
rsync -avuz --progress Nginx/ root@ip地址:/etc/nginx/
```

- 配置 nginx.conf

```bash
# For more information on configuration, see:
#   * Official English Documentation: http://nginx.org/en/docs/
#   * Official Russian Documentation: http://nginx.org/ru/docs/

user root;
#user nginx;
worker_processes auto;
error_log /var/log/nginx/error.log;
pid /run/nginx.pid;

# Load dynamic modules. See /usr/share/doc/nginx/README.dynamic.
include /usr/share/nginx/modules/*.conf;

events {
    worker_connections 1024;
}

http {
    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    sendfile            on;
    tcp_nopush          on;
    tcp_nodelay         on;
    keepalive_timeout   65;
    types_hash_max_size 2048;

    include             /etc/nginx/mime.types;
    default_type        application/octet-stream;

    # Load modular configuration files from the /etc/nginx/conf.d directory.
    # See http://nginx.org/en/docs/ngx_core_module.html#include
    # for more information.
    include /etc/nginx/conf.d/*.conf;

    server {
        listen       80 default_server;
        listen       [::]:80 default_server;
        server_name  _;
        #root         /usr/share/nginx/html;
        root         /home/solejay/blog;

        # Load configuration files for the default server block.
        include /etc/nginx/default.d/*.conf;

        location / {
            root /home/solejay/blog;
            index index.html index.htm;
        }

        error_page 404 /404.html;
            location = /40x.html {
                root /home/solejay/blog;
        }

        error_page 500 502 503 504 /50x.html;
            location = /50x.html {
        }
    }


    # 配置https
     server {
         listen 443 ssl;
         # 要配置的第七个地方
         server_name _;
         root /home/solejay/blog;
         
         # 要配置的第八个地方
         ssl_certificate /etc/nginx/solejay.cn_nginx/solejay.cn_bundle.crt;
         ssl_certificate_key /etc/nginx/solejay.cn_nginx/solejay.cn.key;
         
         # 要配置的第九个地方，可以按照我的写法
         ssl_session_timeout 10m;
         ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
         ssl_ciphers ECDHE-RSA-AES128-GCM-SHA256:HIGH:!aNULL:!MD5:!RC4:!DHE;
         ssl_prefer_server_ciphers on;
         
         # 要配置的第十个地方
         error_page 404 /404.html;
         location = /404.html {
              root /home/solejay/blog;
         }

         include /etc/nginx/default.d/*.conf;
     }
}
```

- 重新加载配置文件并重启

```bash
# 重新加载配置文件
sudo nginx -s reload

# 重启nginx
sudo systemctl restart nginx
```

- https 访问域名成功

![请求成功](https://gitee.com/solejay/pic_repo/raw/master/2023/2/15-1676438397457.png)

**参考资料**

[Hugo+Gitee 搭建个人博客](https://zhuanlan.zhihu.com/p/184625753)

[如何使用 Hugo 在 GitHub Pages 上搭建免费个人网站](https://zhuanlan.zhihu.com/p/37752930)

[hugo 博客部署到腾讯云轻量级服务器](https://cloud.tencent.com/developer/article/1944134)