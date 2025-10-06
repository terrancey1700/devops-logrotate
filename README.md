# Log Rotation Automation  
**Author:** Terrance Young  
**Purpose:** Automatically rotate, compress, and clean up server logs using a Bash script and Launchd scheduler.

---

## Overview

This project automates log rotation on macOS using:
- **Bash scripting** for logic and file handling  
- **Launchd** for daily scheduling  
- **gzip** for compression  
- **find** for cleanup of old logs  

---

## Why This Project Exists

In production systems, logs grow continuously.  
Unmanaged logs can:
- Fill up storage drives  
- Reduce system performance  
- Cause service interruptions  

This automation ensures:
- Logs are rotated daily  
- Old files are compressed  
- Disk space remains under control  
- Old archives are deleted after a defined retention period  

---

## How It Works

| Step | Action | Tool |
|------|---------|------|
| 1 | Check for configuration file | Bash |
| 2 | Verify the log directory exists | Bash |
| 3 | Loop through `.log` files | Bash |
| 4 | Skip files smaller than 1 MB | stat |
| 5 | Rotate and compress old logs | mv, gzip |
| 6 | Remove oldest archives beyond retention | rm |
| 7 | Clean up `.gz` files older than 30 days | find |
| 8 | Write status to `logrotate.log` | echo |
| 9 | Send optional email alert if failure occurs | mail |

---

## File Structure


---

## Configuration File (Optional)

Path: `~/devops-labs/logrotate.config`

```bash
LOG_DIR="$HOME/devops-labs/logs"
RETENTION=5
MIN_SIZE=1048576
CLEANUP_DAYS=30


<plist version="1.0">
  <dict>
    <key>Label</key><string>com.devops.logrotate</string>
    <key>ProgramArguments</key>
    <array>
      <string>/bin/bash</string>
      <string>/Users/terranceyoung/devops-labs/logrotate-simple.sh</string>
    </array>
    <key>StartCalendarInterval</key>
    <dict>
      <key>Hour</key><integer>0</integer>
      <key>Minute</key><integer>0</integer>
    </dict>
    <key>StandardOutPath</key><string>/Users/terranceyoung/devops-labs/logrotate.log</string>
    <key>StandardErrorPath</key><string>/Users/terranceyoung/devops-labs/logrotate.log</string>
  </dict>
</plist>

Load and Verify Job:
launchctl load ~/Library/LaunchAgents/com.devops.logrotate.plist
launchctl list | grep logrotate

Expected output:
-   0   com.devops.logrotate

Manual test:
/bin/bash ~/devops-labs/logrotate-simple.sh >> ~/devops-labs/logrotate.log 2>&1

Verify output:
tail -n 10 ~/devops-labs/logrotate.log

Expected output example:
=== Log rotation started at Mon Oct 6 18:45:01 CDT 2025 ===
Processing: /Users/terranceyoung/devops-labs/logs/app.log
Rotating /Users/terranceyoung/devops-labs/logs/app.log ...
Old compressed logs (>30 days) removed.
Rotation complete for all logs.
=== Finished at Mon Oct 6 18:45:02 CDT 2025 ===

