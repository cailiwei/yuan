---
layout: post
title: "Markdown语法学习"
tags: [markdown, 技术]
comment: true
date: 2013-08-21 23:28
---

##Markdown简介
Markdown是一种轻量级的标记语言，由John Gruber和Aaron Swartz创建。它的灵感来自于带标记的电子邮件文本。
Markdown允许HTML语法，所以在markdown文件里面直接使用html表示也是可以的。

##Markdown的优点
Markdown能让文档更容易读、写和修改。HTML是一种发布式的格式，Markdown是一种书写的格式。Markdown只涵盖纯文本的范围。在博客中使用Markdown可以更多的关注于文章的内容，少量的地方来控制排版(Markdown的排版符号)。

##[Markdown编辑工具](http://www.appinn.com/markdown-tools/)  
###工具：  
1. Windows: MarkdownPad，需要安装.Net 4；Meditor
1. Linux: ReText
1. Mac: Mou或者Sublime Text 2
1. 网页版: Dillinger
1. Chrome扩展: Made,支持左右分屏，即时预览。
1. Vim插件: Vim+vimviki

##区块元素  
###段落和换行  
一个Markdown段落由一个或多个连续的文本行组成。它的前后要有一行以上的空行。这里的空行是
指不包含除了制表符和空格外的字符。 如果想强制换行，那么可以在插入的地方连续输入2个以上的
空格即可。    
###标题  
Markdown支持两种标题语法：类Setext和类atx形式。
前者使用`=`来表示最高阶标题，`-`表示第二阶标题。注意这些符号是在标题的下方，个数是任意的（大于一个）
例如：
    This is h1.  
    ===========  
    This is h2.  
    -----------  
  
####显示结果：
>This is h1.
>==========
>This is h2.
>----------

类atx形式则是平常见到比较多的使用1到6个`#`来不同的标题阶数。数量越多，字体越小。
    # This is h1
    ## This is h2

####显示结果：
># This is h1.
>## This is h2.
  
  
###区块引用
Markdown标记区块引用是使用类似email中用`>`的引用方式。使用区块引用只需要在行首使用`>`即可。如果只是在每个段落的第一行加上`>`也是可以的。

例如:
	>Do you know that you are so special. but in some way,     I think you are a little too special.

    > What do you think?

这样都是可以的。
####显示结果：
>Do you know that you are so special. but in some way,     I think you are a little too special.

> What do you think?

如果想要在引用中继续嵌套使用也是可以的，需要做的就是，继续使用`>`就可以了。
另外，引用中的markdown语法是可以正常使用的。

例如：
	> ## this is a title.
    > > this is a nested markdown sentence.
    > 1. item1
    > 1. item2

####显示结果：
> ## this is a title.
> > this is a nested markdown sentence.

> 1. item1
> 1. item2

###列表
在上面的例子中，我们用到了列表。在markdown中，可以使用`*`、`+`、`-`来作为标记。另外，也可以使用`数字`+`.`的方式来作列表，这里的数字不一定要按照顺序来，只要是符合上述规则即可，markdown的最终显示会从1开始逐个显示。

例如:
	>1.I Love China.
    >3. I Love Ruby.
    >1. Item1.
    >3. Item2.
    >10. Item3.
####显示效果:
1. I Love China.
3. I Love Ruby.
1. Item1.
3. Item2.
10. Item3.

	>这里需要注意下：如果在显示列表的时候，使用了数字+.和上面3种的混合形式。那么最终的显示效果，以第一行的列表为准。数字+.显示的为数字列表，而前三种显示的为实心点的列表形式。

如果想要在列表中使用引用，那么`>`需要缩进。如果要放入代码区块的话，需要缩进2次，即8个空格或2个TAB。
如果在段落中含有`2012. what a fatancy year.`,在为了避免被“翻译”成列表，那么需要使用`\`转义数字后面的那个`.`。

###代码区块
作为程序猿经常要使用代码贴在文章中，而这些代码，我们都要保持它的格式不被修改。在Markdown中，markdown会将代码块使用`<pre>`和`<code>`标签将之包起来。
那么我们如何使用代码块呢?4个空格或者一个TAB。嗯，就是这样简单。
例如：
	def	say(gf)
       puts "Hello, #{gf}."
    end

####显示效果:如上。
代码块会一直持续到没有缩进的行或者文件结束。

###分割线
什么？想使用分割线?嗯，这个也很简单：使用3个以上的星号、减号、底线就可以。不过这里的要求是：行内只能有以上3中，但不能包含除空格外的其它字符。

例如：
	* * *
    ----
    -	-	-
    ____      __________        ___________

####显示效果：
* * *
----
-	-	-
____      __________        ___________

##区段元素
###链接
Markdown支持两种形式的链接语法：行内式和参考式。它们的共同点是：都是使用`[]`来标记的。

行内式：在方括号后面使用圆括号，并在圆括号中写上链接地址和标题即可(可选)，title字段需要使用双引号包起来。

例如:
	This is a [Link](http://snails.github.com,"My Blog") to my site.

####显示结果：
This is a [Link](http://snails.github.com,"My Blog") to my site.

这里的链接地址不局限于http这种链接，也可以使用相对链接地址。

参考式： 这种方式指的是在第一个方括号后面要继续使用一个方括号，在后者中要输入链接的目标。这里的方括号不用跟得太”亲密“。XD
	This is the link to the [Top] [top] Link.
   
我在文章上部定义了:
	[top]: # "Top of the post."
####显示效果：
This is the link to the [Top][top] Link.

链接的网址也可以使用方括号`<>`包起来，定义ID的地方，后面在跟一个冒号后，需要加一个空格或制表符，Title可选，使用逗号隔开。

链接的标识标签可以使用字母、数字、空白和标点符号，不区分大小写。

隐式链接能够让我们省略制定的标记。在原来的方括号后面，添加一个空的方括号，默认会跳转到http:标识.com的链接上去。

例如：
	[Google][]
    [Goole]: http://google.com

结果:

[Google][]
[Google]: http://google.com


链接的定义位置任意。下面我们就将本文的参考代码写在下面：
	本文参考的链接包括[wowubuntu][1]和[appinn][2]
	
	[1]: http://wowubuntu.com	"WowUbuntu.com"
	[2]: http://www.appinn.com	"Appinn.com"

####显示效果:
本文参考的链接包括[wowubuntu][1]和[appinn][2]
	
[1]: http://wowubuntu.com/markdown	"WowUbuntu.com"
[2]: http://www.appinn.com/markdown-tools	"Appinn.com"

###强调
我们可以使用`*`和`_`来强调某个词，单个的字符使用的标签为`<em>`,使用2个则为`<strong>`。不过在使用的时候，这两个标记在使用的时候不要都有空白，否则它就是普通”群众“了。

###代码
行内的一小段代码，可以使用反引号（在TAB上面的那位）来将其包起来

	``There is a back door here`.``

``There is a back door here`.``

##图片
最后我们说下图片。图片在一个文章中必不可少，有助于帮助读者更好的理解作者的意图。那么在Markdown中如何使用图片链接呢？
	![Alt Text](path of the picture "Option title")

不过Markdown没有办法来指定图片的宽高，所以如果图片太BIG，请选择``<img>``标签，因为Markdown是兼容这些标签滴。

下面我们贴一个指向ruby china社区Logo的图片：
	![ruby-china logo](http://ruby-china.org/assets/big_logo.png  "logo")

####显示结果：
![ruby-china logo](http://ruby-china.org/assets/big_logo.png  "logo")

###Others
另外如果使用尖括号将网址、邮箱放在里面，你会发现，Markdown 已经为了做了很多事。
	<http://cailiwei.github.com>

	Contact Me: <cailiwei516@gmail.com>

####显示结果:
<http://cailiwei.github.com>

Contact Me: <cailiwei516@gmail.com>

#好了，到此结束。收工，睡觉。Good Night.


