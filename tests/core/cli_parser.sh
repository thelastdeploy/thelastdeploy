#!/usr/bin/env bash
# ==============================================================================
# tests/core/cli_parser.sh — Argument parser for the test runner
# ==============================================================================

parse_cli_args() {
    FILTER_TRACK=""
    FILTER_MODULE=""
    FILTER_LAB=""
    RUN_ALL=0
    GENERATE_HTML=1
    VERBOSE=0

    while [[ $# -gt 0 ]]; do
        case "$1" in
            --track|-t)
                FILTER_TRACK="$2"
                shift 2
                ;;
            --module|-m)
                FILTER_MODULE="$2"
                shift 2
                ;;
            --lab|-l)
                FILTER_LAB="$2"
                shift 2
                ;;
            --all|-a)
                RUN_ALL=1
                shift
                ;;
            --no-html)
                GENERATE_HTML=0
                shift
                ;;
            --verbose|-v)
                VERBOSE=1
                shift
                ;;
            --help|-h)
                show_help
                exit 0
                ;;
            *)
                echo "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
    done
}

show_help() {
    echo "Usage: ./tests/run.sh [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --track, -t <name>     Run tests for a specific technology track (e.g. 'linux')"
    echo "  --module, -m <name>    Run tests for a specific module (e.g. 'linux_fundamentals')"
    echo "  --lab, -l <id>         Run tests for a single specific lab ID (e.g. 'lnx-open-terminal')"
    echo "  --all, -a              Run all discovered lab tests"
    echo "  --no-html              Skip generating the master HTML regression dashboard"
    echo "  --verbose, -v          Show raw stdout/stderr of executed commands in realtime"
    echo "  --help, -h             Display this help message"
    echo ""
    echo "Examples:"
    echo "  ./tests/run.sh --lab lnx-open-terminal"
    echo "  ./tests/run.sh --module linux_fundamentals"
    echo "  ./tests/run.sh --track linux"
}
