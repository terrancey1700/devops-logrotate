# Log Rotation Script – Implementation Details

## Script Name

logrotate-simple.sh

## Purpose

Implements automated rotation, compression, retention enforcement,
and cleanup of `.log` files.

---

## Core Workflow

1. Load optional configuration file
2. Validate log directory exists
3. Loop through `.log` files
4. Check file size using `stat`
5. Skip files below minimum threshold
6. Rotate file using `mv`
7. Compress rotated file using `gzip`
8. Enforce retention policy
9. Remove `.gz` files older than configured cleanup days
10. Write execution status to `logrotate.log`

---

## Key Commands Used

### File Size Validation

stat

Used to determine whether file meets `MIN_SIZE` threshold.

---

### Rotation

mv app.log app.log.1

Renames active log file.

---

### Compression

gzip app.log.1

Reduces disk usage by compressing rotated logs.

---

### Retention Enforcement

rm

Removes oldest archives when retention count is exceeded.

---

### Age-Based Cleanup

find "$LOG_DIR" -name "*.gz" -mtime +$CLEANUP_DAYS -exec rm {} \;

Deletes compressed logs older than defined age.

---

## Output Logging

All execution status written to:

logrotate.log

Provides traceability and troubleshooting visibility.

---

## Final State

- Script executes without manual intervention
- Large logs are rotated
- Archives compressed
- Retention limits enforced
- Old archives cleaned automatically
