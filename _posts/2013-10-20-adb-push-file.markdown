---
layout: post
title: "一段批量adb push文件脚本"
tags: [技术, 杂类]
comment: true
date: 2013-10-20 20:20
---

###adb批量push文件脚本
有一次, 需要实现一个方法: 将当前目录下的所有文件都push到设备的某个目录;

{% highlight bash %}
#!/bin/sh

adb wait-for-devices
adb remount
for so_file in /d/lib*.so
do
adb push $so_file system/lib 2>&1 > /dev/null
done

for so_file in /d/*.so
do
adb push $so_file system/lib/hw 2>&1 > /dev/null
done

adb reboot
{% endhighlight %}

###自己用perl写的一段类似功能命令:
{% highlight pl %}
#!/usr/bin/perl 
use strict;
use warnings;

my $string = "boot recovery persist cache system";
# print $_."\n" foreach @ARGV;
my $hd1 = shift @ARGV;
my $hd2 = shift @ARGV;
if($hd2)
{
	if ($hd2 eq "userdata") 
	{
		$string = $hd2 . $string;
	} else {
		print "Input error!\n";
		help();
	}
}
print "You hava choose this mode:", $hd1 eq "fastboot" ? " fastboot" : $hd1 eq "push" ? " push" : " default help";

if ( $hd1 eq "fastboot" )
{
	fastboot();
}elsif ( $hd1 eq "push"){
	mypush();
}else{
	help();	
};

sub myfile{
	my $word = shift;
	if ($word =~m/(.*)\.(.*)/gi){
		print "文件名：".$1."\t";
		print "拓展名：".$2."\n";
	}
	return $1;
}

sub fastboot{
	print "\nThis tool can fastboot device.\n";
	system "adb reboot bootloader";
	print "Don't move the device!\nwaiting...\n";
	print "\n-----------------------------------\n";

	my @files=<*.*>;
	foreach my $file ( @files ){
		my $myfn = myfile("$file");
		if ($string =~ /$myfn/){
			print "Now fastboot the $file.\n";
			system "fastboot flash ".$myfn." ".$file;
		} else {
			print "No ".$myfn.".img would be fastboot!\n";
		}
		print "\n-----------------------------------\n";
	}
	system "fastboot reboot";
	exit;
}	

sub mypush{
	print "\n-----------------------------------\n";
	print "\nThis tool can push something to somewhere. \nAnd need to input right path, such as \"data/\", \"sdcard1/\"...\n";
	print "Please input the target path:";
	my $path = <STDIN>;
	chomp $path;
#	$_ = "I love you";
#	if(/$reg/){
#		print '$_ contains what you input';
#	}
	print "\nThe path is ".$path."\n";
	my @files = <*.*>;
	foreach my $file ( @files ){
	#	my $myfn = myfile("$file");
		system "adb remount";
		system "adb push ".$file." ".$path;	
	}
	system "adb reboot";	
	print "\n-----------------------------------\n";
	exit;
}
sub help{
	print "\n-----------------------------------\n";
	print "\nPlease input one parameter follow the pl script, \nsuch as \"fastboot\",\"push\", ...\n";
	print "\n-----------------------------------\n";
	exit;
}

{% endhighlight %}

