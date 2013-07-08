---
layout: post
title: "网络代理设置方法总结"
tags: [技术, linux, 网络, shell]
comment: true
date: 2013-06-30
---

下面是几种通过设置代理来取得网络的方法:

 - http代理设置
 - apt-get代理设置
 - git代理设置
 - ssh代理设置
 
### http代理设置

{% highlight bash linenos %}	
    vi /etc/environment
    export http_proxy=http://liwei.cai:CLW712mm@172.16.100.47:8080
    export ftp_proxy=ftp://liwei.cai:CLW712mm@172.16.100.47:8080
    export https_proxy=https://liwei.cai:CLW712mm@172.16.100.47:8080
{% endhighlight %}

### apt-get代理设置

{% highlight bash linenos %}
    vi /etc/apt/apt.conf
    Acquire::http::proxy "http://liwei.cai:CLW712mm@172.16.100.47:8080/";
    Acquire::ftp::proxy "ftp://liwei.cai:CLW712mm@172.16.100.47:8080/";
    Acquire::https::proxy "https://liwei.cai:CLW712mm@172.16.100.47:8080/";
{% endhighlight %}
    
### git代理设置

{% highlight bash linenos %}	
    sudo apt-get install socat
    sudo vi /usr/bin/gitproxy
    
    #!/bin/bash
    PROXY=172.16.100.47
    PROXYPORT=8080
    PROXYAUTH=liwei.cai:CLW712mm
    exec socat STDIO PROXY:$PROXY:$1:$2,proxyport=$PROXYPORT,proxyauth=$PROXYAUTH
    
    sudo  chmod +x /usr/bin/gitproxy
    git config --global core.gitproxy gitproxy
{% endhighlight %}
    
### ssh代理设置

[https://help.github.com/articles/error-permission-denied-publickey](https://help.github.com/articles/error-permission-denied-publickey)
[http://stackoverflow.com/questions/15577300/connecting-to-host-by-ssh-client-in-linux-by-proxy](http://stackoverflow.com/questions/15577300/connecting-to-host-by-ssh-client-in-linux-by-proxy)
