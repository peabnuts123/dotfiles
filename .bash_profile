export PATH=/Users/jeff/Library/Python/2.7/bin/:$PATH


export NVM_DIR="/Users/jeff/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
if [[ -f "$(pwd)/.nvmrc" ]]; then
  nvm use;
fi

#if command -v tmux>/dev/null; then
#  [[ ! $TERM =~ screen ]] && [ -z $TMUX ] && exec tmux
#fi

[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"


PS1="\[\e[30;43m\][\[\e[m\]\[\e[30;43m\]\T\[\e[m\]\[\e[30;43m\]]\[\e[m\]\[\e[30;42m\] \[\e[m\]\[\e[30;42m\]\u\[\e[m\]\[\e[30;42m\] \[\e[m\]\[\e[44m\]\w\[\e[m\]\[\e[41m\]\\$\[\e[m\] "
ASPNETCORE_ENVIRONMENT=Development




alias net=dotnet
alias unity='open -na unity'
eval $(thefuck --alias)
alias ls-containers="docker ps --format 'table {{.ID}}\t{{.Names}}\t{{.RunningFor}}\t{{.Status}}'"
alias python=python3
alias pico8=/Applications/PICO-8.app/Contents/MacOS/pico8 


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

