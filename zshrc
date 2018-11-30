plugins=(
  git kubectl zsh-autosuggestions
)

alias push="g push origin \$(g br | ag '\*' | cut -d ' ' -f 2)"
alias pushard="g push origin -f \$(g br | ag '\*' | cut -d ' ' -f 2)"
alias prd="g ru ss && g prd"
alias prm="g ru ss && g prm"
alias prhm="g ru ss && g rhm"
alias prhd="g ru ss && g rhd"
alias gca="g ci -a --amend"
alias gcane="g ci --amend --no-edit"
alias cl="printf '\033[2J\033[3J\033[1;1H'"

export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'

export GOPATH=~/go1.11
export PATH=$PATH:/usr/local/go/bin:${GOPATH}/bin:~/.yarn/bin:~/.bin:~/.platform-tools/

export TMPDIR=/tmp
qq() {
    clear
    local gpath="${GOPATH:-$HOME/go}"
    "${gpath%%:*}/src/github.com/y0ssar1an/q/q.sh" "$@"
}
rmqq() {
    if [[ -f "$TMPDIR/q" ]]; then
        rm "$TMPDIR/q"
    fi
    qq
}

. /usr/share/autojump/autojump.sh
