# Launchd Configuration – Scheduled Execution

## Objective

Automate daily execution of the log rotation script using macOS Launchd.

---

## Agent File

Path:

~/Library/LaunchAgents/com.devops.logrotate.plist

---

## Purpose of Launchd

Launchd is the native macOS service manager and scheduler.

It allows:

- Scheduled task execution
- Background job management
- Persistent automation across reboots

---

## Configuration Details

The agent defines:

- Label: com.devops.logrotate
- Program: /bin/bash
- Script path: ~/devops-labs/logrotate-simple.sh
- Daily execution time: 00:00
- Standard output redirected to logrotate.log
- Standard error redirected to logrotate.log

---

## Load the Agent

```bash
launchctl load ~/Library/LaunchAgents/com.devops.logrotate.plist
