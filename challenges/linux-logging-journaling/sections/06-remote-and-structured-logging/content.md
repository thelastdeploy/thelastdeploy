# Remote and Structured JSON Logging

Traditional text logs require complex regex parsing. Modern cloud-native microservices generate **structured JSON logs**, enabling precise field filtering and centralized analysis.

## 1. Structured JSON Format

Each log entry is represented as a self-contained JSON object:

```json
{"timestamp": "2026-09-20T12:00:00Z", "level": "error", "service": "payment", "message": "Gateway timeout", "status_code": 504}
```

## 2. Parsing JSON Logs with `jq`

`jq` is a lightweight command-line JSON processor:

```bash
# Filter entries with level = error
cat app.json.log | jq 'select(.level == "error")'

# Extract only timestamps and messages
cat app.json.log | jq -r '[.timestamp, .message] | @tsv'
```

## 3. Remote Syslog Transport Overview

Enterprise environments ship logs over UDP/TCP port 514 using `rsyslog` or forwarders like Fluentd/Logstash to centralized SIEM platforms.
