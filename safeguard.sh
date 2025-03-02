#!/bin/bash

# Start a new Bash shell with Safe Mode
bash --rcfile <(cat << 'EOF'
# Enable strict mode for better error handling
set -o nounset   # Treat unset variables as an error
set -o pipefail  # Exit script if any command in a pipeline fails

# Define Safe Mode icon and update prompt
SAFE_ICON="🔒"
export PS1="\[\e[1;31m\]$SAFE_ICON [SAFE MODE]\[\e[0m\] \u@\h:\w\$ "

# History Settings
export HISTCONTROL=ignorespace
export HISTIGNORE="rm *"

# Prevent storing commands with 'password' in history
export HISTIGNORE="$HISTIGNORE:*password*"

# Define restricted commands (excluding rm)
BLOCKED_COMMANDS=("mv" "chmod" "chown" "kill" "shutdown" "reboot" "scp")

# Function to block dangerous commands
restrict_command() {
    echo "Safe Mode: Command '$1' is disabled."
    return 1
}

# Override blocked commands
for cmd in "${BLOCKED_COMMANDS[@]}"; do
    eval "function $cmd() { restrict_command $cmd; }"
done

# Prevent Recursive `rm`
function rm() {
    if [[ "$*" == *"-r"* || "$*" == *"-rf"* ]]; then
        echo "Safe Mode: Recursive rm is disabled."
        return 1
    else
        command rm "$@"
    fi
}

# Read-only mode for vim
alias vim='vim -R'

# Prevent PATH modification
export PATH="/usr/bin:/bin"
readonly PATH

# Auto logout after 5 minutes
export TMOUT=300

# Log all executed commands except 'rm *' and commands with 'password'
LOGFILE="$HOME/safe_mode_session.log"
echo "--- Safe Mode Session Started: $(date) ---" >> "$LOGFILE"
log_command() {
    if [[ "$BASH_COMMAND" != rm* && "$BASH_COMMAND" != *password* && ! "$BASH_COMMAND" =~ .*-password.* ]]; then
        echo "$(date) - $USER: $BASH_COMMAND" >> "$LOGFILE"
    fi
}
trap log_command DEBUG

# Define deactivate function
deactivate() {
    echo "Exiting Safe Mode..."
    exit
}

# Inform user
echo "Safe Mode activated. Type 'deactivate' to exit."
EOF
)
