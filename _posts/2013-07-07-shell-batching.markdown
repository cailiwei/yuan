---
layout: post
tags: [技术, linux, shell]
comment: true
title: 一句话命令批量处理文本
---

###Linux Shell 批量重命名的方法

1\. 删除所有的 .bak 后缀:  
{% highlight bash %}
   `rename 's/\.bak$//' *.bak`
{% endhighlight %}

2\. 把 .markdowm 文件后缀修改为 .markdown：  
{% highlight bash %}
   `rename 's/\.markdowm$/\.markdown/' *.markdowm`
{% endhighlight %}

3\. 把所有文件的文件名改为小写：  
{% highlight bash %}
   `rename 'y/A-Z/a-z/' *`
{% endhighlight %}

4\. 将 abcd.jpg 重命名为 abcd\_efg.jpg：  
{% highlight bash %}
   `for var in *.jpg; do mv "$var" "${var%.jpg}_efg.jpg"; done`
{% endhighlight %}

5\. 将 abcd\_efg.jpg 重命名为 abcd\_lmn.jpg：  
{% highlight bash %}
   `for var in *.jpg; do mv "$var" "${var%_efg.jpg}_lmn.jpg"; done`
{% endhighlight %}

6\. 把文件名中所有小写字母改为大写字母：  
{% highlight bash %}
   ``for var in `ls`; do mv -f "$var" `echo "$var" |tr a-z A-Z`; done``
{% endhighlight %}

7\. 把格式 \*\_?.jpg 的文件改为 \*\_0?.jpg：  
{% highlight bash %}
   ``for var in `ls *_?.jpg`; do mv "$var" `echo "$var" |awk -F '_' '{print $1 "_0" $2}'`; done``
{% endhighlight %}

8\. 把文件名的前三个字母变为 vzomik：  
{% highlight bash %}
   ``for var in `ls`; do mv -f "$var" `echo "$var" |sed 's/^.../vzomik/'`; done``
{% endhighlight %}

9\. 把文件名的后四个字母变为 vzomik：  
{% highlight bash %}
   ``for var in `ls`; do mv -f "$var" `echo "$var" |sed 's/....$/vzomik/'`; done``
{% endhighlight %}

###用sed在文档中间指定行后增加一行

有时候我们会用脚本，来修改文档，比如在文档中增加一行或减少一行  
    echo "1";  
    echo "2";  
    echo "4";  
    echo "5";  
如上例子，想要在echo "2";后面加上一条echo "3";可以用如下命令:  
{% highlight bash %}
``sed -i '/echo \"2\";/a\echo \"3\";' test.sh``
{% endhighlight %}

之所以用分号，是因为文本中本来就有。也就是说分号不是必须的！抽象出来就是：   
``sed -i '/* /a*' filename``

###Linux shell脚本 删除文件中的一行内容

比如：在1.txt里有以下内容：

    HELLO=1  
	NI=2  
	WORLD=3  
	I Love China.  
	Love all  
	....  

如果是要删除第三行：  
{% highlight bash %}
``sed -i '3d' 1.txt``
{% endhighlight %}

如果删除以Love开头的行:  
{% highlight bash %}
``sed -i '/^Love/d' 1.txt``
{% endhighlight %}

删除包含Love的行:  
{% highlight bash %}
``sed -i '/Love/d' 1.txt``
{% endhighlight %}
