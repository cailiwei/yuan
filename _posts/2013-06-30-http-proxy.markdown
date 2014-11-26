---
layout: post
title: "网络代理设置方法总结"
tags: [技术, 杂类]
comment: true
date: 2013-06-30
---

下面是几种通过设置代理来取得网络的方法:

 - http代理设置
 - apt-get代理设置
 - git代理设置
 - ssh代理设置
 
## http代理设置

  打开环境配置文件：`$ vi /etc/environment`
  需要注意的是要相应地替换掉代理用户名和密码，如果不需要就不需要填写
  用户名：liwei.cai 密码：CLW712mm（下面几种配置代理，此处相同，不再累述）。
{% highlight bash %}
export http_proxy=http://liwei.cai:CLW712mm@172.16.100.47:8080
export ftp_proxy=ftp://liwei.cai:CLW712mm@172.16.100.47:8080
export https_proxy=https://liwei.cai:CLW712mm@172.16.100.47:8080
{% endhighlight %}

## apt-get代理设置

  打开apt-get的配置文件：`vi /etc/apt/apt.conf`  
{% highlight bash %}
Acquire::http::proxy "http://liwei.cai:CLW712mm@172.16.100.47:8080/";
Acquire::ftp::proxy "ftp://liwei.cai:CLW712mm@172.16.100.47:8080/";
Acquire::https::proxy "https://liwei.cai:CLW712mm@172.16.100.47:8080/";
{% endhighlight %}
  执行完之后，运行：`sudo apt-get update` 查看是否可以更新源。  
    
## git代理设置

  首先下载工具软件socat：`$ sudo apt-get install socat`  
  然后新建执行脚本：`$ sudo vi /usr/bin/gitproxy`

{% highlight bash %}
#!/bin/bash
PROXY=172.16.100.47
PROXYPORT=8080
PROXYAUTH=liwei.cai:CLW712mm
exec socat STDIO PROXY:$PROXY:$1:$2,proxyport=$PROXYPORT,proxyauth=$PROXYAUTH
{% endhighlight %}

配置执行权限：   
    sudo  chmod +x /usr/bin/gitproxy  
	git config --global core.gitproxy gitproxy  
最后就是找git库，测试是否配置成功。  
    
## ssh代理设置

  参照以下链接：  
[https://help.github.com/articles/error-permission-denied-publickey](https://help.github.com/articles/error-permission-denied-publickey)  
[http://stackoverflow.com/questions/15577300/connecting-to-host-by-ssh-client-in-linux-by-proxy](http://stackoverflow.com/questions/15577300/connecting-to-host-by-ssh-client-in-linux-by-proxy)
