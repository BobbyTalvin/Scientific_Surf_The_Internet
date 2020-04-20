# 科学上网课

在符合中华人民共和国法律的前提下，学会科学、正确、合理的上网，是作为一个合法的中国公民必须具备的基本素养！这本小册子的目的是为了让我们在某些弱网环境下，更方便，更快捷的获取到网络上的一些资源，但前提是一定要保证你获取的资源是合法的！

## 前期准备
想要科学、正确、合理且合法的上网，前期的准备工作少不了。就算你真的嫌麻烦，那你也需要加入某个相对稳定的 [vpn](https://zh.wikipedia.org/wiki/%E8%99%9B%E6%93%AC%E7%A7%81%E4%BA%BA%E7%B6%B2%E8%B7%AF) 节点。不过，我个人更看重的是举一反三的能力，**授人渔** 才是这本小册子的真实目的。

接下来，我们讨论的是如何自己动手搭建一套属于自己的 [vps](https://zh.wikipedia.org/wiki/%E8%99%9A%E6%8B%9F%E4%B8%93%E7%94%A8%E6%9C%8D%E5%8A%A1%E5%99%A8)，别看它和 *vpn* 只差一个字母，但技术含量和难以程度都如同云泥！(我身边就有不少程序猿依然只会使用别人提供的vpn，想想都替他们感到那啥……)

想要有一个自己的 *vps*，你至少需要以下几个条件👇：
1. 一台属于自己的 **云服务器**，别管配置，哪怕 *0.5G内存 + 1核CPU* 也行；

2. 一个能在你的 *云服务器* 上跑起来的 **服务**；(关于服务器和服务的区别，后面有说明)

3. 一个属于自己的 **域名**(可选，但最好有)，可以去 [腾讯云](https://cloud.tencent.com/act/domainsales) 或者 [万网](https://www.hichina.com/)(阿里云旗下) 购买；

4. 最重要的一点：相信自己一定能行的**信心**。

## 云服务器选择
推荐几个比较常见的云服务供应商，以作参考。

针对低端用户，笔者尝试过国内的阿里云、百度云、腾讯云、新浪云，对于服务稳定性而言，比较推荐[腾讯云](https://cloud.tencent.com)，如果考虑价格等其他因素，其实各大厂商对于新用户都有优惠政策，可根据自己的实际情况选择。

对于境外的运营商，考虑到支付的便捷性和优惠力度，更为推荐[vultr](https://www.vultr.com/)；相关优惠，可以在搜索引擎中输入 `vultr新用户优惠` 关键字进行搜索。

### 国内的云服务器供应商
1. [腾讯云](https://cloud.tencent.com)

2. [阿里云](https://cn.aliyun.com)

3. [百度云](https://cloud.baidu.com/)

4. [新浪云](https://www.sinacloud.com/)

### 国外的云服务器供应商
1. [vultr](https://www.vultr.com/)

2. [搬瓦工](https://bandwagonhost.com/)

3. [AWS](https://aws.amazon.com/cn/)

4. [Azure](https://azure.microsoft.com/)


### 正/反 向代理服务器
*代理服务器*，就是我们 **合法、科学** 上网的核心 —— 即使用你在👆上面这些云服务器供应商购买的云服务器，然后将你的资源获取请求事先发送到这些云服务器，而后这些 *代理服务器* 会代理你要请求的资源，最终将这些请求到的资源返回给你。

关于 *代理服务器* 的详细概念介绍，详见[维基百科](https://zh.wikipedia.org/wiki/%E4%BB%A3%E7%90%86%E6%9C%8D%E5%8A%A1%E5%99%A8)

## 服务 vs. 服务器
千万别天真的以为你只要购买了 *云服务器* 就能代理你的资源请求了！想想看你的电脑想要运行起来，光靠电脑本身的 *CPU*、*GPU*、*内存*……显然是不够的，还要安装最基本的操作系统才行。

因此，**云服务器** 你可以把它简单理解成 *硬件*，而在这个服务器上，我们还需要安装相应的 **服务**，才能让整个系统合理的运行起来。

### 服务
大多数的编程语言，配合相应的编译和解释器，都能在你的电脑上直接运行起来。但程序一旦运行完毕，这世界就好像什么都没发生一样(当然发生了点什么)，计算机依然安静的等待你继续下一个操作。

突然有一天，你想让你的计算机能够持续运行，或者说保持某种待命的状态，一旦有任何你的风吹草动，它都会再次执行你之前定义好的任务 —— 我们简单的将这样的特性理解为 **服务** —— 就好比定义好一个 *问候* 的任务给计算机，一旦有人访问它，它立马返回你定义好的问候语句，就比如大部分的编程课的第一章都是教你如何写出一个 `hello, world!`。

我们想要 **合法、科学** 的上网也离不开服务，而执行这些服务的基础，早已有很多很多开源的项目(感谢开源)。常见的服务基础设置有 *apache*、*tomcat*、*nginx*、*caddy*……一旦有了这些基础的服务设置，然后再配合你编写的脚本程序，就能对外提供服务了。

**Tips**: 编写服务的脚本语言有很多，比如 *PHP*、*Java*、*Javascript*、*go*、*python*……

我们在这里重点关注以下几个服务的安装和配置：
1. [nginx - 官网](https://nginx.org/en/docs/)

2. [caddy - 官网](https://caddyserver.com/v1/docs)

3. [v2ray - 官网](https://www.v2ray.com/)

4. [ssr - github](https://github.com/shadowsocksrr/shadowsocksr)

### 亲尝有效的服务配置
1. **ssr + caddy + tls**：ssr 做反向代理，转发普通请求到 caddy 服务(自带tls)，对于其他请求，则进行正向代理；

2. **v2ray + nginx + tls**：nginx 做反向代理，将自定义的某个路由转发到 v2ray 服务进行正向代理，需要手动配置tls。

### 服务器配置导航
1. ssr + caddy + tls 模式
    * [ssr 基本配置](/ssr.md) —— (兼具正、反向代理服务，搭配caddy)

    * [caddy 基本配置](/caddy.md) —— (web服务，搭配ssr)

2. v2ray + nginx + tls 模式
    * [v2ray 基本配置](/v2ray.md) —— (正向代理服务，搭配nginx)

    * [nginx 基本配置](/nginx.md) —— (反向代理服务，同时也是web服务，搭配v2ray)

### 防火墙之安全组规则
如果你购买的是国内的云服务，一般来说都有安全限制，此时你需要手动设置你的 [安全组规则](https://baike.baidu.com/item/%E5%AE%89%E5%85%A8%E7%BB%84)，开放对应端口(包括TCP和UDP协议)出入站的权限，而后将规则绑定到云服务的实例上。

- [腾讯云安全组规则](https://cloud.tencent.com/document/product/213/12452)

- [阿里云安全组规则](https://help.aliyun.com/document_detail/25471.html)

## 路由器篇
服务都搭建好了，但是每台设备都需要安装相应的客户端才能达到实际想要的效果，这很不爽。解决的办法也很简单 —— 用路由器作为入口终端，代理所有的请求，在这个局域网下，所有的设备自然而然就达到了预期的效果。

市面上的路由器很多很杂，中高端里较为推荐 **华硕** 和 **网件**，质量稳定，功能强大(因为梅林)。稍次一些就比较多了，比如 Tenda、TPLink、水星、小米路由器、360路由器……，虽便宜，也能胜任工作。

笔者自家使用的是两台ASUS(华硕)组成的Aimesh，一台是AC68U，一台是AC66U-B1，价格相差无几，稳定性、功能、信号强度都没太多区别，关键是它们都采用了 博通方案，刷梅林固件几乎是傻瓜式，相关的教程也很多，就不再赘述。

贴两个地址：

[梅林固件下载地址](http://firmware.koolshare.cn/)

[KX上网工具地址](https://github.com/hq450/fancyss)

### openwrt刷固(敬请期待)

## License

Copyright (c) 2019 [Bobby.li](https://github.com/BobbyLH)

Released under the MIT License