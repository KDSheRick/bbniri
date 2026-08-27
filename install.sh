#!/usr/bin/env bash
# ==============================================================================
# bbniri — Niri desktop ricing for Ubuntu (derived from NyxNiri)
# Deploys configs from this checkout into ~/.config with a timestamped backup.
# System packages / Noctalia must be installed separately (see README.md).
# ==============================================================================
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config"
BACKUP_DIR="$CONFIG_DIR/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

backup() {
    if [ -e "$CONFIG_DIR/$1" ]; then
        mkdir -p "$BACKUP_DIR"
        mv "$CONFIG_DIR/$1" "$BACKUP_DIR/$1"
    fi
}

deploy_dir() {
    if [ -d "$REPO_DIR/configs/$1" ]; then
        backup "$1"
        cp -r "$REPO_DIR/configs/$1" "$CONFIG_DIR/$1"
        echo "[✓] $1"
    fi
}

deploy_file() {
    if [ -f "$REPO_DIR/configs/$1" ]; then
        backup "$1"
        cp "$REPO_DIR/configs/$1" "$CONFIG_DIR/$1"
        echo "[✓] $1"
    fi
}

echo ":: bbniri 配置部署 (备份目录: $BACKUP_DIR)"

# 1. Configs
deploy_dir niri
deploy_dir noctalia
deploy_dir kitty
deploy_dir fish
deploy_dir fastfetch
deploy_dir zed
deploy_dir xdg-desktop-portal
deploy_file starship.toml

# 2. Portable template rendering: /home/user -> real $HOME
sed -i "s#/home/user#$HOME#g" "$CONFIG_DIR/noctalia/noctalia-config.toml"

# 3. effects.kdl symlink (normal mode by default; Super+N toggles eye-care)
if [ ! -L "$CONFIG_DIR/niri/effects.kdl" ]; then
    ln -sfn effects_normal.kdl "$CONFIG_DIR/niri/effects.kdl"
fi

# 4. Wallpapers (no-clobber) & screenshot dir
mkdir -p "$HOME/Pictures/Wallpapers" "$HOME/Pictures/Screenshots"
if command -v rsync >/dev/null 2>&1; then
    rsync -a --ignore-existing "$REPO_DIR/assets/wallpapers/" "$HOME/Pictures/Wallpapers/"
else
    cp -rn "$REPO_DIR/assets/wallpapers/." "$HOME/Pictures/Wallpapers/"
fi
echo "[✓] wallpapers -> $HOME/Pictures/Wallpapers"

# 5. fcitx5 NyxMellow theme assets
mkdir -p "$HOME/.local/share/fcitx5/themes"
cp -rn "$REPO_DIR/assets/fcitx5/nyxmellow" "$HOME/.local/share/fcitx5/themes/" 2>/dev/null || true
echo "[✓] fcitx5 theme -> ~/.local/share/fcitx5/themes/nyxmellow"

# 6. Preflight hints
echo
for cmd in niri noctalia kitty fish starship; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "[!] 未找到 $cmd — 请参考 README.md 安装方式先补齐依赖"
    fi
done
if command -v niri >/dev/null 2>&1; then
    echo "[✓] 当前 niri 配置: $(niri validate >/dev/null 2>&1 && echo "有效" || echo "无效,请检查日志")"
fi

echo
echo "完成!现在退出登录,在登录界面选择 Niri;快捷方式: Super+Enter 终端 / Super+R 启动器 / Super+W 壁纸 / Super+N 护眼"
