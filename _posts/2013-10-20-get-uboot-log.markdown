---
layout: post
title: "获取uboot(lk)的log信息"
tags: [技术]
comment: true
date: 2013-10-20 20:01
---

###获取Android启动到lk的log的方法有:
1. 通过配置串口, 打开串口调试来获取;
2. 在lk部分实现一套类似于cmdline的驱动机制, 来实现重要log信息的传递(空间大小有限制);
3. 在内核总内存中固定分配一小段固定的物理地址来存放log, kernel中获取log信息的驱动需要自己实现;
4. 其实高通平台框架已有类似与方法3的设计: lk中的log信息被固定输出到MISC分区, 只要我们通过dd命令获取到MISC分区, 然后cat一下就可获得全部的log信息, 首先需要让设备进入download模式, 然后执行下面读分区命令:

{% highlight bash %}
if [ -z $1 ] ; then
	dd if=\\\\\.\\PhysicalDrive1 of=MISC bs=512 skip=165888  count=2048
	echo "MISC OK"
else if [ $1 == "MISC" ] ; then
	dd if=\\\\\.\\PhysicalDrive1 of=MISC bs=512 skip=165888  count=2048
	echo "fetch MISC OK"
	fi
fi
{% endhighlight %}

###可以通过类似的命令来获取其他任何分区
