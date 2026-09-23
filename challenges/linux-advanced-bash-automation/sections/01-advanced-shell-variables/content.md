# Advanced Shell Variables & Data Manipulation

Shell scripting in production environments requires handling complex data structures beyond simple scalar strings. Bash provides native support for indexed arrays, associative (key-value) arrays, and powerful parameter expansion syntax that allows developers to manipulate strings and default values without spawning external processes like `sed`, `awk`, or `cut`.

---

## 1. Indexed & Associative Arrays

### Indexed Arrays
Indexed arrays store ordered lists of elements accessible by integer indices:

```bash
# Declaration and initialization
declare -a SERVERS=("web-01" "db-01" "app-01")

# Append element
SERVERS+=("cache-01")

# Access element by index (0-indexed)
echo "First server: ${SERVERS[0]}"

# Access all elements
echo "All servers: ${SERVERS[@]}"

# Get array length
echo "Total servers: ${#SERVERS[@]}"

# Loop through array elements
for server in "${SERVERS[@]}"; do
    echo "Processing $server"
done
```

### Associative Arrays
Associative arrays store key-value pairs (hash maps) and require explicit declaration with `declare -A`:

```bash
# Declaration
declare -A CONFIG

# Assign key-value pairs
CONFIG["port"]="8080"
CONFIG["env"]="production"
CONFIG["max_connections"]="500"

# Access value by key
echo "App port: ${CONFIG[port]}"

# Iterate over keys
for key in "${!CONFIG[@]}"; do
    echo "$key = ${CONFIG[$key]}"
done
```

---

## 2. Advanced Parameter Expansion

Parameter expansion performs string manipulation, default assignment, and pattern replacement natively inside the shell:

| Syntax | Description | Example | Output |
| :--- | :--- | :--- | :--- |
| `${VAR:-default}` | Use `default` if `VAR` is unset/empty | `${PORT:-8000}` | `8000` (if PORT empty) |
| `${VAR:=default}` | Set `VAR` to `default` if unset/empty | `${ENV:=prod}` | `ENV` becomes `prod` |
| `${#VAR}` | Length of string | `${#VAR}` | `12` |
| `${VAR#pattern}` | Strip shortest leading pattern match | `${PATH#/var/}` | `log/syslog` |
| `${VAR##pattern}` | Strip longest leading pattern match | `${PATH##*/}` | `syslog` |
| `${VAR%pattern}` | Strip shortest trailing pattern match | `${FILE%.txt}` | `notes` |
| `${VAR%%pattern}` | Strip longest trailing pattern match | `${URL%%:*}` | `http` |
| `${VAR/pattern/replace}` | Replace first match | `${VAR/dev/prod}` | `prod_app` |
| `${VAR//pattern/replace}` | Replace all matches | `${VAR//-/}` | `web01` |
| `${VAR^^}` | Convert to uppercase | `${ENV^^}` | `PRODUCTION` |
| `${VAR,,}` | Convert to lowercase | `${ENV,,}` | `production` |

---

## Summary

Native Bash arrays and parameter expansion eliminate unnecessary child process spawning, improving execution speed and reducing script complexity.

---

## Lab Tasks

### Task 1: Use Advanced Parameter Expansion (`lnx-use-advanced-parameter-expansion`)
1. Start the lab:
   ```bash
   tld start lnx-use-advanced-parameter-expansion
   ```
2. Create directory `$HOME/param-test`.
3. Given the path variable `FILEPATH="/var/log/app/service.log"` and string `MODE="dev_environment"`:
4. - Line 1: Change file extension `.log` to `.bak` using parameter expansion `${FILEPATH%.log}.bak`.
5. - Line 2: Extract filename `service.log` using `${FILEPATH##*/}`.
6. - Line 3: Convert `MODE` to uppercase `DEV_ENVIRONMENT` using `${MODE^^}`.
7. Write these 3 lines into `$HOME/param-test/processed.txt`.
8. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Work with Arrays in Bash (`lnx-work-with-arrays`)
1. Start the lab:
   ```bash
   tld start lnx-work-with-arrays
   ```
2. Create `$HOME/array-test/` directory.
3. Write a script or bash commands that build an indexed array of servers `('web-01' 'db-01' 'app-01')`, sort them alphabetically, and output each server on a new line to `$HOME/array-test/servers.txt`.
4. Build an associative array with keys `port=8080` and `env=production`, and write each key=value pair to `$HOME/array-test/config.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```
