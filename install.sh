#!/bin/bash

# Function to install Docker
install_docker() {
    echo "Installing Docker..."
    case "$ID" in
        ubuntu|debian|kali)
            sudo apt update && sudo apt upgrade -y
            sudo apt install -y git wget ca-certificates curl
            sudo install -m 0755 -d /etc/apt/keyrings
            curl -fsSL https://download.docker.com/linux/debian/gpg | sudo tee /etc/apt/keyrings/docker.asc > /dev/null
            curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo tee /etc/apt/keyrings/docker.asc > /dev/null
            sudo chmod a+r /etc/apt/keyrings/docker.asc
            echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
            sudo apt-get update
            sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
            ;;
        centos|almalinux)
            sudo yum update -y
            sudo yum install -y git yum-utils device-mapper-persistent-data lvm2
            sudo yum-config-manager -y --add-repo https://download.docker.com/linux/centos/docker-ce.repo
            sudo yum install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
            sudo systemctl start docker
            sudo systemctl enable docker
            ;;
        fedora)
            sudo dnf install -y git dnf-plugins-core
            sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
            sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
            sudo systemctl start docker
            sudo systemctl enable docker
            ;;
        *)
            echo "Unsupported operating system for Docker installation."
            exit 1
            ;;
    esac
}

# Function to install LibreChat
install_librechat() {

    echo "Installing LibreChat..."
    install_docker

    git clone https://github.com/danny-avila/LibreChat.git
    cd LibreChat || exit
    cp .env.example .env
    sudo docker compose pull
    sudo docker compose up -d

    LOCAL_IP=$(ip -4 addr show | awk '/inet/ && !/127.0.0.1/ {print $2}' | cut -d/ -f1 | head -n 1)
    PUBLIC_IP=$(curl -s ifconfig.me)

    echo "LibreChat has successfully installed and is accessible at $LOCAL_IP:3080 (Or $PUBLIC_IP:3080 if you have port forwarded)"
}

# Function to install CloudFlare Tunnel
install_cloudflare_tunnel() {
    echo "Setting up CloudFlare Tunnel..."
    curl -L --output cloudflared.deb https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb
    sudo dpkg -i cloudflared.deb
    echo "Copy the 'If you already have cloudflared installed on your machine' command and paste it below"
    echo "Command Provided by CloudFlare:"
}

# Function to install Tailscale
install_tailscale() {
    echo "Installing Tailscale...."
    curl -fsSL https://tailscale.com/install.sh | sh
    tailscale up
    echo "Tailscale has been installed and should now be connected to your tailnet."
}

# Main installation menu
install_menu() {
    echo "Detecting operating system..."
    sleep 2
    . /etc/os-release

    echo "${ID^} Installation Menu:"
    echo "1. Install LibreChat"
    echo "2. Install CloudFlare Tunnel"
    echo "3. Install Tailscale"
    echo "4. Exit"
    read -p "Enter your choice: " choice

    case $choice in
        1) install_librechat ;;
        2) install_cloudflare_tunnel ;;
        3) install_tailscale ;;
        4) exit 0 ;;
        *) echo "Invalid choice"; exit 1 ;;
    esac
}

# Start the installation process
install_menu