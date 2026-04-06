#!/bin/bash

# Function
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "https://api.telegram.org/bot$TG_TOKEN/getMe")
if [[ "$HTTP_CODE" != "200" ]]; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') [ERROR] API connection failed (HTTP $HTTP_CODE)" >> "$LOG_FILE"
fi

if ! curl -s -X POST "https://api.telegram.org/bot$TG_TOKEN/getMe" | jq -e ".ok" >/dev/null 2>&1; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') [ERROR] The telegram chat can't be achieved" >> "$LOG_FILE"
fi

function tg_notify() {
    local message="$1"
    curl -s -X POST "https://api.telegram.org/bot$TG_TOKEN/sendMessage" \
         --data-urlencode "chat_id=$CHAT_ID" \
         --data-urlencode "text=$message" >/dev/null
}
