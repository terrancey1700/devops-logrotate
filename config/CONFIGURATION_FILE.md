# Configuration File – logrotate.config

## Objective

Allow tuning of log rotation behavior without modifying the main script.

The configuration file separates operational parameters from script logic.

---

## File Location

~/devops-labs/logrotate.config

---

## Example Configuration

```bash
LOG_DIR="$HOME/devops-labs/logs"
RETENTION=5
MIN_SIZE=1048576
CLEANUP_DAYS=30
