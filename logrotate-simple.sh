#!/bin/bash
# Simple log rotation script
# Author: Terrance Young
# Purpose: Rotate and compress old log files safely

echo "=== Log rotation started at $(date) ==="

# Configure settings in one place for ease
CONFIG_FILE="$HOME/devops-labs/logrotate.config"

# Load external config if it exists
if [ -f "$CONFIG_FILE" ]; then
	source "$CONFIG_FILE"
else
	LOG_DIR="$HOME/devops-labs/logs"
	RETENTION=5
	MIN_SIZE=1048576
	CLEANUP_DAYS=30

fi

# Step 1: Check that the log directory exists
if [ ! -d "$LOG_DIR" ]; then
	echo "Error: Directory $LOG_DIR not found!"
	echo "=== Finished at $(date) ==="
	exit 1
fi

# Step 2: Loop through all .log files
for LOG_FILE in  "$LOG_DIR"/*.log; do
	[ -e "$LOG_FILE" ] || continue
	echo "Rotating $LOG_FILE..."


	# Step 3: Only do logs less than 1 MB
	FILE_SIZE=$(stat -f%z "$LOG_FILE" 2>/dev/null || stat -c%s "$LOG_FILE")
	if [ "$FILE_SIZE" =lt "$MIN_SIZE" ]; then
		echo "Skipping $LOG_FILE (size ${FILE_SIZE} B < ${MIN_SIZE} B)"
		continue
	fi

	# Step 4: Shift older logs (rotate numbering)
	for i in $(seq $((RETENTION -1)) -1 1); do
		if [ -f "${LOG_FILE}.${i}.gz" ]; then
			mv "${LOG_FILE}.${i}.gz" "${LOG_FILE}.$((i + 1)).gz"
		fi

	# Step 5: Move and compress the current log
	mv "$LOG_FILE" "${LOG_FILE}.1"
	gzip -f "${LOG_FILE}.1"

	# Step 6: Delete the oldest if exceeding retention
	if [ -f "${LOG_FILE}.${RETENTION}.gz" ]; then
		rm -f "${LOG_FILE}.${RETENTION}.gz"
	fi

done

# Cleanup
find "$LOG_DIR" -type f -name "*.gz" -mtime +${CLEANUP_DAYS} -exec rm {} \;
echo "Old compressed logs (> ${CLEANUP_DAYS} days) removed."


# Health Check
if [ $? -ne 0 ]; then
	echo "Log rotation failed at $(date)" | mail -s "Log Rotation Failure" terrance@empowered901.com
fi

echo "Rotation complete for all logs."
echo "=== Finished at $(date) ==="
