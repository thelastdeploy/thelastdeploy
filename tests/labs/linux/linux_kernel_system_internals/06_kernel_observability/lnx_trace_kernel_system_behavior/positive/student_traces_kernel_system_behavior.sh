#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Traces Kernel System Behavior
# Lab: lnx-trace-kernel-system-behavior
# ==============================================================================

# Step 1: Ensure kernel-tracing directory exists
student_exec \
  --step-name "Ensure kernel-tracing directory exists" \
  --cmd "mkdir -p ~/kernel-tracing" \
  --expect-exit-code 0

# Step 2: Inspect tracing capabilities
student_exec \
  --step-name "Inspect available tracers" \
  --cmd "cat /sys/kernel/tracing/available_tracers 2>/dev/null || cat /sys/kernel/debug/tracing/available_tracers 2>/dev/null || true" \
  --expect-exit-code 0

# Step 3: Write trace analysis marker
student_exec \
  --step-name "Write trace analysis marker" \
  --cmd "echo 'KERNEL_TRACEFS_AND_FTRACE_EVENTS_EXAMINED' > ~/kernel-tracing/trace_analysis.log" \
  --expect-exit-code 0

# Step 4: Verify content of trace_analysis.log
student_exec \
  --step-name "Verify trace_analysis.log content" \
  --cmd "cat ~/kernel-tracing/trace_analysis.log" \
  --expect-exit-code 0 \
  --expect-stdout-contains "KERNEL_TRACEFS_AND_FTRACE_EVENTS_EXAMINED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Trace Kernel System Behavior verified successfully."
