# Log-Shield 🛡️🐳 (Dockerized)

Log-Shield is a Dockerized log monitoring and intrusion detection tool built in Bash. It analyzes system and web server logs to detect suspicious behavior such as brute-force attempts, common web exploits, and repeated malicious requests, sending real-time Telegram alerts.

## 🌟 Why this Docker version?

### Zero-Dependency
Runs on any system with Docker support. No need to manually install `curl`, `jq`, or specific shell utilities.

### Containerized Isolation
The analyzer runs independently from the host environment, reducing dependency conflicts and keeping the monitoring stack self-contained.

### Portable
Works consistently across Linux distributions and Docker-enabled environments.

---

## 🚀 Quick Start

### Clone the repository

```bash
git clone https://github.com/febaSec/log-shield.git
cd log-shield
```

### Configure Telegram credentials

Create your environment file:

```bash
cp .env.example .env
nano .env
```

Add your:

- `TG_TOKEN`
- `CHAT_ID`

### Run Log-Shield

```bash
docker compose up --build
```

---

## ⚙️ Configuration

Configure behavior through `.env` or `docker-compose.yml`.

### Core Settings

- `MAX_ATTEMPTS` — Number of suspicious hits before flagging an IP (default: `10`)
- `WHITELIST` — Comma-separated IP addresses to ignore
- `CLEAR_BLACKLIST` — Reset the blacklist on each execution (`true/false`)

---

## 📊 Log Sources

By default, Log-Shield uses mock logs for safe testing.

To analyze real logs, map them into the container in `docker-compose.yml`:

```yaml
volumes:
  - /var/log/nginx:/logs/nginx:ro
  - /var/log/auth.log:/logs/auth.log:ro
```

Example monitored sources:

- Nginx access/error logs
- Authentication logs (`auth.log`)
- Failed login attempts
- Repeated suspicious requests

---

## 🔍 Features

- Suspicious IP detection
- Brute-force attempt monitoring
- Web exploit pattern detection
- Telegram notifications
- IP blacklist generation
- Dockerized execution
- Read-only log access (`:ro`)

---

## 🛠️ Stack

- Bash
- Docker / Docker Compose
- Grep / Awk / Sed
- Curl
- JQ
- Telegram Bot API

---

## 📁 Project Structure

```text
.
├── data
├── docker-compose.yml
├── docker-compose.yml.save
├── Dockerfile
├── LICENSE
├── log_shield.sh
├── README.md
└── src
    ├── colors.env
    ├── init.sh
    ├── tg_creds.env
    └── tg_notify.sh
```

---

## 📈 Results

### Blacklist

Detected suspicious IP addresses:

```text
./data/blacklist.txt
```

### Audit Log

Execution history and detection details:

```text
./data/log_shield.log
```

### Telegram Alerts

Receive instant notifications when suspicious activity is detected.

---

## 📋 Requirements

- Docker & Docker Compose
- Access to server log files
- Telegram Bot Token & Chat ID

---

## 📄 License

This project is licensed under the MIT License.  
For more information, see `LICENSE`.
