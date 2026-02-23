# Log Rotation Automation

Automated log rotation, compression, and retention enforcement on macOS using Bash scripting and Launchd scheduling.

**Author:** Terrance Young  
**Purpose:** Automatically rotate, compress, and clean up server logs using a Bash script and Launchd scheduler.

---

## Executive Summary

### Situation

In production-style environments, logs grow continuously. If logs are unmanaged:

- Disks can fill unexpectedly
- System performance can degrade
- Services can fail due to storage exhaustion
- Old logs accumulate without a retention policy

Manual cleanup is inconsistent and does not scale.

---

### Task

Design and implement an automated log lifecycle workflow that:

- Rotates `.log` files daily
- Skips log files smaller than a minimum size threshold
- Compresses rotated logs to save disk space
- Enforces a retention limit (keep last N archives)
- Deletes compressed logs older than a defined number of days
- Writes execution output to a local status log
- Runs automatically on a schedule using native macOS tooling
- Optionally alerts on failure

---

### Action

#### Phase 1 — Script Development (Rotation, Compression, Retention)

Built a Bash script that:

- Checks for an optional configuration file
- Verifies the log directory exists
- Loops through `.log` files
- Uses `stat` to check file size
- Skips files smaller than the minimum size threshold
- Rotates log files using `mv`
- Compresses rotated logs using `gzip`
- Enforces retention by removing oldest archives beyond the limit
- Cleans up `.gz` files older than the configured age using `find`
- Writes status output to `logrotate.log`
- Sends an optional email alert using `mail` if a failure occurs

---

#### Phase 2 — Configuration File (Optional)

Created an optional configuration file to separate tuning from script logic.

Path:

`~/devops-labs/logrotate.config`

Example:

- `LOG_DIR="$HOME/devops-labs/logs" 
- `RETENTION=5`
- `MIN_SIZE=1048576-
- `CLEANUP_DAYS=30`

Benefits:
- `Separates logic from configuration`
- `Allows tuning without modifying the script`
- `Improves maintainability and reusability`

---

#### Phase 3 — Scheduling with Launchd

Implemented automated scheduling using Launchd.

Created agent file:

~/Library/LaunchAgents/com.devops.logrotate.plist

Configured:
- `Daily execution at 00:00`
- `Script invocation via /bin/bash`
- `Standard output and error redirected to logrotate.log`

Load and verify job:
- `launchctl load ~/Library/LaunchAgents/com.devops.logrotate.plist`
- `launchctl list | grep logrotate`

Manual test:
- `/bin/bash ~/devops-labs/logrotate-simple.sh >> ~/devops-labs/logrotate.log 2>&1`

---

### Result

The final system:
- `Rotates large logs automatically on a daily schedule`
- `Compresses rotated logs to reduce disk usage`
- `Enforces retention limits to prevent archive buildup`
- `Deletes stale compressed logs older than the cleanup window`
- `Writes a local execution log for traceability`
- `Reduces the risk of disk exhaustion and service interruptions`

--- 

### Architecture Overview

Log Files (.log)
      ↓
Bash Script
  - Validate config
  - Validate log directory
  - Size check (stat)
  - Rotate (mv)
  - Compress (gzip)
  - Retention cleanup (rm)
  - Age cleanup (find)
      ↓
Execution Log (logrotate.log)
      ↓
Launchd Scheduler (Daily @ 00:00)

### Technologies Used
- `Bash`
- `Launchd (macOS scheduler)`
- `gzip`
- `find`
- `stat`
- `mv`
- `rm`
- `echo`
- `mail (optional)`

### Skills Demonstrated
- `Shell scripting and automation logic`
- `File system lifecycle management`
- `Retention policy enforcement`
- `Compression and cleanup automation`
- `Scheduler configuration with Launchd`
- `Operational logging for traceability`

### Future Improvements
- `Add a Linux version using systemd timers`
- `Add a dry-run mode for safe testing`
- `Add structured logging output (JSON)`
- `Add webhook/Slack alerting instead of email`
- `Add a small test harness to validate behavior`

### Project Status
Operational on macOS.
- `Launchd job loads successfully`
- `Manual test execution produces expected output`
- `Rotation, compression, retention, and cleanup logic verified via logrotate.log`

---

### Why this will render correctly now
- Every phase is a real Markdown header (`#### Phase 3 — ...`)
- Code blocks are clean (no `id="..."`, no broken fences)
- No HTML/plist mixed into the config code fence
