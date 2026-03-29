#!/bin/bash

clear
echo "=========================================================="
echo "      欢迎使用 kzhx 的专属 VPS 一键 DD 重装脚本"
echo "=========================================================="
echo ""

# 1. 交互选择操作系统
echo "▶ 请选择您要重装的操作系统："
echo "--- 🌟 Debian 系列 ---"
echo "  [1] Debian (最新稳定版，默认首选)"
echo "  [2] Debian 12"
echo "  [3] Debian 11"
echo "--- 🌟 Ubuntu 系列 ---"
echo "  [4] Ubuntu (最新 LTS 版)"
echo "  [5] Ubuntu 24.04"
echo "  [6] Ubuntu 22.04"
echo "--- 🐧 RHEL / 企业级系统 ---"
echo "  [7] AlmaLinux 9 (红帽系首选)"
echo "  [8] Rocky Linux 9"
echo "  [9] CentOS 7 (仅限兼容老旧面板，已停更)"
echo "--- 🪶 轻量与特种系统 ---"
echo "  [10] Alpine Linux (最新稳定版)"
echo "  [11] Alpine Linux 3.19 (指定老版本)"
echo "  [12] Kali Linux (渗透测试/网安专用)"
echo "--- 🪟 Windows 系统 (提醒: 需较高硬件配置) ---"
echo "  [13] Windows 10 (企业版 LTSC)"
echo "  [14] Windows Server 2022"
echo ""
read -p "👉 请输入对应数字 (直接回车默认选 1): " OS_CHOICE

# 根据选择匹配底层脚本的系统参数
case "$OS_CHOICE" in
    2) OS_FLAG="-debian 12" ; OS_NAME="Debian 12" ;;
    3) OS_FLAG="-debian 11" ; OS_NAME="Debian 11" ;;
    4) OS_FLAG="-ubuntu" ; OS_NAME="Ubuntu (最新 LTS 版)" ;;
    5) OS_FLAG="-ubuntu 24.04" ; OS_NAME="Ubuntu 24.04" ;;
    6) OS_FLAG="-ubuntu 22.04" ; OS_NAME="Ubuntu 22.04" ;;
    7) OS_FLAG="-almalinux 9" ; OS_NAME="AlmaLinux 9" ;;
    8) OS_FLAG="-rocky 9" ; OS_NAME="Rocky Linux 9" ;;
    9) OS_FLAG="-centos 7" ; OS_NAME="CentOS 7" ;;
    10) OS_FLAG="-alpine" ; OS_NAME="Alpine Linux (最新版)" ;;
    11) OS_FLAG="-alpine 3.19" ; OS_NAME="Alpine Linux 3.19" ;;
    12) OS_FLAG="-kali" ; OS_NAME="Kali Linux" ;;
    13) OS_FLAG="-windows 10" ; OS_NAME="Windows 10" ;;
    14) OS_FLAG="-windows 2022" ; OS_NAME="Windows Server 2022" ;;
    1|"") OS_FLAG="-debian" ; OS_NAME="Debian (最新稳定版)" ;;
    *) echo "⚠️ 输入无效，将默认使用 Debian 最新版" ; OS_FLAG="-debian" ; OS_NAME="Debian (最新稳定版)" ;;
esac
echo "✅ 已选择系统: $OS_NAME"
echo ""

# 2. 交互输入密码 (Windows 会默认使用 Administrator 账户)
read -p "👉 请输入您要设置的密码 (务必牢记): " ROOT_PWD
if [ -z "$ROOT_PWD" ]; then
    echo "❌ 错误：密码不能为空！已退出。"
    exit 1
fi

# 3. 交互输入端口 (Windows 远程桌面默认 3389，不适用此端口设置)
if [[ "$OS_CHOICE" == "13" || "$OS_CHOICE" == "14" ]]; then
    SSH_PORT=3389
    echo "💡 检测到选择 Windows，将使用默认 RDP 端口: 3389 (请确保安全组放行)"
else
    read -p "👉 请输入 SSH 端口 (直接回车则默认使用 22): " SSH_PORT
    if [ -z "$SSH_PORT" ]; then
        SSH_PORT=22
        echo "💡 未输入，将使用默认端口: 22"
    fi
fi

# 4. 最终信息确认
echo ""
echo "=========================================================="
echo "请确认您的重装配置："
echo "▶ 操作系统: $OS_NAME"
echo "▶ 时区设置: Asia/Shanghai (北京时间)"
if [[ "$OS_CHOICE" == "13" || "$OS_CHOICE" == "14" ]]; then
    echo "▶ 远程端口: $SSH_PORT (Windows RDP)"
    echo "▶ 登录账号: Administrator"
else
    echo "▶ SSH 端口: $SSH_PORT"
    echo "▶ 登录账号: root"
fi
echo "▶ 登录密码: $ROOT_PWD"
echo "=========================================================="
echo "⚠️ 警告：重装将清空硬盘所有数据，且不可逆！"
if [ "$SSH_PORT" != "22" ] && [ "$SSH_PORT" != "3389" ]; then
    echo "⚠️ 提醒：请确保已在云面板安全组中放行了 $SSH_PORT 端口！"
fi
read -p "确认无误并开始执行重装吗？(y/n): " CONFIRM

if [[ "$CONFIRM" != "y" && "$CONFIRM" != "Y" ]]; then
    echo "🛑 已取消重装操作。"
    exit 0
fi

# 5. 正式开始执行
echo ""
echo "🚀 开始获取并执行底层 DD 脚本，请耐心等待..."
wget --no-check-certificate -qO InstallNET.sh 'https://raw.githubusercontent.com/leitbogioro/Tools/master/Linux_reinstall/InstallNET.sh'

# Windows 和 Linux 的底层命令有一点区别，这里做了判定
if [[ "$OS_CHOICE" == "13" || "$OS_CHOICE" == "14" ]]; then
    bash InstallNET.sh $OS_FLAG -pwd "$ROOT_PWD" -timezone 'Asia/Shanghai'
else
    bash InstallNET.sh $OS_FLAG -pwd "$ROOT_PWD" -port "$SSH_PORT" -timezone 'Asia/Shanghai'
fi
