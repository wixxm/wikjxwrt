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
---------------


#### 集成插件
 |  服务 | Docker  |  网络  |
  |  :----  |  :----  |  :----  |
  | passwall | Dockerman | SpeedTest |
  | 应用过滤 | Docker | UPnP |
  | 微信推送 | Dockerd | Bandwidth Monitor |
  | MosDNS | Docker-compose | EQoS |
  | openwrtclash | | Socat |
  | lucky | | L2TP |
  | nikki | | WireGuard |
  | ddns-go | | |
  | 宽带监控 | | |
  | 网络共享 | | |
  | 终端 | | |
  | upnp | | | 

