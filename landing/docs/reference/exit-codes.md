---
title: "CLI Exit Codes Reference"
description: "Reference table of process exit status codes returned by the tld binary."
section: "Reference"
---

## Process Exit Status Codes

The `tld` CLI binary returns standard POSIX exit status codes so shell scripts and CI pipelines can programmatically check execution results.

```text
echo $?
```

| Exit Code | Constant / Identifier | Description & Recovery |
| :--- | :--- | :--- |
| `0` | `SUCCESS` | Command completed without error, or `tld check` verified 100% of lab assertions. |
| `1` | `GENERAL_ERROR` | Unhandled error (invalid flags, missing lab files, unexpected backend API error). |
| `2` | `VALIDATION_FAILED` | `tld check` ran validation script, but one or more test assertions failed. Inspect output for details. |
| `3` | `DOCKER_ERROR` | Failed to connect to local Docker daemon `/var/run/docker.sock` or image pull failed. |
| `4` | `AUTH_REQUIRED` | Command requires authentication, but no valid JWT token was found in `~/.tld/config.json`. Run `tld login`. |
| `5` | `LAB_NOT_FOUND` | Specified lab slug does not exist in local registry or remote API index. |

---

## Scripting Usage Example

```bash
# Start lab and check status programmatically
tld lab start linux-file-permissions
# ... apply solution fix ...

tld check
STATUS=$?

if [ $STATUS -eq 0 ]; then
    echo "Lab completed successfully!"
elif [ $STATUS -eq 2 ]; then
    echo "Validation failed. Check file permissions again."
elif [ $STATUS -eq 3 ]; then
    echo "Docker engine is not running."
    tld doctor
fi
```