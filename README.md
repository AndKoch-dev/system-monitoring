# 🖥️ System Monitoring Script

A simple Linux server monitoring project written in **Bash**.  
The script collects system metrics (CPU, RAM, Disk, Uptime), stores them in log files, and sends email alerts when thresholds are exceeded.

## 📌 Features
- Monitor:
  - **CPU load**
  - **RAM usage**
  - **Disk usage**
  - **System uptime**
- Logs metrics into files
- Stores triggered alerts separately
- Email notifications with anti-spam interval
- Automatic cleanup of logs older than 7 days
- Cron-ready for full automation

---

## 📂 Project Structure
```
system-monitoring/
├── config.conf                # Configuration (thresholds, email, paths)
├── monitor.sh                 # Main script
├── reports/                   # Reports and logs
│   ├── attempt/               # Triggered alerts
│   ├── cron_report/           # Cron job reports
│   └── logs/                  # Monitoring logs
```

---

## ⚙️ Installation & Setup
1. Clone the repository:
   ```bash
   git clone https://github.com/<your-username>/system-monitoring.git
   cd system-monitoring
   ```

2. Make the script executable:
   ```bash
   chmod +x monitor.sh
   ```

3. Configure `config.conf`:
   ```bash
   # limits
   cpu_max_load=70
   ram_max=80
   disk_max=85

   # notifications
   recipient="youremail@example.com"
   alert_interval=$((30*60))  # 30 minutes

   # logs
   logdir="$HOME/system-monitoring"
   ```

4. Test run:
   ```bash
   ./monitor.sh
   ```

---

## ⏰ Cron Automation
To run every 15 minutes, edit cron:
```bash
crontab -e
```
and add:
```bash
*/15 * * * * /bin/bash /home/<user>/system-monitoring/monitor.sh >> /home/<user>/system-monitoring/reports/cron_report/cron_report.log 2>&1
```

---

## 📨 Email Notifications
- Uses the `mail` command
- Install package:
  ```bash
  sudo apt install mailutils
  ```
- Ensure your system has an MTA configured (Postfix / ssmtp / sendmail)

---

## 🧹 Log Rotation
Old `.log` files are automatically deleted:
- Retention: **7 days**
- Path: `$logdir/reports/logs`

---

## 📜 Sample Log
```
Timestamp          | CPU | RAM | DISK | UPTIME
2025-09-24_15-30   | 23% | 55% | 44%  | up 2 hours, 15 minutes
2025-09-24_15-45   | 88% | 82% | 44%  | up 2 hours, 30 minutes
```

---

## 🚀 Future Improvements
- Metrics visualization (Grafana + Prometheus)
- Slack/Telegram integration
- Docker image for easy deployment

---

## 👨‍💻 Author
**Ando Kocharyan**  
DevOps Junior Portfolio Project
