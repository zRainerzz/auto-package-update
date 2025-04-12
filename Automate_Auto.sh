#!/bin/bash

# Function to install cron if not installed
install_cron() {
    echo "Checking if cron is installed..."

    # Check package manager
    if command -v apt-get &>/dev/null; then
        # For Debian/Ubuntu-based systems
        if ! dpkg -l | grep -q cron; then
            echo "Cron not installed. Installing cron..."
            sudo apt-get update && sudo apt-get install -y cron
        else
            echo "Cron is already installed."
        fi
    elif command -v dnf &>/dev/null; then
        # For RedHat/CentOS/Fedora-based systems
        if ! rpm -q cronie &>/dev/null; then
            echo "Cron not installed. Installing cron..."
            sudo dnf install -y cronie
        else
            echo "Cron is already installed."
        fi
    elif command -v yum &>/dev/null; then
        # For older RedHat/CentOS/Fedora systems
        if ! rpm -q cronie &>/dev/null; then
            echo "Cron not installed. Installing cron..."
            sudo yum install -y cronie
        else
            echo "Cron is already installed."
        fi
    else
        echo "Unsupported package manager. Cannot install cron automatically."
        exit 1
    fi

    # Start cron service if it's not already running
    if ! systemctl is-active --quiet cron; then
        echo "Starting cron service..."
        sudo systemctl start cron
        sudo systemctl enable cron
    fi
}

# Function to update packages based on package manager
update_packages() {
    if command -v apt-get &>/dev/null; then
        # For Debian/Ubuntu-based systems
        echo "Updating packages using apt..."
        sudo apt-get update && sudo apt-get upgrade -y && sudo apt-get autoremove -y && sudo apt-get clean
    elif command -v dnf &>/dev/null; then
        # For RedHat/CentOS/Fedora-based systems
        echo "Updating packages using dnf..."
        sudo dnf upgrade --refresh -y && sudo dnf autoremove -y
    elif command -v yum &>/dev/null; then
        # For older RedHat/CentOS/Fedora systems
        echo "Updating packages using yum..."
        sudo yum update -y && sudo yum autoremove -y
    else
        echo "Unsupported package manager. Cannot update packages."
        exit 1
    fi
}

# Function to schedule the script using cron
schedule_cron_job() {
    CRON_JOB="0 */3 * * * /path/to/update_packages.sh"
    (crontab -l 2>/dev/null; echo "$CRON_JOB") | crontab -
    echo "Scheduled package update every 3 hours using cron."
}

# Function to create a systemd service
create_systemd_service() {
    SERVICE_FILE="/etc/systemd/system/update_packages.service"
    echo "[Unit]
Description=Automated Package Update Script

[Service]
ExecStart=/path/to/update_packages.sh
Restart=always
User=root

[Install]
WantedBy=multi-user.target" | sudo tee $SERVICE_FILE > /dev/null

    sudo systemctl daemon-reload
    sudo systemctl enable update_packages.service
    sudo systemctl start update_packages.service
    echo "Systemd service created to run the script at startup."
}

# Main script execution
install_cron
update_packages
schedule_cron_job
create_systemd_service

echo "Package update process completed."
echo ""
echo "To stop the auto-update systemd service, run:"
echo "  sudo systemctl stop update_packages.service && sudo systemctl disable update_packages.service"
