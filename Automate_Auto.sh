#!/bin/bash

# A script to automate package updates for all Linux distros.

echo "Starting package update..."

# Detect the package manager and run the corresponding update command

if command -v apt &> /dev/null; then
    echo "Using apt package manager..."
    sudo apt update && sudo apt upgrade -y
    sudo apt autoremove -y
    sudo apt clean
elif command -v dnf &> /dev/null; then
    echo "Using dnf package manager..."
    sudo dnf update -y
    sudo dnf autoremove -y
    sudo dnf clean all
elif command -v yum &> /dev/null; then
    echo "Using yum package manager..."
    sudo yum update -y
    sudo yum autoremove -y
    sudo yum clean all
else
    echo "No known package manager found. Please install one of apt, dnf, or yum."
    exit 1
fi

echo "Package update complete!"

# Automatically add the cron job to run the script every 3 hours
(crontab -l 2>/dev/null; echo "0 */3 * * * /path/to/update_packages.sh") | crontab -

# Automatically add the script to system startup using systemd (if systemd is available)
if command -v systemctl &> /dev/null; then
    echo "Setting up systemd service to run script at startup..."
    [Unit]
Description=Package Update Service

[Service]
ExecStart=/path/to/update_packages.sh
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF'
    
    # Reload systemd to apply changes
    sudo systemctl daemon-reload
    
    # Enable and start the systemd service
    sudo systemctl enable update_packages.service
    sudo systemctl start update_packages.service
else
    echo "systemd not found, skipping systemd setup."
fi



    
    # Create a systemd service file
    sudo bash -c 'cat > /etc/systemd/system/update_packages.service <<EOF
