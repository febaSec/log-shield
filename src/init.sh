#!/usr/bin/env bash

source "./colors.env"

if [[ ! -d /app/data ]]; then
    echo "${RED}[ERROR] Missing /app/data directory.${NC}"
    echo "${CYAN}Please create local './data' directory before running docker compose.${NC}"
    exit 1
fi

touch /app/data/blacklist.txt
touch /app/data/log_shield.log

exec /app/log_shield.sh
