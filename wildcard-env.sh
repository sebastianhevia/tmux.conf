#!/bin/bash

PROJECT_PATH="$1"

if [ -z "$PROJECT_PATH" ]; then
    echo "Usage: $0 <project-path>"
    exit 1
fi

WINDOW_NAME=$(echo PROJECT_PATH | awk -F"/" '{print $NF}')

~/.config/tmux/create-dev-environment.sh $PROJECT_PATH $WINDOW_NAME FULL

