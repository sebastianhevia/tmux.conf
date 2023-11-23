#!/bin/bash

# Assign the first command line argument to SESSION_NAME
SESSION_NAME="dev-env"
# Assign the second command line argument to PROJECT_PATH
PROJECT_PATH="$1"
# Set a window name
WINDOW_NAME="$2"

DEV_MODE="${3:-FULL}"

# Check if SESSION_NAME and PROJECT_PATH are provided
if [ -z "$PROJECT_PATH" ] || [ -z "$WINDOW_NAME" ]; then
    echo "Usage: $0 SESSION_NAME PROJECT_PATH"
    exit 1
fi

# Check if the tmux session exists, create if it doesn't
if ! tmux has-session -t $SESSION_NAME 2>/dev/null; then
    tmux new-session -d -s $SESSION_NAME
fi

# Check if the window exists in the session
if ! tmux list-windows -t $SESSION_NAME | grep -q $WINDOW_NAME; then
    # Create a new window with the name and change to the project directory
    tmux new-window -t $SESSION_NAME -n $WINDOW_NAME -d

    if [ "$DEV_MODE" != "BASIC" ]; then
        tmux send-keys -t "${SESSION_NAME}:${WINDOW_NAME}" "cd $PROJECT_PATH" C-m
        tmux send-keys -t "${SESSION_NAME}:${WINDOW_NAME}" "nvim ." C-m
        # Split the window vertically
        tmux split-window -h -t "${SESSION_NAME}:${WINDOW_NAME}"
        tmux send-keys -t "${SESSION_NAME}:${WINDOW_NAME}" "cd $PROJECT_PATH" C-m

        
        if [ "$DEV_MODE" == "FULL" ]; then
            # Select the first pane and split it horizontally
            tmux select-pane -t 1
            tmux split-window -v -t "${SESSION_NAME}:${WINDOW_NAME}" -c "#{pane_current_path}"
            tmux send-keys -t "${SESSION_NAME}:${WINDOW_NAME}" "cd $PROJECT_PATH" C-m
        fi
    fi
fi

# Attach to the tmux session and window
tmux attach-session -t "${SESSION_NAME}:${WINDOW_NAME}"

