# Exit Codes and Error Handling

Every Linux command produces an exit code (0 for success, 1-255 for errors) stored in the special variable `$?`. Proper exit codes allow other scripts and system tools to determine whether a script succeeded.

## 1. Checking Exit Codes (`$?`)

```bash
ls /nonexistent_dir
if [ $? -ne 0 ]; then
    echo "Directory listing failed!"
fi
```

## 2. Returning Custom Exit Status

Use `exit` to stop execution and pass an exit status code back to the parent shell:
```bash
if [ -z "$1" ]; then
    echo "Error: Argument required." >&2
    exit 1
fi
```

## 3. Signal Trapping (`trap`)

The `trap` command registers cleanup actions triggered when a script receives signals or exits:

```bash
cleanup() {
    echo "Cleaning temporary files..."
    rm -f /tmp/script_lock.tmp
}

trap cleanup EXIT
```

Regardless of whether the script terminates normally or encounters an error, the `cleanup` function will execute automatically upon script exit.
