---
title: "Hugo使用指北"
date: 2023-02-14T23:51:47+08:00
draft: true
toc: true
image: 
tags: ["hugo"] 
categories: [技术] 
---

1. 新建文章

```bash
hugo new posts/my-post.md
```

2. 编辑摘要

```bash
title: "title"
date: 2021-04-04T15:08:47+08:00
draft: true
toc: true
image: "image.url"
tags: ["tag1","tag2"]
categories: [category]
```

3. 编辑内容

4. 本地开启草稿视图

```bash
hugo server -D
```

5. 发布草稿文章

如果需要将草稿内容进行发布，在执行 hugo 生成发布内容时附带 -D 或则 --buildDrafts 即可。

```bash
hugo -D
```

**参考链接**

[使用 Hugo 发布文章](https://tangzixiang.github.io/posts/2019/%E4%BD%BF%E7%94%A8-hugo-%E5%8F%91%E5%B8%83%E6%96%87%E7%AB%A0/)


