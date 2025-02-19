# Automated Package Update Script

This script automates the process of updating packages on Linux systems and can handle various package managers such as `apt`, `dnf`, and `yum`. It can also be set to run every 3 hours via `cron` or be executed automatically on system startup using `systemd`.

## Features

- Detects the package manager (`apt`, `dnf`, or `yum`).
- Updates installed packages.
- Removes unused packages and cleans the system.
- Schedules the script to run every 3 hours using `cron`.
- Optionally, sets up a `systemd` service to run the script at system startup.

## Requirements

- Linux system with `apt`, `dnf`, or `yum` as the package manager.
- `cron` and `systemd` (if you want the script to run automatically).
- Root (`sudo`) privileges to install updates and set up services.

## Installation

1. Clone or download the repository containing the `update_packages.sh` script:
   ```bash
   git clone https://github.com/zRainerzz/auto-package-update-script.git

Remember you should give permission to the file to be executed, command:
    chmod +x auto-package-update/Automate_Auto.sh

## Reminder
it will automatically install cron automaticallly (if not installed)
