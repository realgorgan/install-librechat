# LibreChat Installation Automation Script

This script sets up a LibreChat environment on your Linux server. It also includes options for setting up a CloudFlare Tunnel and Tailscale for external access if you don't want to port forward.

# Original repository is located here [here](https://github.com/danny-avila/LibreChat)

## Supported Operating Systems
| Operating System | Version | Supported          
| ---------------- | ------- | ------------------ 
| Ubuntu           | 20.04   | :grey_question:
|                  | 22.04   | :white_check_mark:
|                  | 24.04   | :grey_question:
| Debian           | 11      | :grey_question:
|                  | 12      | :grey_question:
| CentOS           | 9       | :grey_question:
| AlmaLinux        | 8       | :grey_question:
|                  | 9       | :grey_question:
| Fedora           | 40      | :grey_question:
| Kali Linux       | 2024.2  | :grey_question:
| Manjaro          | 24      | :grey_question:

## Features

1. Install Supabase
2. Setup CloudFlare Tunnel
3. Setup Tailscale

## Usage

### Running the Script

```
sudo bash -c "$(curl -sSL https://raw.githubusercontent.com/realgorgan/install-librechat/main/install.sh)"
```
Copy and paste this into your system and follow the prompts.
