#!/bin/bash

# ==========================================================
# Project 2: Linux Server Health Monitoring and Alert Script
# ==========================================================

LOG_FILE="server_health.log"
CONFIG_FILE="monitor_config.conf"
MONITOR_PID_FILE=".monitor.pid"

# -----------------------------
# Load configuration
# -----------------------------
load_config() {
    if [ -f "$CONFIG_FILE" ]; then
        source "$CONFIG_FILE"
    else
        CPU_THRESHOLD=80
        MEM_THRESHOLD=80
        DISK_THRESHOLD=90
        INTERVAL=60
    fi
}

# -----------------------------
# Save configuration
# -----------------------------
save_config() {
    cat > "$CONFIG_FILE" <<EOF
CPU_THRESHOLD=$CPU_THRESHOLD
MEM_THRESHOLD=$MEM_THRESHOLD
DISK_THRESHOLD=$DISK_THRESHOLD
INTERVAL=$INTERVAL
EOF
    echo "Configuration saved successfully."
}

# -----------------------------
# Log message with timestamp
# -----------------------------
log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

# -----------------------------
# Check required commands
# -----------------------------
check_dependencies() {
    local commands=("top" "free" "df" "ps" "awk" "grep" "sleep")
    for cmd in "${commands[@]}"; do
        if ! command -v "$cmd" >/dev/null 2>&1; then
            echo "Error: Required command '$cmd' is missing."
            exit 1
        fi
    done
}

# -----------------------------
# Validate numeric input
# -----------------------------
is_number() {
    [[ "$1" =~ ^[0-9]+$ ]]
}

# -----------------------------
# Get CPU usage percentage
# -----------------------------
get_cpu_usage() {
    local idle
    idle=$(top -bn1 | grep "Cpu(s)" | awk '{print $8}' | cut -d. -f1)

    if [ -z "$idle" ]; then
        echo 0
    else
        echo $((100 - idle))
    fi
}

# -----------------------------
# Get memory usage percentage
# -----------------------------
get_memory_usage() {
    free | awk '/Mem:/ {printf "%.0f", ($3/$2)*100}'
}

# -----------------------------
# Get root disk usage percentage
# -----------------------------
get_disk_usage() {
    df / | awk 'NR==2 {gsub("%","",$5); print $5}'
}

# -----------------------------
# Get number of active processes
# -----------------------------
get_active_processes() {
    ps -e --no-headers | wc -l
}

# -----------------------------
# Display system health
# -----------------------------
display_health() {
    local cpu mem disk processes

    cpu=$(get_cpu_usage)
    mem=$(get_memory_usage)
    disk=$(get_disk_usage)
    processes=$(get_active_processes)

    echo "================================================"
    echo "         LINUX SERVER HEALTH DASHBOARD          "
    echo "================================================"
    echo "CPU Usage        : ${cpu}%"
    echo "Memory Usage     : ${mem}%"
    echo "Disk Usage       : ${disk}%"
    echo "Active Processes : ${processes}"
    echo "================================================"

    log_message "HEALTH CHECK | CPU=${cpu}% MEM=${mem}% DISK=${disk}% PROCESSES=${processes}"
}

# -----------------------------
# Check thresholds and alert
# -----------------------------
check_alerts() {
    local cpu mem disk
    cpu=$(get_cpu_usage)
    mem=$(get_memory_usage)
    disk=$(get_disk_usage)

    if [ "$cpu" -gt "$CPU_THRESHOLD" ]; then
        echo "WARNING: CPU usage exceeded threshold (${cpu}% > ${CPU_THRESHOLD}%)"
        log_message "ALERT | CPU usage exceeded threshold (${cpu}% > ${CPU_THRESHOLD}%)"
    fi

    if [ "$mem" -gt "$MEM_THRESHOLD" ]; then
        echo "WARNING: Memory usage exceeded threshold (${mem}% > ${MEM_THRESHOLD}%)"
        log_message "ALERT | Memory usage exceeded threshold (${mem}% > ${MEM_THRESHOLD}%)"
    fi

    if [ "$disk" -gt "$DISK_THRESHOLD" ]; then
        echo "WARNING: Disk usage exceeded threshold (${disk}% > ${DISK_THRESHOLD}%)"
        log_message "ALERT | Disk usage exceeded threshold (${disk}% > ${DISK_THRESHOLD}%)"
    fi
}

# -----------------------------
# Configure thresholds
# -----------------------------
configure_thresholds() {
    local cpu_input mem_input disk_input interval_input

    echo -n "Enter CPU threshold (%): "
    read -r cpu_input
    if is_number "$cpu_input" && [ "$cpu_input" -ge 1 ] && [ "$cpu_input" -le 100 ]; then
        CPU_THRESHOLD=$cpu_input
    else
        echo "Invalid CPU threshold. Keeping old value: $CPU_THRESHOLD"
    fi

    echo -n "Enter Memory threshold (%): "
    read -r mem_input
    if is_number "$mem_input" && [ "$mem_input" -ge 1 ] && [ "$mem_input" -le 100 ]; then
        MEM_THRESHOLD=$mem_input
    else
        echo "Invalid Memory threshold. Keeping old value: $MEM_THRESHOLD"
    fi

    echo -n "Enter Disk threshold (%): "
    read -r disk_input
    if is_number "$disk_input" && [ "$disk_input" -ge 1 ] && [ "$disk_input" -le 100 ]; then
        DISK_THRESHOLD=$disk_input
    else
        echo "Invalid Disk threshold. Keeping old value: $DISK_THRESHOLD"
    fi

    echo -n "Enter monitoring interval in seconds: "
    read -r interval_input
    if is_number "$interval_input" && [ "$interval_input" -gt 0 ]; then
        INTERVAL=$interval_input
    else
        echo "Invalid interval. Keeping old value: $INTERVAL"
    fi

    save_config
    log_message "SETTINGS UPDATED | CPU=$CPU_THRESHOLD MEM=$MEM_THRESHOLD DISK=$DISK_THRESHOLD INTERVAL=${INTERVAL}s"
}

# -----------------------------
# View log file
# -----------------------------
view_logs() {
    if [ -f "$LOG_FILE" ]; then
        cat "$LOG_FILE"
    else
        echo "No logs found yet."
    fi
}

# -----------------------------
# Clear log file
# -----------------------------
clear_logs() {
    > "$LOG_FILE"
    echo "Logs cleared successfully."
    log_message "LOG FILE CLEARED"
}

# -----------------------------
# Continuous monitoring function
# -----------------------------
monitor_loop() {
    log_message "MONITORING STARTED"
    while true; do
        display_health
        check_alerts
        sleep "$INTERVAL"
    done
}

# -----------------------------
# Start monitoring in background
# -----------------------------
start_monitoring() {
    if [ -f "$MONITOR_PID_FILE" ]; then
        local old_pid
        old_pid=$(cat "$MONITOR_PID_FILE")
        if ps -p "$old_pid" >/dev/null 2>&1; then
            echo "Monitoring is already running with PID $old_pid."
            return
        else
            rm -f "$MONITOR_PID_FILE"
        fi
    fi

    monitor_loop &
    echo $! > "$MONITOR_PID_FILE"
    echo "Monitoring started in background. PID: $(cat "$MONITOR_PID_FILE")"
}

# -----------------------------
# Stop monitoring
# -----------------------------
stop_monitoring() {
    if [ -f "$MONITOR_PID_FILE" ]; then
        local pid
        pid=$(cat "$MONITOR_PID_FILE")

        if ps -p "$pid" >/dev/null 2>&1; then
            kill "$pid"
            rm -f "$MONITOR_PID_FILE"
            echo "Monitoring stopped successfully."
            log_message "MONITORING STOPPED"
        else
            echo "No active monitoring process found."
            rm -f "$MONITOR_PID_FILE"
        fi
    else
        echo "Monitoring is not running."
    fi
}

# -----------------------------
# Show current thresholds
# -----------------------------
show_settings() {
    echo "Current Settings:"
    echo "CPU Threshold    : ${CPU_THRESHOLD}%"
    echo "Memory Threshold : ${MEM_THRESHOLD}%"
    echo "Disk Threshold   : ${DISK_THRESHOLD}%"
    echo "Interval         : ${INTERVAL} seconds"
}

# -----------------------------
# Main menu
# -----------------------------
main_menu() {
    while true; do
        echo
        echo "============== MAIN MENU =============="
        echo "1. Display current system health"
        echo "2. Configure monitoring thresholds"
        echo "3. Show current settings"
        echo "4. View activity logs"
        echo "5. Clear logs"
        echo "6. Start monitoring"
        echo "7. Stop monitoring"
        echo "8. Exit"
        echo "======================================="
        echo -n "Choose an option: "
        read -r choice

        case "$choice" in
            1)
                display_health
                check_alerts
                ;;
            2)
                configure_thresholds
                ;;
            3)
                show_settings
                ;;
            4)
                view_logs
                ;;
            5)
                clear_logs
                ;;
            6)
                start_monitoring
                ;;
            7)
                stop_monitoring
                ;;
            8)
                echo "Exiting program."
                exit 0
                ;;
            *)
                echo "Invalid choice. Please enter a number from 1 to 8."
                ;;
        esac
    done
}

# -----------------------------
# Run the program
# -----------------------------
load_config
check_dependencies
main_menu