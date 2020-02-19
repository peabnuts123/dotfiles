#!/usr/bin/env bash

# PATH
export PATH="${PATH}";


# ENVIRONMENT VARIABLES
# Objectively the best PS1 (bash only)
PS1="\[\e[30;43m\][\[\e[m\]\[\e[30;43m\]\T\[\e[m\]\[\e[30;43m\]]\[\e[m\]\[\e[30;42m\] \[\e[m\]\[\e[30;42m\]\u\[\e[m\]\[\e[30;42m\] \[\e[m\]\[\e[44m\]\w\[\e[m\]\[\e[41m\]\\$\[\e[m\] "
# Configure .NET Core to run in Development mode (not a default for some reason)
export ASPNETCORE_ENVIRONMENT=Development
# Stores where this shell initially opened (for `home` alias)
export __SHELL_INITIAL_DIRECTORY="$(pwd)";
# Used mostly by nvm
export NVM_DIR="${HOME}/.nvm"


# NVM
# Load nvm if it exists
if [ -s "${NVM_DIR}/nvm.sh" ]; then
  source "${NVM_DIR}/nvm.sh";
fi

# Automatically call `nvm use` when opening a shell in a directory with `.nvmrc` in it
if [ -s "$(pwd)/.nvmrc" ] && hash nvm &> /dev/null; then
  nvm use;
fi


# ALIASES
# Fuck
if hash thefuck &> /dev/null; then
  # Register `fuck` alias
  eval "$(thefuck --alias)";
  # Just run the default option always it's what you want trust me
  alias fuck="fuck --yes"
fi
# .NET Core -> `net`
if hash dotnet &> /dev/null; then
  alias net=dotnet;
fi
# Open Unity Hub from CLI
if [ -d '/Applications/Unity Hub.app' ]; then
  alias unity="open -na 'Unity Hub'"
fi
# More useful format for docker ps
if hash docker &> /dev/null; then
  alias ls-containers="docker ps --format 'table {{.ID}}\t{{.Names}}\t{{.RunningFor}}\t{{.Status}}'"
fi
# Lol
if hash python3 &> /dev/null; then
  alias python=python3
fi
# Open PICO8 from CLI
if [ -d '/Applications/PICO-8.app' ]; then
  # Specifically, the pico8 executable (for command-line parameters)
  alias pico8=/Applications/PICO-8.app/Contents/MacOS/pico8
fi
# Return to where the terminal opened
alias home="cd \"${__SHELL_INITIAL_DIRECTORY}\""


# TAB COMPLETION
# Load bash_completion (for bash only)
BASH_COMPLETION_LOCATION="/usr/local/etc/profile.d/bash_completion.sh";
if [ -r "${BASH_COMPLETION_LOCATION}" ]; then
  source "${BASH_COMPLETION_LOCATION}";
fi

# Completion for nvm (works in zsh too, despite the name)
if [ -s "${NVM_DIR}/bash_completion" ]; then
  source "${NVM_DIR}/bash_completion";
fi

# Completion for npm
if hash npm &> /dev/null; then
  eval "$(npm completion)";
fi

# Completion for terraform
if hash terraform &> /dev/null; then
  complete -o nospace -C "$(which terraform)" terraform
fi


# FUNCTIONS
# Usage: port-kill [port-number]
#   Kill whatever is listening on the specified port.
function port-kill() {
  portNumber="${1}";
	if [[ $# -gt 0 ]]; then
		lsof -i:"${portNumber}" | grep -E LISTEN | grep  -E '^\w+\s+(\d+)' -o | grep -E '\d+' -o | uniq | xargs kill -9
	fi
}

# Usage: port-what [port-number]
#   List processes that are listening on specified port
function port-what() {
  portNumber="${1}";
	lsof -i:"${portNumber}" | grep -E 'LISTEN'
}

# Usage: ip-what
#   Print out current IP addresses of this machine
function ip-what() {
	ifconfig | grep -E "inet" | grep broadcast | awk '{ print $2 }'
}

# Usage: ip-copy
#   Put the output of `ip-what` onto clipboard
function ip-copy() {
	ip-what | pbcopy
}

# Usage: git-prompt (when in a git repo)
#   Print the output of `git status` then prompt the user for whether
#   they wish to `git push`
function git-prompt() {
  git log "origin/$(git rev-parse --abbrev-ref HEAD)"..HEAD
  echo '------------------------------------------';
  git status --untracked-files no;

  echo '------------------------------------------';
  while true; do
    read -rp "Do you wish to run \`git push\`? " yn
    case ${yn} in
        [Yy]* ) git push; break;;
        [NnQq]* ) break;;
        * ) echo "Please answer Y or N.";;
    esac
  done
}

# Usage: git-breakdown
#   Prints a breakdown of the current git repository by commit author
#   in order of # commits
function git-breakdown() {
  IFS=$'\n';
  output="$(echo "`for author in $(git log | grep "Author:" | awk '{for (i=2; i<NF; i++) printf $i " "; print $NF}' | sort | uniq); do
    echo "${author}:|$(git log --pretty=oneline --author=${author} | wc -l | xargs echo) commits";
  done`" | sort -n -k2 -r -t '|' | column -t -s '|')";

  echo "${output}";

  echo "$(git log --pretty=oneline | wc -l) commits total";
}

# Usage: npm-exec (command) [...args]
#   Execute a command located in an npm bin directory, without
#   having to manually path to it
function npm-exec() {
  bin="${1}";
  shift
  args="$*"
  "$(npm bin)/${bin}" ${args};
}

# Usage: ls-count (directory=.) (depth=1)
#   Perform a recursive find in the specified folder, and display
#   a summary of the total number of files in each subfolder
#
# If `directory` is specified, perform search in that directory. Defaults to '.'
# If `depth`is specified, output analysis down to `depth` levels from root. Defaults to 1
# Example usage:
#   ls-count
#   ls-count ~/Documents
#   ls-count ~/Documents/Projects 2
function ls-count() {
  local directory="${1:-.}";
  local maxdepth="${2:-1}";
  find "${directory}" -type d -maxdepth "${maxdepth}" -mindepth 1 | while read x; do echo "$(find "$x" -type f -mindepth 1 | wc -l)  $x"; done | sort -nr;
}

# Not managed by git. For machine-specific overrides, secrets, etc.
if [ -s "${HOME}/.bash_profile.override" ]; then
  source "${HOME}/.bash_profile.override";
fi
