# Title
Log-Shield

## Description
Log-Shield is a security-focused Bash script that proactively analyzes server logs to detect suspicious activity and common web exploits. It automatically identifies malicious IP addresses and generates a consolidated blacklist for further action.

## Key Features
- Multi-Source Analysis: Scans `access.log` for SQLi, XSS, and path traversal attempts.
- Brute-Force Detection: Monitors `auth.log` for failed SSH login attempts.
- Smart Filtering: Supports both global whitelists (to protect administrators) and duplicate entry prevention.
- Adaptive Thresholds: Define the number of attempts that trigger a ban vs. simple monitoring.
- Instant Reporting: Real-time Telegram alerts summarizing the threats detected during the scan.

## How it Works
1. Gathers IP addresses associated with failed logins or suspicious HTTP requests.
2. Cross-references detected entries with the `WHITELIST` to prevent accidental blocking.
3. If an IP exceeds the `MAX_ATTEMPTS` threshold, it is added to `blacklist.txt`.
4. Sends a security report to the administrator via Telegram.

## Installation
```bash
git clone https://github.com/febaSec/log-shield.git
cd log-shield
cp log_shield.conf.backup log_shield.conf
chmod +x log_shield.sh tg_notify.sh
```

## Configuration
Edit log_shield.conf to match your environment:

- `ACCESS_LOG`: Full path to your web server's access log.
- `AUTH_LOG`: Full path to the system authentication log.
- `CLEAR_BLACKLIST`:
	- `true`: The blacklist.txt file is refreshed (cleared) before each run.
	- `false`: New entries are appended to the existing list (Accumulation mode).
- `MAX_ATTEMPTS`: Number of suspicious events before an IP is blacklisted.
- `WHITELIST`: Array of trusted IP addresses that will never be blocked.
- `TG_TOKEN` & `CHAT_ID`: Your Telegram bot credentials.


## Usage
#### 1. Manual Execution
```shell
./log_shield.sh
```
> The script will analyze logs and output findings to the console, update the blacklist, and notify you via Telegram. Detailed events are saved in log_shield.log.

#### 2. Automation (Recommended)
Add this to your crontab to run the analyzer daily (or hourly):
```shell
0 0 * * * /path/to/log-shield/log_shield.sh > /dev/null 2>&1
```

## Example Output
###### Log file (log_shield.log):
```
2026-04-06 12:31:25 [WARNING] A suspicious address was found [192.168.1.100]. Adding to blacklist.
2026-04-06 12:31:25 [WARNING] A suspicious address was found [185.11.22.33]. Adding to blacklist.
```
###### Telegram Notification:
```
🛡️  Log-Shield report: found 2 suspicious address. The blacklist have been updated.
```

## Dependencies
- curl, jq, grep (with PCRE support)

## License
This project is licensed under the MIT License. For more information read LICENSE.
