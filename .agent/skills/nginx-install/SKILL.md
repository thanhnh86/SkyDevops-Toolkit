---
name: nginx-install
description: Automate the installation of Nginx on Ubuntu and CentOS using official repositories. Supports selecting between Stable (LTS) and Mainline (Latest) versions. Use this skill when the user wants to install Nginx, upgrade Nginx, or manage Nginx installation on Linux servers.
---

# Nginx Install Skill (Modular Plugin)

This skill automates the installation of Nginx using a modular plugin system that supports multi-level menus, OS detection, and progress animations.

## Architecture
The project is organized into a core framework and a plugin system:
- **`core/`**: Contains the UI framework, OS detection, and utility functions (progress bars, spinners).
- **`plugins/`**: Contains the logic for each service (e.g., `plugins/nginx/install.sh`).
- **`main.sh`**: The main entry point that sources the core components and routes the user's choices to the appropriate plugins.

## Features
- **Nested Menus**: Supports multiple levels of navigation (e.g., Service -> Action -> Version).
- **Auto OS Detect**: Automatically detects if the system is Ubuntu/Debian or CentOS/RHEL/Rockylinux.
- **Progressive UI**: Uses progress bars and spinners for a modern CLI experience.
- **Plugin System**: Easily add new software by creating a new folder in `plugins/` and sourcing it in `main.sh`.

## Adding a Plugin
To add a new software plugin:
1. Create a folder in `plugins/your-software/`.
2. Create `install.sh`, `optimize.sh`, etc.
3. Put installation heavy-lifting scripts in `plugins/your-software/scripts/`.
4. Source the plugin in `main.sh`.
5. Add the menu entry in `show_main_menu` and the case in `handle_choice`.

## Advanced Features
- **Dynamic Sudo/Root Detection**: `main.sh` automatically detects if the user is root or has sudo access, setting a global `$SUDO` variable.
- **Auto-Dependency Installation**: Installation scripts automatically install `curl`, `gnupg2`, `lsb-release`, etc., before the main software installation.
- **Container Compatibility**: Explicitly checks for `systemctl` existence to avoid errors in Docker/LXC environments.

## Requirements
The core toolkit requires:
- `bash`, `sed`, `grep`, `tput`.
- Root or `sudo` access (automatically detected).
- **Auto-installed by scripts**: `curl`, `gnupg2`, `lsb-release`, `ca-certificates`.

## Standard Plugin Structure (Best Practices)
When creating installation plugins for any new software, strictly adhere to the following workflow:
1. **Fetch Dynamic Versions**: Always fetch the latest versions dynamically from official sources instead of hardcoding whenever possible.
2. **Current Version Detection**: Identify if the software is already installed on the system and parse its exact version (e.g., `nginx -v`, `mysql -V`, `docker -v`).
3. **Smart Action Definition**: Based on the current version compared to the requested target version, dynamically define the installation action text:
   - *Cài đặt mới (Chưa cài đặt)*: If not installed.
   - *Re-install (Đang chạy vX)*: If target version equals current version.
   - *Gỡ bản cũ (vX) & Cài bản mới (vY)*: If target version differs from current version (Upgrade/Downgrade).
4. **User Confirmation**: Always display an overview UI box detailing the OS, Target Version, and Smart Action text. Explicit confirmation (`Y/n`) is required before proceeding.
5. **Real/Simulated Progress**: If an upgrade/downgrade is detected, explicitly simulate or run the uninstallation step before configuring the new repository and installing the new version.
6. **Robust Dependency Check**: Every installation script must include a `pre_install_checks` function to install required tools like `curl` before using them.
7. **Execution logic**: Always use the global `$SUDO` variable (defined in `main.sh`) instead of hardcoding `sudo`.
