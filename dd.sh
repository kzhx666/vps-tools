#!/bin/bash

clear
echo "=========================================================="
echo "      欢迎使用 kzhx 的专属 Debian 12 一键 DD 脚本"
echo "=========================================================="
echo ""

# 1. 交互输入密码
read -p "👉 请输入您要设置的 root 密码 (务必牢记): " ROOT_PWD
if [ -z "$ROOT_PWD" ]; then
    echo "❌ 错误：密码不能为空！已退出。"
    exit 1
fi

# 2. 交互输入端口 (修改为默认 22)
read -p "👉 请输入 SSH 端口 (直接回车则默认使用 22): " SSH_PORT
if [ -z "$SSH_PORT" ]; then
    SSH_PORT=22
    echo "💡 未输入，将使用默认端口: 22"
fi

# 3. 最终信息确认
echo ""
echo "=========================================================="
echo "请确认您的重装配置："
echo "▶ 操作系统: Debian 12"
echo "▶ 时区设置: Asia/Shanghai (北京时间)"
echo "▶ SSH 端口: $SSH_PORT"
echo "▶ Root 密码: $ROOT_PWD"
echo "=========================================================="
echo "⚠️ 警告：重装将清空硬盘所有数据，且不可逆！"
if [ "$SSH_PORT" != "22" ]; then
    echo "⚠️ 提醒：请确保已在云面板安全组中放行了 $SSH_PORT 端口！"
fi
read -p "确认无误并开始执行重装吗？(y/n): " CONFIRM

if [[ "$CONFIRM" != "y" && "$CONFIRM" != "Y" ]]; then
    echo "🛑 已取消重装操作。"
    exit 0
fi

# 4. 正式开始执行
echo ""
echo "🚀 开始获取并执行底层 DD 脚本，请耐心等待..."
wget --no-check-certificate -qO InstallNET.sh 'https://raw.githubusercontent.com/leitbogioro/Tools/master/Linux_reinstall/InstallNET.sh'
bash InstallNET.sh -debian 12 -pwd "$ROOT_PWD" -port "$SSH_PORT" -timezone 'Asia/Shanghai'
