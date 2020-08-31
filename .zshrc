#!/usr/bin/env zsh

# auto-completion init ? (from: https://stackoverflow.com/a/58517668)
autoload -Uz compinit && compinit
# Load bash complete compatability ? (from: https://stackoverflow.com/a/3251836)
autoload -U +X bashcompinit && bashcompinit

# INIT
# Load bash_profile if one is present
if [ -r ~/.bash_profile ]; then
  source ~/.bash_profile
fi


# ENVIRONMENT VARIABLES
# Set zsh-friendly PS1
PS1="%K{yellow}%F{black}[%*]%K{green} %n %K{blue}%F{standout}%~%K{red}%#%f%k "


# FUNCTIONS
# Usage: git-prompt (when in a git repo)
#   Print the output of `git status` then prompt the user for whether
#   they wish to `git push`
function git-prompt() {
  git log "origin/$(git rev-parse --abbrev-ref HEAD)"..HEAD
  echo '------------------------------------------';
  git status --untracked-files no;

  echo '------------------------------------------';
  while true; do
    # @NOTE `read` args different for zsh than bash
    read -q yn\?"Do you wish to run \`git push\`? "
    case ${yn} in
        [Yy]* ) git push; break;;
        [NnQq]* ) break;;
        * ) echo "Please answer Y or N.";;
    esac
  done
}

# Export variables from a properties file where
#   variable declarations aren't prefixed with `export`
# This is useful for reading .env files and other 'properties'
#   format files in the format of `VARIABLE=Some value`
#   that are usually automatically fed into the environment
#   by a tool like Docker, when running in your local dev environment
function export-properties() {
  # Validation
  if [ -z "$1" ]; then
    echo "No file specified."
    echo "Usage: read-properties file_name"
    return 1;
  fi
  if [ ! -r "$1" ]; then
    echo "Destination file $1 is not readable"
    return 1;
  fi

  # Read file line by line
  while read -r line; do
    # Match regex 'something=value'
    if [[ ! "${line}" =~ ^\s*\# && "${line}" =~ ^\s*([^=]+)=(.*)\s*$ ]]; then
      key="${match[1]}";
      value="${match[2]}";

      # Export dynamic variable
      export "$key"="$value";
    fi
  done < "$1"
}

