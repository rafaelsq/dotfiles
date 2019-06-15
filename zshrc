export ZSH="/home/rafael/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(
  git kubectl zsh-autosuggestions
)
source $ZSH/oh-my-zsh.sh

o(){xdg-open "$*" >/dev/null 2>/dev/null}

alias push="g push origin \$(g br | ag '\*' | cut -d ' ' -f 2)"
alias pushard="g push origin -f \$(g br | ag '\*' | cut -d ' ' -f 2)"
alias prhm="g fetch ss master && g rhm"
alias prhd="g fetch ss development && g rhd"
alias prm="g prm"
alias prd="g prd"
alias gca="g ci -a --amend"
alias gcane="g ci --amend --no-edit"
alias cl="printf '\033[2J\033[3J\033[1;1H'"
alias m=microk8s.kubectl
alias pulls='o $(git config remote.ss.url | sed "s/git@\(.*\):\(.*\).git/https:\/\/\1\/\2/")/$1$2pulls'

export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git --ignore vendor --ignore node_modules -g ""'

export PATH=$PATH:/usr/local/go/bin:${GOPATH}/bin:~/.yarn/bin:~/.bin:~/.platform-tools/:~/go/bin/
alias vim=nvim
alias nvim=~/appimage/nvim.appimage

path() {
    export GOPATH=~/gopath
}

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
