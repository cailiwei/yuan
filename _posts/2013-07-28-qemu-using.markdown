---
layout: post
tags: [技术, 杂类]
comment: true
title: "QEMU的网络使用小结"
date: 2013-07-28 17:45
---

### 一、基本概念  
为了使虚拟机能够与外界通信，Qemu需要为虚拟机提供网络设备。Qemu支持的常用网卡包括NE2000、rtl8139、pcnet32等。命令行上用`-net nic`为虚拟机创建虚拟机网卡。例如，qemu的命令行选项`-net nic,model=pcnet`表示为虚拟机添加一块pcnet型的以太网卡。如果省略model参数则qemu会默认选择一种网卡类型，目前采用的是Intel 82540EM（手册里说明的是e1000），可以在虚拟机启动后执行lspci命令查看。有了虚拟网络设备，下面的问题是如何用这些设备来联网。

首先，虚拟机的网络设备连接在qemu虚拟的VLAN中。每个qemu的运行实例是宿主机中的一个进程，而每个这样的进程中可以虚拟一些VLAN，虚拟机网络设备接入这些VLAN中。当某个VLAN上连接的网络设备发送数据帧，与它在同一个VLAN中的其它网路设备都能接收到数据帧。上面的例子中对虚拟机的pcnet网卡没有指定其连接的VLAN号，那么qemu默认会将该网卡连入vlan0。下面这个例子更具一般性：   
``
-net nic,model=pcnet -net nic,model=rtl8139,vlan=1, -net nic,model=ne2k_pci,vlan=1
``   
该命令为虚拟机创建了三块网卡，其中第一块网卡类型是pcnet，连入vlan0；第二块网卡类型是 rtl8139，第三块网卡类型是ne2k\_pci，这两块都连入vlan1，所以第二块网卡与第三块网卡可以互相通信，但它们与第一块网卡不能直接通信。接下来，各个VLAN再通过qemu提供的4种通信方式与外界联网:

* User mode stack: 这种方式在qemu进程中实现一个协议栈，负责在虚拟机VLAN和外部网络之间转发数据。
可以将该协议栈视为虚拟机与外部网络之间的一个NAT服务器，外部网络不能主动与虚拟机通信。虚拟机VLAN中的各个网络接口只能置于10.0.2.0子网中，所以这种方式只能与外部网络进行有限的通信。
此外，可以用`-redir`选项为宿主机和虚拟机的两个TCP或UDP端口建立映射，实现宿主机和虚拟机在特殊要求下的通信（例如X-server或ssh）。
User mode stack通信方式由`-net user`选项启用，如果不显式指定通信方式，则这种方式是qemu默认的通信方式。

* socket：这种方式又分为TCP和UDP两种类型。  
（1）TCP：为一个VLAN创建一个套接字，让该套接字在指定的TCP端口上监听，而其他VLAN连接到该套接字上，从而将多个VLAN连接起来。缺点在于如果监听套接字所在qemu进程崩溃，整个连接就无法工作。监听套接字所在VLAN通过`-net socket,listen`选项启用，其他VLAN通过`-net socket,connect`选项启用。  
（2）UDP：所有VLAN连接到一个多播套接字上，从而使多个VLAN通过一个总线通信。所有VLAN都通过`-net socket,mcast`选项启用。

* TAP：这种方式首先需要在宿主机中创建并配置一个TAP设备，qemu进程将该TAP设备连接到虚拟机VLAN中。
其次，为了实现虚拟机与外部网络的通信，在宿主机中通常还要创建并配置一个网桥，并将宿主机的网络接口（通常是eth0）作为该网桥的一个接口。
最后，只要将TAP设备作为网桥的另一个接口，虚拟机VLAN通过TAP设备就可以与外部网络完全通信了。
这是因为，宿主机的eth0接口作为网桥的接口，与外部网络连接；TAP设备作为网桥的另一个接口，与虚拟机VLAN连接，这样两个网络就连通了。
此时，网桥在这两个网络之间转发数据帧。
这里有两个问题需要注意：  
（1）网桥的转发工作需要得到内核的支持，所以在编译宿主机内核时需要选择与桥接相关的配置选项。  
（2）当宿主机eth0接口作为网桥接口时，不能为其配置IP地址，而要位将IP地址配置给网桥。  
TAP方式由`-net tap`选项启用。

* VDE：这种方式首先要启动一个VDE进程，该进程打开一个TAP设备，然后各个虚拟机VLAN与VDE进程连接，这样各个VLAN就可以通过TAP设备连接起来。
VDE进程通过执行`vde_switch`命令启动，各个VLAN所在qemu进程通过执行`veqe`命令启动，这些VLAN就可以与VDE进程连接了。  

以上四种通信方式中，socket方式和VDE方式用于虚拟机VLAN之间的连接，而user mode stack方式与外部网路的通信比较有限，所以下面主要讨论TAP方式的配置。
在没有做配置之前，首先需要对TAP设备有所认识。
TUN/TAP是内核支持的网络虚拟设备，这种网络设备完全由的软件实现。
与网络硬件设备不同，TUN/TAP负责在内核协议栈与用户进程之间传送协议数据单元。
TUN与TAP的区别在于，TUN工作在网络层，而TAP则工作在数据链路层。
具体在运行TCP/IP的以太网中，TUN与应用程序交换IP包，而TAP与应用程序交换以太帧。
所以TUN通常涉及路由，而TAP则常用于网络桥接。
TUN/TAP的典型应用包括：OpenVPN、OpenSSH 以及虚拟机网络。

### 二、在Ubuntu系统中配置qemu网络  
1\. 内核支持需要对TUN/TAP设备和虚拟网桥提供支持:
    (1)Device Drivers
        --> Network device support
	        --> Universal TUN/TAP device driver support
    (2)Networking support
        --> Networking options
	        --> 802.1d Ethernet Bridging
2\. 安装两个配置网络所需软件包:
{% highlight bash %}
apt-get install bridge-utils        # 虚拟网桥工具
apt-get install uml-utilities       # UML（User-mode linux）工具
{% endhighlight %}
3\. 配置虚拟网桥的操作（假设系统启动后eth0已经启动，并且从DHCP获得IP地址）。
{% highlight bash %}
ifconfig eth0 down                  # 先关闭eth0接口
brctl addbr br0                     # 增加一个虚拟网桥br0
brctl addif br0 eth0                # 在br0中添加一个接口eth0
brctl stp br0 off                   # 只有一个网桥，所以关闭生成树协议
brctl setfd br0 1                   # 设置br0的转发延迟
brctl sethello br0 1                # 设置br0的hello时间
ifconfig br0 0.0.0.0 promisc up     # 打开br0接口
ifconfig eth0 0.0.0.0 promisc up    # 打开eth0接口
dhclient br0                        # 从dhcp服务器获得br0的IP地址
brctl show br0                      # 查看虚拟网桥列表
brctl showstp br0                   # 查看br0的各接口信息
{% endhighlight %}
在没有dhcp服务器的网络中也可以用ifconfig命令为br0接口配置一个静态IP地址：
{% highlight bash %}
ifconfig br0 192.168.0.22 netmask 255.255.255.0
route add -net 0.0.0.0 netmask 0.0.0.0 gw 192.168.0.254
{% endhighlight %}
4\. 配置TAP设备的操作：
{% highlight bash %}
tunctl -t tap0 -u root              # 创建一个tap0接口，只允许root用户访问
brctl addif br0 tap0                # 在虚拟网桥中增加一个tap0接口
ifconfig tap0 0.0.0.0 promisc up    # 打开tap0接口
brctl showstp br0                   # 显示br0的各个接口
{% endhighlight %}
5\. 假设内核的顶层目录在/usr/src/linux，且内核已经编译完毕。启动qemu的操作：
{% highlight bash %}
cd /usr/src/linux
qemu -kernel arch/x86/boot/bzImage -net nic -net tap,ifname=tap0,script=no,downscript=no 
{% endhighlight %}
如果省略script和downscript参数，qemu在启动时会以第一个不存在的tap接口名（通常是tap0）为参数去调用/etc/qemu-ifup脚本，而在退出时调用/etc/qemu-ifdown脚本。这两个脚本需要用户自行编写，其主要作用通常是：在启动时创建和打开指定的TAP接口，并将该接口添加到虚拟网桥中；退出时将该接口从虚拟网桥中移除，然后关闭该接口。由于配置TAP设备的操作前面已经做过了，所以启动qemu时显式地告诉qemu不要执行这两个脚本。这里需要严重注意：-net tap的各参数之间不要有空格！为了这个问题花了半个小时 。  
6\. 为了在系统启动时能够自动配置虚拟网桥和TAP设备，编写/etc/network/interfaces文件的内容如下：
{% highlight bash %}
auto lo
iface lo inet loopback

# The eth0 network interface(s)
# auto eth0
# iface eth0 inet dhcp

# The bridge network interface(s)
auto br0
iface br0 inet dhcp
# iface br0 inet static
# address 192.168.0.1
# netmask 255.255.255.0
# gateway 192.168.0.254
bridge_ports eth0
bridge_fd 9
bridge_hello 2
bridge_maxage 12
bridge_stp off

# The tap0 network interface(s)
auto tap0
iface tap0 inet manual
# iface tap0 inet static
# address 192.168.0.2
# netmask 255.255.255.0
# gateway 192.168.0.254
pre-up tunctl -t tap0 -u root
pre-up ifconfig tap0 0.0.0.0 promisc up
post-up brctl addif br0 tap0
{% endhighlight %}
注意：此时应该将配置文件中的eth0关闭（相应的文本行注释掉）。
