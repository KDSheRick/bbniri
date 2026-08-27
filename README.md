# bbniri — Niri 桌面美化 (Ubuntu 移植版)

> 基于 [NyxNiri](https://github.com/ech678/NyxNiri)(原为 Arch Linux 定制)移植到 Ubuntu 25.10 的方案。
> [Niri](https://niri.dev) + [Noctalia V5](https://noctalia.dev) + Material You 主题同步。

## 特性

- **Niri 26.04**:毛玻璃 Blur、圆角、动画、护眼模式(`Super+N` 一键切换,温色温 + 窗口变纯色)
- **Noctalia V5 Shell**:状态栏 / 应用启动器 / 控制中心 / 剪贴板历史 / 锁屏 / 动态壁纸,全部随壁纸取色(Material You)
- **Orbit 星环径向启动器**(`Super+A` / 鼠标侧键):矢量动画,M3 配色
- **壁纸选择器**(`Super+W`):静态 + 动态视频壁纸聚合,自动同步 Noctalia 主题
- **Terminal & Shell**:Kitty(透明、光标拖尾)+ Fish + Starship 提示符,Windows 风格快捷键
- **NyxMellow**:fcitx5 圆润皮肤,随主题自动换色(明暗双版本)
- 配置快照安全:个人修改写在 `__custom__` 文件中,更新不覆盖

## 安装(Ubuntu 25.10+,其他发行版按自己包管理器替换)

### 1. niri + 桌面组件

```bash
sudo add-apt-repository -y ppa:avengemedia/danklinux
sudo apt update
sudo apt install -y niri kitty fish fzf jq wl-clipboard starship fastfetch \
  libnotify-bin python3-gi python3-gi-cairo gir1.2-gtklayershell-0.1 gir1.2-gtk-3.0 \
  gir1.2-gdkpixbuf-2.0 xdg-desktop-portal xdg-desktop-portal-gnome xdg-desktop-portal-gtk \
  xwayland ddcutil wlsunset wireplumber upower mpv \
  fcitx5 fcitx5-modules fonts-jetbrains-mono fonts-noto-cjk
```

### 2. 编译 Noctalia V5

```bash
sudo apt install -y just meson ninja-build pkg-config gcc g++ git \
  libwayland-dev wayland-protocols libfreetype-dev libfontconfig-dev libcairo2-dev \
  libpango1.0-dev librsvg2-dev libxkbcommon-dev libepoxy-dev libgles-dev libwebp-dev \
  libcurl4-gnutls-dev libmd4c-dev nlohmann-json3-dev libsdbus-c++-dev libsecret-1-dev \
  libsodium-dev libstb-dev libtomlplusplus-dev libpipewire-0.3-dev libpam0g-dev \
  libpolkit-agent-1-dev libpolkit-gobject-1-dev libqalculate-dev libwireplumber-0.5-dev \
  libxml2-dev libjemalloc-dev libical-dev libjxl-dev libsndfile1-dev

git clone --depth 1 https://github.com/noctalia-dev/noctalia.git ~/noctalia
cd ~/noctalia
# 本仓库使用:meson setup build-release --buildtype release -Dcpp_std=c++23 -Dtests=auto -Db_lto=false --prefix /usr/local
just configure release && just build release
sudo just install release
```

> Ubuntu 26.04+ 用户可以直接用官方 APT 源(见 Noctalia 文档)跳过编译。

### 3. 部署配置

```bash
git clone --depth 1 https://github.com/KDSheRick/bbniri.git ~/bbniri
cd ~/bbniri && ./install.sh
```

脚本会:备份旧配置到 `~/.config/dotfiles_backup_*`、替换 `$HOME` 路径、建立 `effects.kdl` 软链、拷贝壁纸与 fcitx5 皮肤,并检查 **JetBrainsMono Nerd Font**(Super+A Orbit 启动器图标必需,缺失时会输出安装指引)。

### 4. 登录

注销,在登录界面点击齿轮选择 **Niri**,登录后 Noctalia 自动接管桌面与主题。

## 快捷键速查

| 快捷键 | 功能 |
|---|---|
| Super + Enter / R / E | 终端 / 启动器 / 文件管理器 |
| Super + W | 壁纸选择器(静态 & 动态) |
| Super + N | 护眼模式 |
| Super + A / 鼠标侧键 | Orbit 星环启动器 |
| Super + Tab | 工作区总览 |
| Super + T | 浮动/平铺切换 |
| Super + G | 标签页分组 |
| Super + Shift + S | 截图 |
| Super + L | 锁屏 |
| Super + Shift + R / Q | 重载配置 / 退出 |
| Super + / | 显示完整快捷键列表 |
| Super + ~ | Kitty 悬浮终端 |
| Super + Ctrl + W | 随机换壁纸 |

完整列表参考 [NyxNiri Keybindings](https://github.com/ech678/NyxNiri/blob/main/README.md#keybindings)。

## 自定义

- 个人改动写到 `~/.config/niri/__custom__.kdl`、`~/.config/niri/input__custom__.kdl`、`~/.config/fish/conf.d/__custom__.fish`、`~/.config/kitty/__custom__.conf`,更新仓库不影响它们
- 显示器布局:编辑 `~/.config/niri/monitor.kdl`(或安装 nwg-displays 生成)
- 动态视频壁纸需要 `mpvpaper`(Ubuntu 暂无 wlroots 开发包,需手动编译;缺失时 Noctalia 插件自动禁用)

## 致谢 & 许可

- [NyxNiri](https://github.com/ech678/NyxNiri) by ech678(原方案,本仓库的配置与素材大部分源于此)
- [Noctalia](https://noctalia.dev)(桌面 Shell)
- [Niri](https://github.com/niri-wm/niri)(Wayland 合成器)
- [mpvpaper](https://github.com/GhostNaN/mpvpaper) / [wallpaper-collection](https://github.com/ech678/wallpaper-collection)

GPL-3.0,详见 [LICENSE](LICENSE)。
