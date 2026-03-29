#!/bin/bash

clear
echo "=========================================================="
echo "      欢迎使用 kzhx 的 Debian 12 新系统初始化脚本"
echo "=========================================================="
echo ""

echo "▶ [1/3] 正在更新系统软件包索引并升级系统..."
# 加上 DEBIAN_FRONTEND=noninteractive 防止更新内核时弹出粉色对话框卡住脚本
export DEBIAN_FRONTEND=noninteractive
apt update -y && apt upgrade -y

echo "▶ [2/3] 正在安装常用基建工具..."
apt install -y curl wget sudo vim git htop tar net-tools

echo "▶ [3/3] 正在开启 BBR + fq 网络加速..."
# 检查是否已经配置过，防止重复写入
if ! grep -q "net.ipv4.tcp_congestion_control" /etc/sysctl.conf; then
    echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
    sysctl -p
    echo "✅ BBR 配置已写入并生效。"
else
    echo "⚡ BBR 配置已存在，跳过写入。"
fi

# 验证 BBR 是否成功开启
BBR_STATUS=$(sysctl net.ipv4.tcp_congestion_control | awk '{print $3}')
echo "当前内核拥塞控制算法为: $BBR_STATUS"

echo ""
echo "=========================================================="
echo "🎉 初始化全部完成！系统现已处于满血状态。"
echo "=========================================================="
