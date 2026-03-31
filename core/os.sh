#!/bin/bash

# ==============================
# OS DETECTION HELPER
# ==============================

detect_os() {
    if [ -f /etc/os-release ]; then
        # Use grep to avoid sourcing and clobbering common variables like VERSION
        OS_ID=$(grep -E '^ID=' /etc/os-release | cut -d= -f2 | tr -d '"')
        OS_VER=$(grep -E '^VERSION_ID=' /etc/os-release | cut -d= -f2 | tr -d '"')
        OS_NAME=$(grep -E '^NAME=' /etc/os-release | cut -d= -f2 | tr -d '"')
        OS_CODENAME=$(grep -E '^VERSION_CODENAME=' /etc/os-release | cut -d= -f2 | tr -d '"')
        [ -z "$OS_CODENAME" ] && OS_CODENAME=$(grep -E '^UBUNTU_CODENAME=' /etc/os-release | cut -d= -f2 | tr -d '"')
    elif [ -f /etc/redhat-release ]; then
        OS_ID="centos"
        OS_NAME="CentOS"
        OS_VER=$(cat /etc/redhat-release | grep -oE '[0-9]+(\.[0-9]+)?')
    else
        OS_ID="unknown"
        OS_NAME="Unknown OS"
        OS_VER="?"
    fi
}

is_ubuntu() {
    [ "$OS_ID" == "ubuntu" ] || [ "$OS_ID" == "debian" ]
}

is_centos() {
    [ "$OS_ID" == "centos" ] || [ "$OS_ID" == "rhel" ] || [ "$OS_ID" == "rocky" ] || [ "$OS_ID" == "almalinux" ]
}

# Example use: 
# detect_os
# if is_ubuntu; then ... fi
