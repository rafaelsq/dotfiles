plugins=(
  git
)

alias pushard="git push origin -f \$(git br | ag '\*' | cut -d ' ' -f 2)"
alias prd="git remote update ss && git prd"
alias prm="git remote update ss && git prm"
alias rhm="git reset --hard ss/master"
alias rhd="git reset --hard ss/development"
alias prhm="uss && rhm"
alias prhd="uss && rhd"
alias gca="git commit -a --amend"
alias gcane="git commit --amend --no-edit"

export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'

export GOPATH=~/go1.11
export PATH=$PATH:/usr/local/go/bin:${GOPATH}/bin:~/.yarn/bin

. /usr/share/autojump/autojump.sh
