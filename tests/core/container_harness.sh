#!/usr/bin/env bash
# ==============================================================================
# tests/core/container_harness.sh — Isolated student container execution harness
# ==============================================================================

# Global state for current running test
ACTIVE_CONTAINER_ID=""
ACTIVE_LAB_ID=""
STEP_INDEX=0
LAB_START_TIME=0

harness_get_session_file() {
    local dev_sess="${TLD_DIR:-$HOME/.tld-dev}/session.json"
    if [[ -f "$dev_sess" ]]; then
        echo "$dev_sess"
    else
        echo ""
    fi
}

harness_get_active_container() {
    local sess_file
    sess_file="$(harness_get_session_file)"
    if [[ -n "$sess_file" && -f "$sess_file" ]]; then
        python3 -c "import json; d=json.load(open('$sess_file')); print(d.get('container_id', ''))" 2>/dev/null || true
    fi
}

harness_start_lab() {
    local lab_id="$1"
    ACTIVE_LAB_ID="$lab_id"
    STEP_INDEX=0
    TEST_FAILED_STEPS=0
    LAB_START_TIME=$(date +%s)

    ui_section "Starting Lab Environment: $lab_id"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] >>> Starting lab '$lab_id' in non-interactive test mode" >> "$CURRENT_TEST_LOG"

    # Ensure no lingering containers or sessions exist
    harness_stop_lab >/dev/null 2>&1 || true

    local start_out
    start_out=$(TLD_NON_INTERACTIVE=1 "$CLI" start "$lab_id" 2>&1)
    local start_exit=$?
    echo "$start_out" >> "$CURRENT_TEST_LOG"

    if [[ $start_exit -ne 0 ]]; then
        ui_step_fail "Failed to start lab '$lab_id' (exit code $start_exit)"
        return 1
    fi

    # Read container ID from session file
    ACTIVE_CONTAINER_ID="$(harness_get_active_container)"
    if [[ -z "$ACTIVE_CONTAINER_ID" ]]; then
        # Fallback: check docker directly for devlab container
        ACTIVE_CONTAINER_ID=$(docker ps -q --filter "label=devlab.environment=true" | head -n 1)
    fi

    if [[ -z "$ACTIVE_CONTAINER_ID" ]]; then
        ui_step_fail "Could not find active Docker container for lab '$lab_id'"
        return 1
    fi

    echo -e "  ${GREEN}✓${RESET} Container active: ${DIM}$ACTIVE_CONTAINER_ID${RESET}"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Lab environment ready. Container: $ACTIVE_CONTAINER_ID" >> "$CURRENT_TEST_LOG"
    return 0
}

# student_exec: Simulates a student running a command inside the container
# Usage:
#   student_exec "command" [options]
# Options:
#   --desc "<description>"
#   --expect-exit <code>       (default 0)
#   --expect-stdout "<string>"
#   --expect-stderr "<string>"
#   --expect-stdout-regex "<regex>"
student_exec() {
    local cmd=""
    local desc=""
    local expect_exit=0
    local expect_stdout=""
    local expect_stderr=""
    local expect_stdout_regex=""

    # Support positional command as first argument if not a flag
    if [[ $# -gt 0 && "$1" != --* ]]; then
        cmd="$1"
        shift
    fi

    while [[ $# -gt 0 ]]; do
        case "$1" in
            --cmd)
                cmd="$2"
                shift 2
                ;;
            --desc|--step-name)
                desc="$2"
                shift 2
                ;;
            --expect-exit|--expect-exit-code)
                expect_exit="$2"
                shift 2
                ;;
            --expect-stdout)
                expect_stdout="$2"
                shift 2
                ;;
            --expect-stdout-contains)
                expect_stdout="$2"
                shift 2
                ;;
            --expect-stderr)
                expect_stderr="$2"
                shift 2
                ;;
            --expect-stdout-regex)
                expect_stdout_regex="$2"
                shift 2
                ;;
            *)
                shift
                ;;
        esac
    done

    STEP_INDEX=$((STEP_INDEX + 1))
    local step_title="${desc:-$cmd}"

    ui_step "$STEP_INDEX" "$step_title"
    ui_cmd "$cmd"

    echo "" >> "$CURRENT_TEST_LOG"
    echo "────────────────────────────────────────────────────────────" >> "$CURRENT_TEST_LOG"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] STEP $STEP_INDEX: $step_title" >> "$CURRENT_TEST_LOG"
    echo "$ $cmd" >> "$CURRENT_TEST_LOG"

    local stdout_file
    local stderr_file
    stdout_file="$(mktemp)"
    stderr_file="$(mktemp)"

    # Execute command inside container as standard student shell without letting caller set -e abort
    set +e
    docker exec -i -e XDG_RUNTIME_DIR=/run/user/0 -w /workspace "$ACTIVE_CONTAINER_ID" /bin/bash -c "$cmd" >"$stdout_file" 2>"$stderr_file"
    local actual_exit=$?
    set -e

    local actual_stdout
    local actual_stderr
    actual_stdout="$(cat "$stdout_file")"
    actual_stderr="$(cat "$stderr_file")"

    if [[ -n "$actual_stdout" ]]; then
        echo -e "[stdout]\n$actual_stdout" >> "$CURRENT_TEST_LOG"
    fi
    if [[ -n "$actual_stderr" ]]; then
        echo -e "[stderr]\n$actual_stderr" >> "$CURRENT_TEST_LOG"
    fi
    echo "Exit Code: $actual_exit" >> "$CURRENT_TEST_LOG"

    if [[ $VERBOSE -eq 1 ]]; then
        [[ -n "$actual_stdout" ]] && echo -e "${DIM}$actual_stdout${RESET}"
        [[ -n "$actual_stderr" ]] && echo -e "${RED}$actual_stderr${RESET}"
    fi

    local step_failed=0

    # Assertion 1: Exit Code
    if [[ $actual_exit -ne $expect_exit ]]; then
        ui_step_fail "Expected exit code $expect_exit, but got $actual_exit"
        echo "ASSERTION FAILED: Expected exit code $expect_exit, got $actual_exit" >> "$CURRENT_TEST_LOG"
        step_failed=1
    fi

    # Assertion 2: Expected Stdout substring
    if [[ $step_failed -eq 0 && -n "$expect_stdout" ]]; then
        if [[ "$actual_stdout" != *"$expect_stdout"* ]]; then
            ui_step_fail "Expected stdout to contain '$expect_stdout'"
            echo "ASSERTION FAILED: Missing stdout snippet: '$expect_stdout'" >> "$CURRENT_TEST_LOG"
            step_failed=1
        fi
    fi

    # Assertion 3: Expected Stdout Regex
    if [[ $step_failed -eq 0 && -n "$expect_stdout_regex" ]]; then
        if ! echo "$actual_stdout" | grep -Eq "$expect_stdout_regex"; then
            ui_step_fail "Stdout did not match regex: '$expect_stdout_regex'"
            echo "ASSERTION FAILED: Regex match failed: '$expect_stdout_regex'" >> "$CURRENT_TEST_LOG"
            step_failed=1
        fi
    fi

    # Assertion 4: Expected Stderr substring
    if [[ $step_failed -eq 0 && -n "$expect_stderr" ]]; then
        if [[ "$actual_stderr" != *"$expect_stderr"* ]]; then
            ui_step_fail "Expected stderr to contain '$expect_stderr'"
            echo "ASSERTION FAILED: Missing stderr snippet: '$expect_stderr'" >> "$CURRENT_TEST_LOG"
            step_failed=1
        fi
    fi

    if [[ $step_failed -eq 1 ]]; then
        TEST_FAILED_STEPS=$((TEST_FAILED_STEPS + 1))
        [[ -n "${TEST_STEP_FAIL_FLAG:-}" ]] && touch "$TEST_STEP_FAIL_FLAG"
        rm -f "$stdout_file" "$stderr_file"
        return 0
    fi

    ui_step_pass "Exit $actual_exit"
    rm -f "$stdout_file" "$stderr_file"
    return 0
}

harness_stop_lab() {
    if [[ -n "$ACTIVE_CONTAINER_ID" ]]; then
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Cleaning up container: $ACTIVE_CONTAINER_ID" >> "$CURRENT_TEST_LOG" 2>&1
        docker rm -f "$ACTIVE_CONTAINER_ID" >/dev/null 2>&1 || true
        ACTIVE_CONTAINER_ID=""
    fi

    # Stop CLI session cleanly
    "$CLI" stop >/dev/null 2>&1 || true

    # Clean dev session file
    rm -f "${TLD_DIR:-$HOME/.tld-dev}/session.json" >/dev/null 2>&1 || true
}
