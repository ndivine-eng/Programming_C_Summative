#!/bin/bash

# ==========================================
# Linux Server Health Monitoring Script
# ==========================================

LOG_FILE="server_health.log"
CONFIG_FILE="monitor_config.conf"

# Default values
CPU_THRESHOLD=80
MEM_THRESHOLD=80
DISK_THRESHOLD=90
INTERVAL=5

# ----------------------------
# Load config if exists
# ----------------------------
if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
fi

# ----------------------------
# Save config
# ----------------------------
save_config() {
    echo "CPU_THRESHOLD=$CPU_THRESHOLD" > "$CONFIG_FILE"
    echo "MEM_THRESHOLD=$MEM_THRESHOLD" >> "$CONFIG_FILE"
    echo "DISK_THRESHOLD=$DISK_THRESHOLD" >> "$CONFIG_FILE"
    echo "INTERVAL=$INTERVAL" >> "$CONFIG_FILE"
}

# ----------------------------
# Logging
# ----------------------------
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

# ----------------------------
# Get system stats
# ----------------------------
get_cpu() {
    top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}' | cut -d. -f1
}

get_memory() {
    free | awk '/Mem:/ {printf("%.0f"), $3/$2 * 100}'
}

get_disk() {
    df / | awk 'NR==2 {gsub("%",""); print $5}'
}

get_processes() {
    ps -e | wc -l
}

# ----------------------------
# Display health
# ----------------------------
show_health() {
    cpu=$(get_cpu)
    mem=$(get_memory)
    disk=$(get_disk)
    proc=$(get_processes)

    echo "-------------------------------"
    echo "System Health"
    echo "-------------------------------"
    echo "CPU Usage    : $cpu%"
    echo "Memory Usage : $mem%"
    echo "Disk Usage   : $disk%"
    echo "Processes    : $proc"
    echo "-------------------------------"

    log "CPU=$cpu MEM=$mem DISK=$disk PROC=$proc"
}

# ----------------------------
# Check alerts
# ----------------------------
check_alerts() {
    cpu=$(get_cpu)
    mem=$(get_memory)
    disk=$(get_disk)

    if [ "$cpu" -gt "$CPU_THRESHOLD" ]; then
        echo "Warning: CPU high ($cpu%)"
        log "ALERT CPU $cpu%"
    fi

    if [ "$mem" -gt "$MEM_THRESHOLD" ]; then
        echo "Warning: Memory high ($mem%)"
        log "ALERT MEM $mem%"
    fi

    if [ "$disk" -gt "$DISK_THRESHOLD" ]; then
        echo "Warning: Disk high ($disk%)"
        log "ALERT DISK $disk%"
    fi
}

# ----------------------------
# Configure thresholds
# ----------------------------
configure() {
    echo "Set CPU threshold:"
    read cpu
    echo "Set Memory threshold:"
    read mem
    echo "Set Disk threshold:"
    read disk
    echo "Set interval (seconds):"
    read interval

    CPU_THRESHOLD=$cpu
    MEM_THRESHOLD=$mem
    DISK_THRESHOLD=$disk
    INTERVAL=$interval

    save_config
    echo "Settings updated."
}

# ----------------------------
# Monitoring loop
# ----------------------------
start_monitor() {
    echo "Monitoring started (Ctrl+C to stop)"
    while true; do
        show_health
        check_alerts
        sleep $INTERVAL
    done
}

# ----------------------------
# Logs
# ----------------------------
view_logs() {
    if [ -f "$LOG_FILE" ]; then
        cat "$LOG_FILE"
    else
        echo "No logs yet."
    fi
}

clear_logs() {
    > "$LOG_FILE"
    echo "Logs cleared."
}

# ----------------------------
# Menu
# ----------------------------
while true; do
    echo ""
    echo "1. Show system health"
    echo "2. Configure thresholds"
    echo "3. View logs"
    echo "4. Clear logs"
    echo "5. Start monitoring"
    echo "6. Exit"
    echo "Choose option:"
    read choice

    case $choice in
        1) show_health ;;
        2) configure ;;
        3) view_logs ;;
        4) clear_logs ;;
        5) start_monitor ;;
        6) exit 0 ;;
        *) echo "Invalid option" ;;
    esac
done