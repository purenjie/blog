---
title: "Postman使用指北"
date: 2024-08-23T11:22:23+08:00
draft: true
toc: true
image: 
tags: ["postman"] 
categories: [技术] 
---

## 粘贴 cURL 请求

![1724381954004_1h4gs23llx](https://pub-6bd5d0c20d254a3e9d8dea968e62938c.r2.dev/2024/8/1724381954004_1h4gs23llx)

## 环境设置

作用：方便切换不同环境，比如配置本地环境/测试环境/线上环境，通过切换环境就可以请求对应环境的接口

- 配置环境

![1724382099854_p4knk4pld8](https://pub-6bd5d0c20d254a3e9d8dea968e62938c.r2.dev/2024/8/1724382099854_p4knk4pld8)

- 切换环境请求

![1724382191899_srz1hh2woj](https://pub-6bd5d0c20d254a3e9d8dea968e62938c.r2.dev/2024/8/1724382191899_srz1hh2woj)

## Pre-request Script

可以在发送请求之前执行一些脚本操作

### 1. 常用指令

```js
// 获取请求方法
pm.request.method

// 设置 header
pm.request.headers.add({
    key: 'key',
    value: 'value'
});

// 设置 cookie
pm.request.headers.add({
    key: 'Cookie',
    value: "cookie_value"
});
```

### 2. 请求鉴权

后端为了服务接口不被恶意攻击，一般会有鉴权的校验，比如在 header 头中加入 `ts` 、`nonce` 等，就可以在 postman 中通过 pre-request script 统一封装起来进行调用

示例代码

```js
function randomString(e) {    
    e = e || 32;
    var t = "ABCDEFGHJKMNPQRSTWXYZabcdefhijkmnprstwxyz2345678",
    a = t.length,
    n = "";
    for (i = 0; i < e; i++) n += t.charAt(Math.floor(Math.random() * a));
    return n
}

function getParam(body) {
    var keys = [];
    for (let k in body) {
        let value = body[k];
        if (Array.isArray(value)) {
            value = JSON.stringify(value);
        }
        keys.push(k + "=" + value);
    }
    keys.sort();
    let keys_str = keys.join("&");
    return keys_str;
}

var app = "app"
var secret = "key"
var ts = Math.round (new Date().getTime()/1000)
var nonce = randomString(16)
var param = ""
if (pm.request.method === "POST") {
    param = getParam(JSON.parse(request.data))
}

pm.request.headers.add({
    key: 'app',
    value: app
});
pm.request.headers.add({
    key: 'ts',
    value: ts
});
pm.request.headers.add({
    key: 'nonce',
    value: nonce
});
console.log(app+secret+ts+param+nonce)
pm.request.headers.add({
    key: 'sign',
    value: CryptoJS.MD5(app+secret+ts+param+nonce).toString()
});
```

### 3. 在 json 请求体中写注释

postman 没有很好的写接口注释的地方，对于 `post` 请求无法直接在参数后面写注释（不符合 json 规范），通过脚本的方式达到既写注释又可以发送请求的目的

```js
// 需要在Pre-request Script中这样写，去除掉注释
if (pm?.request?.body?.options?.raw?.language === 'json') {
    const rawData = pm.request.body.toString();
    const strippedData = rawData.replace(
        /\\"|"(?:\\"|[^"])*"|(\/\/.*|\/\*[\s\S]*?\*\/)/g,
        (m, g) => g ? "" : m
    );
    pm.request.body.update(JSON.stringify(JSON.parse(strippedData)));
}
```

![1724382856856_jtnmtuhgyq](https://pub-6bd5d0c20d254a3e9d8dea968e62938c.r2.dev/2024/8/1724382856856_jtnmtuhgyq)

## Get 请求 Encode

在发送 `get` 请求时，可以右键参数 encode 请求，方便发送

![1724382983052_773f7f7a17](https://pub-6bd5d0c20d254a3e9d8dea968e62938c.r2.dev/2024/8/1724382983052_773f7f7a17)

**参考链接**

[Postman 高级用法](https://haofly.net/postman/)



