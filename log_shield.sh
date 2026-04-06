#!/bin/bash
set -euo pipefail

# Connecting resources
source log_shield.conf
source tg_notify.sh


# CHECKS BLOCK
# Dependencies
for cmd in curl jq; do
	command -v "$cmd" >/dev/null 2>&1 || { echo "Error: $cmd not found"; exit 1; }
done


# Checks for variables
[[ ! -f "$ACCESS_LOG" ]] && { echo "$(date '+%Y-%m-%d %H:%M:%S') [ERROR] The specified file [$ACCESS_LOG] not found." | tee "$LOG_FILE"; exit 1; }
[[ ! -f "$AUTH_LOG" ]] && { echo "$(date '+%Y-%m-%d %H:%M:%S') [ERROR] The specified file [$ACCESS_LOG] not found." | tee "$LOG_FILE"; exit 1; }

# Logic block
if [[ "${CLEAR_BLACKLIST:-true}" == "true" ]]; then
    > blacklist.txt
fi
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
		if ! grep -q "$ip" blacklist.txt 2>/dev/null; then 
			echo "$(date '+%Y-%m-%d %H:%M:%S') [WARNING] A suspicious address was found [$ip]. Adding to blacklist." >> "$LOG_FILE"
			echo "$ip" >> blacklist.txt
		fi
		susp_count=$(( susp_count + 1 ))
	elif (( "$count" > 7 )); then
		echo "$(date '+%Y-%m-%d %H:%M:%S') [INFO] A suspicious address was found [$ip]. Monitoring..." >> "$LOG_FILE"
	fi
done < <(sort <<< "$adds_list" | uniq -c | sort -nr)

tg_notify "🛡️  Log-Shield report: found $susp_count suspicious address. The blacklist have been updated." 
