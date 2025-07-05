#!/usr/bin/env bash

# Arch Linux-specific functions

# Update system with comprehensive package management
update_system() {
    echo "Updating Arch Linux system..."
    
    # Update pacman packages
    sudo pacman -Syu
    
    # Update AUR packages if yay is installed
    if command -v yay &> /dev/null; then
        echo "Updating AUR packages..."
        yay -Syu --noconfirm
    fi
    
    # Clean package cache
    sudo pacman -Sc --noconfirm
    
    # Update flatpak packages if installed
    if command -v flatpak &> /dev/null; then
        echo "Updating Flatpak packages..."
        flatpak update -y
    fi
    
    # Clean orphaned packages
    if pacman -Qdt | grep -q .; then
        echo "Cleaning orphaned packages..."
        sudo pacman -Rns $(pacman -Qdtq) --noconfirm
    fi
    
    echo "System update complete!"
}

# Install AUR helper (yay) if not present
install_yay() {
    if ! command -v yay &> /dev/null; then
        echo "Installing yay AUR helper..."
        cd /tmp
        git clone https://aur.archlinux.org/yay.git
        cd yay
        makepkg -si
        cd ~
        rm -rf /tmp/yay
        echo "yay installed successfully!"
    else
        echo "yay is already installed"
    fi
}

# Network interface management
wifi_connect() {
    if [ -z "$1" ]; then
        echo "Usage: wifi_connect <network_name> [password]"
        return 1
    fi
    
    local network="$1"
    local password="$2"
    
    if [ -z "$password" ]; then
        iwctl station wlan0 connect "$network"
    else
        iwctl --passphrase="$password" station wlan0 connect "$network"
    fi
}

wifi_scan() {
    iwctl station wlan0 scan
    iwctl station wlan0 get-networks
}

wifi_status() {
    iwctl station wlan0 show
}

# System information
sysinfo() {
    echo "=== System Information ==="
    echo "OS: $(lsb_release -d | cut -f2)"
    echo "Kernel: $(uname -r)"
    echo "Uptime: $(uptime -p)"
    echo "Load: $(uptime | awk -F'load average:' '{print $2}')"
    echo "Memory: $(free -h | awk 'NR==2{printf "%.1f/%.1f GB (%.1f%%)\n", $3/1024/1024, $2/1024/1024, $3*100/$2}')"
    echo "Disk: $(df -h / | awk 'NR==2{printf "%s/%s (%s)\n", $3, $2, $5}')"
}

# Package management helpers
pkg_info() {
    if [ -z "$1" ]; then
        echo "Usage: pkg_info <package_name>"
        return 1
    fi
    
    if pacman -Qi "$1" &> /dev/null; then
        pacman -Qi "$1"
    elif pacman -Si "$1" &> /dev/null; then
        pacman -Si "$1"
    else
        echo "Package '$1' not found"
        return 1
    fi
}

pkg_files() {
    if [ -z "$1" ]; then
        echo "Usage: pkg_files <package_name>"
        return 1
    fi
    
    if pacman -Qi "$1" &> /dev/null; then
        pacman -Ql "$1"
    else
        echo "Package '$1' is not installed"
        return 1
    fi
}

# Find which package owns a file
pkg_owns() {
    if [ -z "$1" ]; then
        echo "Usage: pkg_owns <file_path>"
        return 1
    fi
    
    pacman -Qo "$1"
}

# List recently installed packages
pkg_recent() {
    local count=${1:-10}
    grep -E "installed|upgraded" /var/log/pacman.log | tail -n "$count"
}

# System maintenance
clean_system() {
    echo "Cleaning system..."
    
    # Clean package cache
    sudo pacman -Sc --noconfirm
    
    # Clean orphaned packages
    if pacman -Qdt | grep -q .; then
        echo "Removing orphaned packages..."
        sudo pacman -Rns $(pacman -Qdtq) --noconfirm
    fi
    
    # Clean journal logs older than 1 week
    sudo journalctl --vacuum-time=1week
    
    # Clean thumbnail cache
    rm -rf ~/.cache/thumbnails/*
    
    echo "System cleanup complete!"
}

# Hyprland-specific functions
hypr_reload() {
    if [ "$XDG_CURRENT_DESKTOP" = "Hyprland" ]; then
        hyprctl reload
        echo "Hyprland configuration reloaded"
    else
        echo "Not running Hyprland"
    fi
}

# Service management shortcuts
service_status() {
    if [ -z "$1" ]; then
        echo "Usage: service_status <service_name>"
        return 1
    fi
    systemctl status "$1"
}

service_start() {
    if [ -z "$1" ]; then
        echo "Usage: service_start <service_name>"
        return 1
    fi
    sudo systemctl start "$1"
}

service_stop() {
    if [ -z "$1" ]; then
        echo "Usage: service_stop <service_name>"
        return 1
    fi
    sudo systemctl stop "$1"
}

service_enable() {
    if [ -z "$1" ]; then
        echo "Usage: service_enable <service_name>"
        return 1
    fi
    sudo systemctl enable "$1"
}

service_disable() {
    if [ -z "$1" ]; then
        echo "Usage: service_disable <service_name>"
        return 1
    fi
    sudo systemctl disable "$1"
}