#!/bin/ash

# Check if the LOG_FILE environment variable is set
if [ -z "$LOG_FILE" ]; then
  LOG_FILE="./logfile.log"  # Default log file in the current directory
else
  LOG_FILE="$LOG_FILE"     # Use the specified log file from the environment variable
fi

echo "Generating logs to file $LOG_FILE"

# Infinite loop to write the date to the log file every 10 seconds
while true; do
  date >> "$LOG_FILE"
  sleep 10
done