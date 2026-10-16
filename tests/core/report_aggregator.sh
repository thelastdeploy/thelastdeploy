#!/usr/bin/env bash
# ==============================================================================
# tests/core/report_aggregator.sh — Aggregates test metrics into summary.json
# ==============================================================================

AGG_TOTAL_TESTS=0
AGG_PASSED=0
AGG_FAILED=0
AGG_START_TIME=0
RUN_REPORT_DIR=""
SUMMARY_JSON=""

init_aggregator() {
    # Keep only the latest report in tests/reports/
    RUN_REPORT_DIR="$REPORTS_DIR"
    rm -rf "$RUN_REPORT_DIR"/*
    mkdir -p "$RUN_REPORT_DIR/logs"

    SUMMARY_JSON="$RUN_REPORT_DIR/summary.json"
    AGG_START_TIME=$(date +%s)

    # Initialize empty summary JSON
    cat <<EOF > "$SUMMARY_JSON"
{
  "title": "The Last Deploy Automated Lab Regression Dashboard",
  "environment": "Docker Engine / Linux Container",
  "generated_at": "$(date '+%Y-%m-%d %H:%M:%S')",
  "total_test_cases": 0,
  "total_executed": 0,
  "total_passed": 0,
  "total_failed": 0,
  "pass_rate_pct": 0.0,
  "total_duration_sec": 0,
  "results": []
}
EOF
}

record_test_result() {
    local track="$1"
    local module="$2"
    local lab_id="$3"
    local test_path="$4"
    local status="$5"       # PASSED or FAILED
    local duration="$6"     # in seconds
    local log_file="$7"     # absolute path to test log
    local error_msg="${8:-}"

    AGG_TOTAL_TESTS=$((AGG_TOTAL_TESTS + 1))
    if [[ "$status" == "PASSED" ]]; then
        AGG_PASSED=$((AGG_PASSED + 1))
    else
        AGG_FAILED=$((AGG_FAILED + 1))
    fi

    # Copy log to run report directory
    local dest_log_name="${lab_id}_$(basename "$test_path" .sh).log"
    local dest_log_path="$RUN_REPORT_DIR/logs/$dest_log_name"
    cp "$log_file" "$dest_log_path"

    # Append test entry to summary.json using python helper
    python3 - <<PYEOF
import json

with open('$SUMMARY_JSON', 'r') as f:
    data = json.load(f)

entry = {
    "track": "$track",
    "module": "$module",
    "lab_id": "$lab_id",
    "test_path": "$test_path",
    "status": "$status",
    "duration_sec": int("$duration"),
    "log_file": "logs/$dest_log_name",
    "error_message": """$error_msg""".strip()
}

data["results"].append(entry)
data["total_test_cases"] = len(data["results"])
data["total_executed"] = len(data["results"])
data["total_passed"] = sum(1 for r in data["results"] if r["status"] == "PASSED")
data["total_failed"] = sum(1 for r in data["results"] if r["status"] == "FAILED")
data["pass_rate_pct"] = round((data["total_passed"] / data["total_executed"]) * 100, 1) if data["total_executed"] > 0 else 0.0

with open('$SUMMARY_JSON', 'w') as f:
    json.dump(data, f, indent=2)
PYEOF
}

finalize_aggregator() {
    local total_duration=$(( $(date +%s) - AGG_START_TIME ))

    python3 - <<PYEOF
import json

with open('$SUMMARY_JSON', 'r') as f:
    data = json.load(f)

data["total_duration_sec"] = int("$total_duration")

with open('$SUMMARY_JSON', 'w') as f:
    json.dump(data, f, indent=2)
PYEOF
}
