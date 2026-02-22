# Validation & Verification – Log Rotation Automation

## Objective

Confirm that the log rotation automation system functions correctly
and executes as scheduled.

This document outlines the validation steps performed.

---

## 1. Verify Launchd Job Loaded

Command:

launchctl list | grep logrotate

Expected Output:

com.devops.logrotate listed as active.

Purpose:

Confirms Launchd agent is registered and ready for execution.

---

## 2. Manual Script Execution Test

Command:

/bin/bash ~/devops-labs/logrotate-simple.sh >> ~/devops-labs/logrotate.log 2>&1

Purpose:

- Confirms script executes without error
- Confirms output logging works
- Validates rotation logic independently of scheduler

---

## 3. Inspect Execution Log

Command:

tail -n 10 ~/devops-labs/logrotate.log

Expected Example Output:

=== Log rotation started at ... ===
Processing: app.log
Rotating app.log ...
Old compressed logs removed.
Rotation complete.
=== Finished at ... ===

Purpose:

- Confirms script logic executed
- Confirms compression occurred
- Confirms cleanup logic ran
- Confirms no visible runtime errors

---

## 4. Confirm Log Rotation Behavior

After execution:

- Original `.log` file rotated
- New compressed `.gz` file created
- Retention limit enforced
- Old archives removed if necessary

Purpose:

Ensures full lifecycle behavior is functioning.

---

## Final Validation State

- Launchd scheduling verified
- Manual execution verified
- Rotation behavior confirmed
- Compression confirmed
- Retention enforcement validated
- Cleanup window validated
- Execution logging operational
