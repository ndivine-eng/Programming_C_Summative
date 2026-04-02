# Linux Server Health Monitoring and Alert Automation Script

## Project Description
This project is a Linux shell script that monitors the health and performance of a server. It tracks CPU usage, memory consumption, disk utilization, and active processes. The script also supports threshold-based alerts, activity logging, continuous monitoring, and an interactive terminal menu.

## Features
- Displays current CPU, memory, disk, and process usage
- Allows users to configure CPU, memory, and disk thresholds
- Generates warning alerts when thresholds are exceeded
- Saves monitoring activity and alerts into a log file
- Supports continuous monitoring with a configurable time interval
- Provides an interactive command-line menu
- Includes input validation and dependency checking

## Files
- `monitor.sh` - main shell script
- `monitor_config.conf` - stores monitoring thresholds and interval
- `server_health.log` - stores activity logs and alerts
- `.gitignore` - ignores generated files

## Tools Used
- Bash shell scripting
- Linux commands:
  - `top`
  - `free`
  - `df`
  - `ps`
  - `awk`
  - `grep`

## How to Run

### Step 1: Give execute permission
```bash
chmod +x monitor.sh