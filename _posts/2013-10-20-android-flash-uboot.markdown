---
layout: post
title: "Android的Uboot(lk)的烧写命令"
tags: [技术, 杂类]
comment: true
date: 2013-10-20 19:30
---

##写在前面的话
在我起初调试LCD驱动时: 在每次修改完驱动后, 都需要重新烧写相应的分区, 也就是说我修改了kernel的代码的话就要用fastboot烧写boot.img, 但是如果修改了uboot(lk)中的驱动呢? 当然也要烧写对应的分区; 可是在高通release过来的代码中, 却没有对lk的分区提供fastboot烧写方法(当然有的公司已经做好了这个补丁), 在没有打补丁的情况下, 我们烧写该分区时, 就不得不用专门烧写工具, 将所有的分区烧录一边, 这样不仅费时, 而且还存在找不到端口而需要重启电脑的风险.

##用dd命令实现对uboot(lk)单独分区的烧写
用linux的dd命令在adb shell的环境下对aboot的烧写:
{% highlight bash %}
adb shell mkdir /dev/update_package

@adb push  emmc_appsboothd.mbn /dev/update_package/ 
@adb shell "dd if=/dev/update_package/emmc_appsboothd.mbn   of=/dev/block/mmcblk0 bs=512 seek=167936"
@adb shell rm /dev/update_package/emmc_appsboothd.mbn
@echo "emmc_appsboothd.mbn OK"

@adb push  emmc_appsboot.mbn /dev/update_package/ 
@adb shell "dd if=/dev/update_package/emmc_appsboot.mbn   of=/dev/block/mmcblk0 bs=512 seek=167937"
@adb shell rm /dev/update_package/emmc_appsboot.mbn
@echo "emmc_appsboot.mbn OK"

adb reboot 
pause
{% endhighlight %}

##触类旁通
也可以采用同样的方法完成对其他任何分区的烧写, 前提是需要知道分区的信息: seek = ?
