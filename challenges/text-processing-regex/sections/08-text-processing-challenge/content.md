# Text Processing Capstone Challenge

In this capstone challenge, you will put your text processing and regular expression skills to the test by building an automated log analysis report from raw server data.

## Challenge Briefing

1. Input Log File: `$HOME/text-challenge/server.log`
2. Target Output File: `$HOME/text-challenge/analysis_report.txt`

## Challenge Requirements

Your analysis report must contain two specific summary metrics:

1. `TOTAL_ERRORS: <count>` — The total count of log lines containing status code `STATUS:500`.
2. `MOST_FREQUENT_ERROR_IP: <ip>` — The IP address associated with the highest number of `STATUS:500` error responses.

Use pipelines combining `grep`, `awk`, `cut`, `sort`, and `uniq` to calculate these metrics and save them into `$HOME/text-challenge/analysis_report.txt`.
