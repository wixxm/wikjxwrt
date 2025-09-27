#!/bin/bash

# 定义颜色和状态图标
RESET="\033[0m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
RED="\033[1;31m"
CYAN="\033[1;36m"
BOLD="\033[1m"

ICON_SUCCESS="[${GREEN}✓${RESET}]"
ICON_WARN="[${YELLOW}⚠${RESET}]"
ICON_ERROR="[${RED}✗${RESET}]"
ICON_PROGRESS="[${CYAN}...${RESET}]"

# 输出函数
info() {
    echo -e "${GREEN}[INFO]${RESET} $1"
}
warn() {
    echo -e "${YELLOW}[WARN]${RESET} $1"
}
error() {
    echo -e "${RED}[ERROR]${RESET} $1"
    exit 1
}
section() {
    echo -e "\n${CYAN}========== $1 ==========${RESET}\n"
}

# 默认配置
CORES=$(nproc)
SKIP_FEEDS=0
SKIP_COMPILE=0
FEEDS_FILE="feeds.conf.default"
WIKJXWRT_ENTRY="src-git wikjxwrt https://github.com/wixxm/wikjxwrt-feeds"
PASSWALL_PACKAGES_ENTRY="src-git passwall_packages https://github.com/xiaorouji/openwrt-passwall-packages.git;main"
PASSWALL_ENTRY="src-git passwall https://github.com/xiaorouji/openwrt-passwall.git;main"
WIKJXWRT_SSH_REPO="https://github.com/wixxm/WikjxWrt-ssh"
SYSINFO_TARGET="feeds/packages/utils/bash/files/etc/profile.d/sysinfo.sh"
TURBOACC_SCRIPT="https://raw.githubusercontent.com/chenmozhijin/turboacc/luci/add_turboacc.sh"
WIKJXWRTR_CONFIG_REPO="https://github.com/wixxm/wikjxwrtr-config"
OPENWRT_REPO="https://github.com/wixxm/OpenWrt-24.10"

# 显示帮助信息
usage() {
    cat <<EOF
${BOLD}用法:${RESET} $0 [-j <线程数>] [--skip-feeds] [--skip-compile]

${BOLD}选项:${RESET}
  -j <线程数>       指定编译时使用的并发线程数，默认 $(nproc)
  --skip-feeds      跳过 feeds 更新步骤
  --skip-compile    跳过编译步骤
  -h, --help        显示帮助信息
EOF
}

# 解析参数
while [[ $# -gt 0 ]]; do
    case "$1" in
        -j)
            CORES="$2"
            shift 2
            ;;
        --skip-feeds)
            SKIP_FEEDS=1
            shift
            ;;
        --skip-compile)
            SKIP_COMPILE=1
            shift
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            error "未知参数: $1"
            ;;
    esac
done

# 环境检查
section "环境检查"
info "检查必要工具..."
for tool in git make sed curl; do
    if command -v "$tool" &>/dev/null; then
        echo -e "$ICON_SUCCESS 工具已安装: $tool"
    else
        echo -e "$ICON_ERROR 缺少工具: $tool，请安装后重试。"
        exit 1
    fi
done
echo -e "$ICON_SUCCESS 环境检查通过。"

# 记录开始时间
START_TIME=$(date +%s)

# 克隆 OpenWrt 源码
section "克隆 OpenWrt 源码"
if [[ ! -d "openwrt" ]]; then
    info "克隆 OpenWrt 源码仓库..."
    git clone "$OPENWRT_REPO" openwrt || error "克隆 OpenWrt 仓库失败！"
    echo -e "$ICON_SUCCESS OpenWrt 仓库克隆成功"
else
    echo -e "$ICON_WARN OpenWrt 仓库已存在，无需重新克隆。"
fi

# 进入 OpenWrt 文件夹
cd openwrt || error "进入 openwrt 文件夹失败！"

# 添加自定义 feeds
section "自定义 feeds 处理"
info "检查和修改 $FEEDS_FILE..."
for entry in "$WIKJXWRT_ENTRY" "$PASSWALL_PACKAGES_ENTRY" "$PASSWALL_ENTRY"; do
    if ! grep -q "^$entry" "$FEEDS_FILE"; then
        echo "$entry" >>"$FEEDS_FILE"
        echo -e "$ICON_SUCCESS 添加自定义 feeds: $entry"
    else
        echo -e "$ICON_WARN feeds 已存在: $entry，无需重复添加。"
    fi
done

# 更新 feeds
if [[ $SKIP_FEEDS -eq 0 ]]; then
    info "更新 feeds..."
    ./scripts/feeds update -a || error "feeds 更新失败！"
    echo -e "$ICON_SUCCESS feeds 更新完成。"
else
    echo -e "$ICON_WARN 跳过 feeds 更新步骤。"
fi

# 替换 coremark
section "替换 coremark"
info "删除默认 coremark 并替换为自定义版本..."
rm -rf feeds/packages/utils/coremark
git clone https://github.com/wixxm/wikjxwrt-coremark feeds/packages/utils/coremark || error "克隆 coremark 仓库失败！"
echo -e "$ICON_SUCCESS coremark 替换完成。"

# 配置 sysinfo.sh
section "配置 sysinfo.sh"
info "下载并配置 sysinfo.sh..."
git clone "$WIKJXWRT_SSH_REPO" temp_ssh_repo || error "克隆 $WIKJXWRT_SSH_REPO 仓库失败！"
mkdir -p "$(dirname $SYSINFO_TARGET)"
mv temp_ssh_repo/sysinfo.sh "$SYSINFO_TARGET" || error "移动 sysinfo.sh 失败！"
rm -rf temp_ssh_repo
echo -e "$ICON_SUCCESS sysinfo.sh 配置完成。"

# 添加 Turbo ACC
section "添加 Turbo ACC"
info "下载并执行 Turbo ACC 安装脚本..."
curl -sSL "$TURBOACC_SCRIPT" -o add_turboacc.sh && bash add_turboacc.sh || error "添加 Turbo ACC 失败！"
echo -e "$ICON_SUCCESS Turbo ACC 添加完成。"

# 替换 v2ray-geodata
section "替换 v2ray-geodata"
info "删除默认的 v2ray-geodata..."
rm -rf feeds/packages/net/v2ray-geodata || warn "删除默认 v2ray-geodata 失败，可能不存在。"
info "克隆新的 v2ray-geodata 仓库..."
git clone https://github.com/sbwml/v2ray-geodata package/v2ray-geodata || error "克隆 v2ray-geodata 仓库失败！"
echo -e "$ICON_SUCCESS v2ray-geodata 替换完成。"

# 替换 Rust
section "替换 Rust"
info "删除默认 Rust 并替换为自定义版本..."
rm -rf feeds/packages/lang/rust || warn "删除默认 Rust 失败，可能不存在。"
git clone https://github.com/wixxm/Rust feeds/packages/lang/rust || error "克隆自定义 Rust 仓库失败！"
echo -e "$ICON_SUCCESS Rust 替换完成。"

# 替换 golang
section "替换 golang"
info "删除默认 golang 并替换为自定义版本..."
rm -rf feeds/packages/lang/golang
git clone https://github.com/wixxm/WikjxWrt-golang feeds/packages/lang/golang || error "克隆 golang 仓库失败！"
echo -e "$ICON_SUCCESS golang 替换完成。"

# 安装 feeds
section "安装 feeds"
info "安装 feeds..."
./scripts/feeds install -a || error "第一次 feeds 安装失败！"
info "再次安装 feeds..."
./scripts/feeds install -a || error "第二次 feeds 安装失败！"
echo -e "$ICON_SUCCESS feeds 安装完成。"

# 注释自定义 feeds
section "注释自定义 feeds"
info "注释自定义 feeds..."
for entry in "$WIKJXWRT_ENTRY" "$PASSWALL_PACKAGES_ENTRY" "$PASSWALL_ENTRY"; do
    sed -i "s|^$entry|#$entry|" "$FEEDS_FILE" || error "注释自定义 feeds 失败: $entry"
done
echo -e "$ICON_SUCCESS 注释自定义 feeds 完成。"

# 配置 .config
section "配置 .config 文件"
info "下载并配置 .config..."
git clone "$WIKJXWRTR_CONFIG_REPO" temp_config_repo || error "克隆配置仓库失败！"
mv temp_config_repo/6.6/.config ./ || error "移动 .config 文件失败！"
rm -rf temp_config_repo
make defconfig || error "同步配置文件失败！"
echo -e "$ICON_SUCCESS .config 配置完成。"

# 下载编译所需文件
section "下载编译所需文件"
info "下载依赖文件..."
make download -j"$CORES" || error "依赖文件下载失败！"
echo -e "$ICON_SUCCESS 依赖文件下载完成。"
