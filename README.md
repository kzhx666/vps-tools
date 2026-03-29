# VPS 自动化部署工具箱 (vps-tools)

这是一个自用的 VPS 自动化初始化与重装工具箱。主要用于快速将各类云服务器一键重装为纯净的 Linux 或 Windows 系统，并进行基础的安全和网络环境优化。

## 📦 包含脚本

1. **`dd.sh`**：万能交互式系统重装脚本（底层调用 `leitbogioro` 的 InstallNET 脚本）。支持 Debian、Ubuntu、RHEL 系、Alpine、Kali 以及 Windows 的一键网络重装。
2. **`init.sh`**：纯净系统基础环境一键初始化脚本（更新源、安装必备组件、开启 BBR 加速等），仅限 Debian/Ubuntu 系统使用。

---

## 🚀 使用方法

### 第一阶段：重装纯净系统 (DD)

在需要重装的旧系统 SSH 终端中，直接运行以下命令：

```bash
bash <(curl -sL https://raw.githubusercontent.com/kzhx666/vps-tools/main/dd.sh)
```

**功能说明：**
- **多系统支持**：提供 14 种常见系统选项，支持自动拉取 Debian/Ubuntu/Alpine 的**最新稳定版**。
- **密码自定义**：运行后可交互式自定义 Root / Administrator 密码。
- **端口智能化**：
  - **Linux 系统**：可自定义 SSH 端口（直接回车则默认使用 `22` 端口）。
  - **Windows 系统**：自动适配并锁定 RDP 远程桌面端口为 `3389`。
- **自动时区**：所有系统均会自动将时区设置为 `Asia/Shanghai`（北京时间）。
- **⚠️ 警告：执行此操作将彻底清空当前服务器硬盘上的所有数据，且不可逆转！**

等待 15-30 分钟（Windows 可能需要更久）后，使用你在脚本中设置的新端口和密码，重新连接服务器。

---

### 第二阶段：新系统初始化配置 (仅限 Linux)

如果你重装的是 **Debian** 或 **Ubuntu** 系统，在新系统连接成功后，运行以下命令进行基础基建：

```bash
bash <(curl -sL https://raw.githubusercontent.com/kzhx666/vps-tools/main/init.sh)
```

**功能说明：**
- 全自动更新系统软件包索引及升级系统 (`apt update && apt upgrade -y`)。
- 一键安装运维必备小工具 (`curl`, `wget`, `sudo`, `vim`, `git`, `htop`, `tar`, `net-tools`)。
- 自动修改内核参数，一键开启 `BBR + fq` 网络拥塞控制算法提速。

---

## 💡 注意事项

1. **端口放行**：如果你在 `dd.sh` 步骤中自定义了高端口号（或安装了使用 3389 端口的 Windows），请务必在服务器重启前，前往云服务商控制台的**安全组/防火墙**中放行该端口，否则重装后将无法连接！
2. **Windows 硬件要求**：重装 Windows 系统非常消耗资源，建议您的 VPS 配置至少达到 **1核 CPU、2GB 内存** 及 **20GB 硬盘**，否则极易安装失败或运行卡顿。
3. **环境修复**：脚本执行过程中请保持网络畅通。若在旧系统中遇到 `wget: command not found` 等基础环境缺失问题，建议先修复系统环境变量（`export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin`）后再执行。
