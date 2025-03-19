# Wikjxwrt 云编译固件

### 本固件源码基于openwrt-24.10修改，云编译项目。
   本仓库为Wikjxwrt的github云编译库，与一键编译脚本所产出固件一致。
   
   官方源码仓库 - [OpenWrt-24.10](https://github.com/openwrt/openwrt/tree/openwrt-24.10)
   
   本固件源码仓库 - [OpenWrt-24.10](https://github.com/wixxm/OpenWrt-24.10)

#### 固件下载地址
   - [Github](https://github.com/wixxm/wikjxwrt/releases)
  
   - [Google](https://drive.google.com/drive/folders/1ORaVqeKyvWItATbq0NCFNysLSOhb6Q2N?usp=sharing)
### 固件说明
#### 支持硬件 
- [x] X86_64

#### 登录信息
```
地址：192.168.88.1（修改代码：vi /etc/config/network）
用户：root
密码：空
```
---------------

#### 附加功能
   优化SSH信息显示
|  服务 | 系统  |  网络  |
   | 系统负载:   0.00 0.06 0.03 | 运行时间:   0 days   | 
  | 内存已用:   7% of 3936MB  |  交换内存:   0% of 0MB   | 
  | CoreMark:   58293.635974 | 存储使用:   39% of 990.7M |
  |IP地址:     192.168.88.1 | CPU 型号:  | 
  
添加了首次更新安装固件之后的第二天自动进行coremark测试并且显示到SSH登录信息
   
   
   
   
#### 集成插件
 |  服务 | 系统  |  网络  |
  |  :----  |  :----  |  :----  |
  | passwall | netdata | iperf3 |
  | 应用过滤 | CPU Load | UPnP |
  | 微信推送 | Argon config | urbo ACC 网络加速设置 |
  | MosDNS | DiskMan | BBR |
  | openwrtclash | statistics | nlbwmon |
  | lucky | | MultiWAN 管理器 |
  | nikki | | |
  | ddns-go | | |
  | 宽带监控 | | |
  | 网络共享 | | |
  | 终端 | | | 
  | MWAN3 分流助手 | | | 

### 本地编译
   如需本地编译固件可直接使用本固件一键编译脚本即可编译出完全相同固件
   - [WikjxWrt-Auto](https://github.com/wixxm/wikjxwrt-auto)
