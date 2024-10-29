#!/bin/bash

# 定义颜色输出的函数
green_echo() {
  echo -e "\033[32m$1\033[0m"
}

red_echo() {
  echo -e "\033[31m$1\033[0m"
}

# 检查是否为root用户
if [ "$EUID" -ne 0 ]; then
  red_echo "请以root用户运行此脚本。"
  exit 1
fi

# 检查是否已安装tcpping
if command -v tcpping &> /dev/null; then
  green_echo "tcpping已安装过，退出脚本。"
  exit 0
fi

# 检查并安装依赖
if command -v apt-get &> /dev/null; then
  green_echo "正在检查并安装依赖包..."
  apt-get update -y &> /dev/null
  apt-get install -y tcptraceroute bc &> /dev/null
  if [ $? -ne 0 ]; then
    red_echo "安装依赖包失败。"
    exit 1
  fi
elif command -v yum &> /dev/null; then
  green_echo "正在检查并安装依赖包..."
  yum update -y &> /dev/null
  yum install -y tcptraceroute bc &> /dev/null
  if [ $? -ne 0 ]; then
    red_echo "安装依赖包失败。"
    exit 1
  fi
else
  red_echo "不支持的操作系统。"
  exit 1
fi

# 下载tcpping脚本
green_echo "正在下载tcpping脚本..."
wget -O /tmp/tcpping https://mirror.ghproxy.com/https://raw.githubusercontent.com/deajan/tcpping/master/tcpping &> /dev/null
if [ $? -ne 0 ]; then
  red_echo "下载tcpping脚本失败。"
  exit 1
fi

# 移动tcpping脚本到/usr/bin/并赋予执行权限
green_echo "正在移动tcpping脚本到/usr/bin/..."
mv /tmp/tcpping /usr/bin/tcpping &> /dev/null
if [ $? -ne 0 ]; then
  red_echo "移动tcpping脚本失败。"
  exit 1
fi

chmod +x /usr/bin/tcpping &> /dev/null
if [ $? -ne 0 ]; then
  red_echo "赋予tcpping脚本执行权限失败。"
  exit 1
fi

green_echo "tcpping安装完成。"
