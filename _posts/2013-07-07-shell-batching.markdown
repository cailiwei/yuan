---
layout: post
tags: [技术, linux, shell]
comment: true
title: 一句话命令批量处理文本
---

###Linux Shell 批量重命名的方法

1\. 删除所有的 .bak 后缀:  
   `rename 's/\.bak$//' *.bak`

2\. 把 .markdowm 文件后缀修改为 .markdown：  
   `rename 's/\.markdowm$/\.markdown/' *.markdowm`

3\. 把所有文件的文件名改为小写：  
   `rename 'y/A-Z/a-z/' *`

4\. 将 abcd.jpg 重命名为 abcd\_efg.jpg：  
   `for var in *.jpg; do mv "$var" "${var%.jpg}_efg.jpg"; done`

5\. 将 abcd\_efg.jpg 重命名为 abcd\_lmn.jpg：  
   `for var in *.jpg; do mv "$var" "${var%_efg.jpg}_lmn.jpg"; done`

6\. 把文件名中所有小写字母改为大写字母：  
   ``for var in `ls`; do mv -f "$var" `echo "$var" |tr a-z A-Z`; done``

7\. 把格式 \*\_?.jpg 的文件改为 \*\_0?.jpg：  
   ``for var in `ls *_?.jpg`; do mv "$var" `echo "$var" |awk -F '_' '{print $1 "_0" $2}'`; done``

8\. 把文件名的前三个字母变为 vzomik：  
   ``for var in `ls`; do mv -f "$var" `echo "$var" |sed 's/^.../vzomik/'`; done``

9\. 把文件名的后四个字母变为 vzomik：  
   ``for var in `ls`; do mv -f "$var" `echo "$var" |sed 's/....$/vzomik/'`; done``

###用sed在文档中间指定行后增加一行

有时候我们会用脚本，来修改文档，比如在文档中增加一行或减少一行  
    echo "1";  
    echo "2";  
    echo "4";  
    echo "5";  
如上例子，想要在echo "2";后面加上一条echo "3";可以用如下命令:  
``sed -i '/echo \"2\";/a\echo \"3\";' test.sh``

之所以用分号，是因为文本中本来就有。也就是说分号不是必须的！抽象出来就是：   
``sed -i '/* /a*' filename``

###Linux shell脚本 删除文件中的一行内容

比如：在1.txt里有以下内容：
``sh
HELLO=1  
NI=2  
WORLD=3  
I Love China.  
Love all  
....  
``
如果是要删除第三行：  
``sed -i '3d' 1.txt``

如果删除以Love开头的行:  
``sed -i '/^Love/d' 1.txt``

删除包含Love的行:  
``sed -i '/Love/d' 1.txt``
