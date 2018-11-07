plugins=(
  git kubectl
)

alias pushard="g push origin -f \$(g br | ag '\*' | cut -d ' ' -f 2)"
alias prd="g ru ss && g prd"
alias prm="g ru ss && g prm"
alias prhm="g ru ss && g rhm"
alias prhd="g ru ss && g rhd"
alias gca="g ci -a --amend"
alias gcane="g ci --amend --no-edit"

export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'

export GOPATH=~/go1.11
export PATH=$PATH:/usr/local/go/bin:${GOPATH}/bin:~/.yarn/bin:~/.bin

. /usr/share/autojump/autojump.sh
