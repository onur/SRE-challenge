#!/bin/sh
# Continuously checks a website load-time and alerts a Slack channel if it
# exceeds a certain threshold. Get help with: ./load-time.sh -h
#
# Example:
#   ./load-time.sh --slack-token TOKEN --slack-channel C123456 https://www.namecheap.com

set -e

# Variables with defaults
THRESHOLD=500  # milliseconds
MAX_TIME=5     # seconds
INTERVAL=10    # seconds
SLACK_TOKEN=""
SLACK_CHANNEL_ID=""
URL=""


usage() {
    cat << EOF
Usage: $0 [options...] <url>
 -t, --threshold <ms>        Threshold value in milliseconds, default: 500
 -m, --max-time <seconds>    Maximum time to timeout in seconds, default: 5
 -i, --interval <seconds>    Interval between every check, default: 10
     --slack-token <token>   Slack bearer token to send an alert, required.
     --slack-channel-id <id> Slack channel id to send message, required.
 -h, --help                  Show this help message, and exit.
EOF
}

# Get options with getopt
OPTIONS=$(getopt -o ht:m:i: --long help,threshold:,max-time:,interval,slack-token:,slack-channel-id: -- "$@")
eval set -- "$OPTIONS"

while true; do
    case "$1" in
        -h|--help) usage; exit 0;;
        -t|--threshold) THRESHOLD=$2; shift 2;;
        -m|--max-time) MAX_TIME=$2; shift 2;;
        -i|--interval) INTERVAL=$2; shift 2;;
        --slack-token) SLACK_TOKEN=$2; shift 2;;
        --slack-channel-id) SLACK_CHANNEL_ID=$2; shift 2;;
        --) URL=$2; break ;;
    esac
done


# Check required arguments
if [ -z "$URL" ] || [ -z "$SLACK_TOKEN" ] || [ -z "$SLACK_CHANNEL_ID" ]; then
    echo "Required arguments are missing!"
    usage; exit 1
fi

# Check load time and send a message to
# Slack channel if its greater than threshold
while true; do
    if [ $(curl -s -o /dev/null -w "%{time_total}\n" -m $MAX_TIME $URL | awk "{ print (\$1 > $THRESHOLD) }") -eq "1" ]; then
        echo "$(date -Iseconds) $URL load time exceeded $THRESHOLD ms threshold load time."
        # We want to make sure script keeps running even if slack is down
        curl -X POST -s -o /dev/null -m $MAX_TIME \
            -H "Authorization: Bearer $SLACK_TOKEN" \
            -d "channel=$SLACK_CHANNEL_ID" \
            -d "text=$URL load time exceeded $THRESHOLD ms threshold load time." \
            https://slack.com/api/chat.postMessage || true
        sleep $INTERVAL
    fi
done
