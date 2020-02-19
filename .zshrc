# INIT
# Load bash_profile if one is present
if [ -f ~/.bash_profile ]; then
  source ~/.bash_profile
fi

# auto-completion init ? (from: https://stackoverflow.com/a/58517668)
autoload -Uz compinit && compinit

# ENVIRONMENT VARIABLES
# Set zsh-friendly PS1
PS1="%K{yellow}%F{black}[%*]%K{green} %n %K{blue}%F{standout}%~%K{red}%#%f%k "


# ALIASES
# Usage: git-prompt (when in a git repo)
#   Print the output of `git status` then prompt the user for whether
#   they wish to `git push`
function git-prompt() {
  git log "origin/$(git rev-parse --abbrev-ref HEAD)"..HEAD
  echo '------------------------------------------';
  git status --untracked-files no;

  echo '------------------------------------------';
  while true; do
    read -q yn\?"Do you wish to run \`git push\`? "
    case ${yn} in
        [Yy]* ) git push; break;;
        [NnQq]* ) break;;
        * ) echo "Please answer Y or N.";;
    esac
  done
}