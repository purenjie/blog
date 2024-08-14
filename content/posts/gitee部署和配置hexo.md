---
title: "gitee部署和配置hexo"
date: 2021-04-04T15:08:47+08:00
draft: true
image: 
tags: ["Hexo","博客"]
categories: [技术]
---

## gitee 部署 hexo

[Hexo+Gitee 零代码基础从 0 到 1 部署博客全流程（一）](https://zhuanlan.zhihu.com/p/299161193)

## 创建两个分支实现博客备份功能

[使用 hexo，如果换了电脑怎么更新博客？](https://www.zhihu.com/question/21193762)

由于 `git clone` 下来的是已经部署好的文件，需要 `rm -rf *` 删除，但是仍然有 `.git` 文件夹，所以需要 `cd blog`，`mv * repo/` 将所有文件移动到仓库文件夹里面才行

## gitignore 忽略部分文件夹和文件

初始化没有 `.gitignore` 文件时，`touch .gitignore`

```git
node_modules
public
.deploy_git
db.json
```

如果以上文件或文件夹已经在 git 中添加过，执行 `git rm --cached db.json` 或者 `git rm -d --cahced node_modules`

## 部署之后不显示网络图片

在文章头部下面添加

```
<meta name="referrer" content="no-referrer"/>
```

为了一劳永逸，修改 `scafflods/post.md`，在下面添加这一行

[解决Hexo博客引用网络图片无法显示的问题](https://blog.csdn.net/mqdxiaoxiao/article/details/96770756)