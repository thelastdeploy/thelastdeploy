#!/usr/bin/env bash
# ==============================================================================
# tests/run.sh — Master Test Suite Runner for The Last Deploy (TLD) CLI & Lab Scenarios
# ==============================================================================
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source core components
source "$SCRIPT_DIR/global_config.sh"
source "$CORE_DIR/ui_formatter.sh"
source "$CORE_DIR/cli_parser.sh"
source "$CORE_DIR/preflight.sh"
source "$CORE_DIR/container_harness.sh"
source "$CORE_DIR/report_aggregator.sh"

parse_cli_args "$@"

ui_banner
run_preflight
init_aggregator

# Always clean up active container on interrupt
trap 'harness_stop_lab; exit 130' INT TERM

# Discover tests under tests/labs
TEST_FILES=()
while IFS= read -r file; do
    [[ -n "$file" ]] && TEST_FILES+=("$file")
done < <(find "$LABS_DIR" -type f -name "*.sh" | sort)

if [[ ${#TEST_FILES[@]} -eq 0 ]]; then
    echo -e "${YELLOW}No test scripts found in $LABS_DIR${RESET}"
    exit 0
fi

# Filter tests based on user CLI arguments
MATCHED_TESTS=()
for tf in "${TEST_FILES[@]}"; do
    # Extract track, module, lab from path
    # Path pattern: .../tests/labs/<track>/<module>/<lab_dir>/positive/<file>.sh
    rel_path="${tf#$LABS_DIR/}"
    IFS='/' read -r track module lab_dir flow file <<< "$rel_path"

    # Filter checks
    if [[ -n "$FILTER_TRACK" && "$track" != *"$FILTER_TRACK"* ]]; then
        continue
    fi
    if [[ -n "$FILTER_MODULE" && "$module" != *"$FILTER_MODULE"* ]]; then
        continue
    fi
    norm_filter="${FILTER_LAB//_/-}"
    norm_tf="${tf//_/-}"
    if [[ -n "$FILTER_LAB" && "$norm_tf" != *"$norm_filter"* ]]; then
        continue
    fi

    MATCHED_TESTS+=("$tf")
done

if [[ ${#MATCHED_TESTS[@]} -eq 0 ]]; then
    echo -e "${YELLOW}No test cases matched your filter criteria.${RESET}"
    echo "  --track:  '$FILTER_TRACK'"
    echo "  --module: '$FILTER_MODULE'"
    echo "  --lab:    '$FILTER_LAB'"
    exit 1
fi

echo -e "${BOLD}Discovered ${#MATCHED_TESTS[@]} test case(s) to execute.${RESET}\n"

# Execute each matched test flow
TEST_INDEX=0
for test_script in "${MATCHED_TESTS[@]}"; do
    TEST_INDEX=$((TEST_INDEX + 1))
    rel_path="${test_script#$LABS_DIR/}"
    IFS='/' read -r track module lab_dir flow test_file <<< "$rel_path"

    # Read LAB_ID from test file
    lab_id=$(grep -E '^LAB_ID=' "$test_script" | head -n 1 | cut -d'"' -f2 | cut -d"'" -f2)
    [[ -z "$lab_id" ]] && lab_id="$lab_dir"

    CURRENT_TEST_LOG="$(mktemp)"
    echo "=== THE LAST DEPLOY TEST EXECUTION LOG ===" > "$CURRENT_TEST_LOG"
    echo "Test Case: $rel_path" >> "$CURRENT_TEST_LOG"
    echo "Track:     $track" >> "$CURRENT_TEST_LOG"
    echo "Module:    $module" >> "$CURRENT_TEST_LOG"
    echo "Lab ID:    $lab_id" >> "$CURRENT_TEST_LOG"
    echo "Timestamp: $(date '+%Y-%m-%d %H:%M:%S')" >> "$CURRENT_TEST_LOG"
    echo "=================================" >> "$CURRENT_TEST_LOG"

    start_sec=$(date +%s)
    test_passed=0
    fail_reason=""

    echo -e "${BOLD}[$TEST_INDEX/${#MATCHED_TESTS[@]}] RUNNING:${RESET} ${CYAN}$rel_path${RESET}"

    # 1. Start Lab Container in Non-Interactive Mode
    if harness_start_lab "$lab_id"; then
        # 2. Source the test script directly
        TEST_FAILED_STEPS=0
        set +e
        source "$test_script"
        script_exit=$?
        set -e
        if [[ $script_exit -eq 0 && ${TEST_FAILED_STEPS:-0} -eq 0 ]]; then
            test_passed=1
        else
            test_passed=0
            fail_reason="One or more intermediate student commands or assertions failed."
        fi
    else
        test_passed=0
        fail_reason="Failed to provision container for lab $lab_id."
    fi

    # 3. Stop container & clean up session
    harness_stop_lab

    end_sec=$(date +%s)
    duration=$(( end_sec - start_sec ))

    if [[ $test_passed -eq 1 ]]; then
        ui_lab_pass "$lab_id" "$duration"
        record_test_result "$track" "$module" "$lab_id" "$rel_path" "PASSED" "$duration" "$CURRENT_TEST_LOG"
    else
        ui_lab_fail "$lab_id" "$fail_reason" "$duration"
        record_test_result "$track" "$module" "$lab_id" "$rel_path" "FAILED" "$duration" "$CURRENT_TEST_LOG" "$fail_reason"
    fi

    rm -f "$CURRENT_TEST_LOG"
done

# Finalize summary JSON
finalize_aggregator

total_dur=$(( $(date +%s) - AGG_START_TIME ))
ui_summary_box "$AGG_TOTAL_TESTS" "$AGG_PASSED" "$AGG_FAILED" "$total_dur"

# Generate Master Regression HTML Dashboard
if [[ $GENERATE_HTML -eq 1 && -f "$REPORT_GENERATOR" ]]; then
    python3 "$REPORT_GENERATOR" "$SUMMARY_JSON"
fi

if [[ $AGG_FAILED -gt 0 ]]; then
    exit 1
fi
exit 0
