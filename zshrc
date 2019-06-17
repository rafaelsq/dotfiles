export ZSH="/home/rafael/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(
  git kubectl zsh-autosuggestions
)
source $ZSH/oh-my-zsh.sh

o(){xdg-open "$*" >/dev/null 2>/dev/null}

alias push="g push origin \$(g br | ag '\*' | cut -d ' ' -f 2)"
alias pushard="g push origin -f \$(g br | ag '\*' | cut -d ' ' -f 2)"
alias prm="g prm"
alias prd="g prd"
alias gca="g ci -a --amend"
alias gcane="g ci --amend --no-edit"
alias cl="printf '\033[2J\033[3J\033[1;1H'"

export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git --ignore vendor --ignore node_modules -g ""'

export PATH=$PATH:/usr/local/go/bin:${GOPATH}/bin:~/.yarn/bin:~/.bin:~/.platform-tools/:~/go/bin/
alias vim=nvim
alias nvim=~/appimage/nvim.appimage

path() {
    export GOPATH=~/gopath
}

export TMPDIR=/tmp
qq() {
    if [[ -f "$TMPDIR/q" ]]; then
        rm "$TMPDIR/q"
    fi
    clear
    local gpath="${GOPATH:-$HOME/gopath}"
    "${gpath%%:*}/src/github.com/y0ssar1an/q/q.sh" "$@"
}

. /usr/share/autojump/autojump.sh
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
