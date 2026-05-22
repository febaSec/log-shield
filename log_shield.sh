#!/bin/bash
#set -euo pipefail
trap 'echo "Error in the line $LINENO"' ERR

# Connecting resources
source "./src/tg_notify.sh"

# Checks for variables
[[ ! -f "$ACCESS_LOG" ]] && { echo "$(date '+%Y-%m-%d %H:%M:%S') [ERROR] The specified file [$ACCESS_LOG] not found." | tee -a "$LOG_FILE"; exit 1; }
[[ ! -f "$AUTH_LOG" ]] && { echo "$(date '+%Y-%m-%d %H:%M:%S') [ERROR] The specified file [$AUTH_LOG] not found." | tee -a "$LOG_FILE"; exit 1; }

# Check for blacklist
if [[ "$CLEAR_BLACKLIST" == "true" ]]; then
    > "$BLACKLIST_FILE"
fi

# Main logic
IFS="," read -r -a WHITELIST <<< "${WHITELIST:-127.0.0.1}"
adds_list=$(grep -P "401|403|etc/passwd|union|eval\(|script" "$ACCESS_LOG" | awk '{print $1}'; grep "Failed password" "$AUTH_LOG" | grep -oP "\d+\.\d+\.\d+\.\d+")
susp_count=0
while read -r count ip; do
	[[ -z "$count" ]] && continue

	is_whitelisted=false
	for white_ip in "${WHITELIST[@]}"; do
		if [[ "$white_ip" == "$ip" ]]; then
			is_whitelisted=true
			break
		fi
	done

	if [[ "$is_whitelisted" == "true" ]]; then
		continue
	fi

	if (( "$count" > "$MAX_ATTEMPTS" )); then
		if ! grep -q "$ip" "$BLACKLIST_FILE" 2>/dev/null; then 
			echo "$(date '+%Y-%m-%d %H:%M:%S') [WARNING] A suspicious address was found [$ip]. Adding to blacklist." >> "$LOG_FILE"
			echo "$ip" >> "$BLACKLIST_FILE"
		fi
		susp_count=$(( susp_count + 1 ))
	elif (( "$count" > 7 )); then
		echo "$(date '+%Y-%m-%d %H:%M:%S') [INFO] A suspicious address was found [$ip]. Monitoring..." >> "$LOG_FILE"
	fi
done < <(sort <<< "$adds_list" | uniq -c | sort -nr)

tg_notify "🛡️  Log-Shield report: found $susp_count suspicious address. The blacklist have been updated." 

