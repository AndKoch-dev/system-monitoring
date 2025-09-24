#!/bin/bash

source "$(dirname "$0")/config.conf"

mkdir -p "$logdir/reports/logs" "$logdir/reports/attempt" "$logdir/reports/cron_report"


logfile="$logdir/reports/logs/monitor_$(date +%F_%H-%M).log"
atpfile="$logdir/reports/attempt/attempt_$(date +%F_%H-%M).atp"
alertstamp="$logdir/.last_alert"

cores=$(nproc)

if [ ! -s "$logfile" ]; then
echo "Timestamp | CPU | RAM | DISK | UPTIME" >> "$logfile"
fi

if [ ! -s "$atpfile" ]; then
echo "Timestamp | CPU | RAM | DISK" >> "$atpfile"
fi

timestamp=$(date +%F_%H-%M)

cpu_load=$(/usr/bin/uptime | awk -F'load average:' '{ print $2 }' | cut -d ',' -f1 | xargs )

ram_load=$(/usr/bin/free -m | awk '/Mem:/ { printf("%.0f" , $3/$2*100) }')

disk_load=$(/bin/df -h / | awk 'NR==2 {printf "%.0f" , $5}')

up=$(uptime -p)

cpu_int_load=$(echo "$cpu_load / $cores *100" | bc -l | xargs printf "%.0f")

last_alert=0
if [ -f "$alertstamp" ]; then
  last_alert=$(cat "$alertstamp")
fi
now=$(date +%s)

send_alert() {
 if (( now - last_alert >= alert_interval )); then
      echo "$timestamp/$up | ALERT: $1 $2%" | mail -s "ALERT: $1" "$recipient" 2>> "$logdir/mail_error.log"
      echo "$now" > "$alertstamp"
 fi
}

if [ "$cpu_int_load" -gt "$cpu_max_load" ]; then
 echo "$timestamp/$up | ALERT: CPU load $cpu_int_load%" | tee -a "$atpfile"
 send_alert "CPU load" "$cpu_int_load"
fi

if [ "$ram_load" -gt "$ram_max" ]; then
 echo "$timestamp/$up | ALERT: RAM usage $ram_load%" | tee -a "$atpfile"
 send_alert "RAM usage" "$ram_load"
fi

if [ "$disk_load" -gt "$disk_max" ]; then
 echo "$timestamp/$up | ALERT: DISK usage $disk_load%" | tee -a "$atpfile"
 send_alert "DISK usage" "$disk_load"
fi

echo "$timestamp | CPU: ${cpu_int_load}% | RAM: ${ram_load}% | DISK: ${disk_load}% | UPTIME: $up" >> "$logfile"

find "$logdir" -type f -name "*.log" -mtime +7 -delete


