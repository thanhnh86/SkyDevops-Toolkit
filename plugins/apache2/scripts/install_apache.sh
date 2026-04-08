#!/bin/bash

# Apache2 Automation Install Script
# Supports: Ubuntu, CentOS

set -e

OS=""
CODENAME=""
UNINSTALL=false

# Parse arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --uninstall) UNINSTALL=true ;;
        --help) echo "Usage: $0 [--uninstall]"; exit 0 ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

# Detect OS
if [ -f /etc/os-release ]; then
    OS_ID=$(grep -E '^ID=' /etc/os-release | cut -d= -f2 | tr -d '"')
    CODENAME=$(grep -E '^VERSION_CODENAME=' /etc/os-release | cut -d= -f2 | tr -d '"')
    [ -z "$CODENAME" ] && CODENAME=$(grep -E '^UBUNTU_CODENAME=' /etc/os-release | cut -d= -f2 | tr -d '"')
elif [ -f /etc/redhat-release ]; then
    OS_ID="centos"
else
    echo "Unsupported OS"
    exit 1
fi

echo "Detected OS: $OS_ID ($CODENAME)"

pre_install_checks() {
    echo "Checking and installing basic dependencies..."
    case $OS_ID in
        ubuntu|debian)
            # Cleanup broken repo lists that frequently cause issues
            echo "Cleaning up potentially broken repository lists..."
            rm -f /etc/apt/sources.list.d/nginx.list
            # Specific fix for the doubled 'packages/packages' URL if it exists in any file
            grep -l "nginx.org/packages/packages" /etc/apt/sources.list.d/* 2>/dev/null | xargs rm -f || true
            
            apt-get update -y
            apt-get install -y curl gnupg2 ca-certificates lsb-release
            ;;
        centos|rhel|fedora|almalinux|rocky)
            yum install -y curl yum-utils
            ;;
    esac
}

perform_uninstall() {
    echo "Removing existing Apache2 installation..."
    case $OS_ID in
        ubuntu|debian)
            systemctl stop apache2 || true
            apt-get remove -y apache2 apache2-utils apache2-bin apache2.2-common || true
            apt-get purge -y apache2 apache2-utils apache2-bin apache2.2-common || true
            apt-get autoremove -y || true
            ;;
        centos|rhel|fedora|almalinux|rocky)
            systemctl stop httpd || true
            yum remove -y httpd || true
            ;;
    esac
}

install_ubuntu() {
    echo "Installing Apache2 on Ubuntu..."
    apt-get update
    apt-get install -y apache2
}

install_centos() {
    echo "Installing Apache2 (httpd) on CentOS..."
    yum install -y httpd
}

# Execution logic
pre_install_checks

if [ "$UNINSTALL" = true ]; then
    perform_uninstall
fi

case $OS_ID in
    ubuntu|debian)
        install_ubuntu
        systemctl enable apache2 || true
        systemctl start apache2 || true
        ;;
    *)
        install_centos
        systemctl enable httpd || true
        systemctl start httpd || true
        ;;
esac

echo "Apache2 installation completed!"
if command -v apache2 >/dev/null 2>&1; then
    apache2 -v
elif command -v httpd >/dev/null 2>&1; then
    httpd -v
fi
