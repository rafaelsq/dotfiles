export ZSH="/home/rafael/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(
  git kubectl zsh-autosuggestions
)
source $ZSH/oh-my-zsh.sh

# alias
alias push="g push origin \$(g br | ag '\*' | cut -d ' ' -f 2)"
alias pushard="g push origin -f \$(g br | ag '\*' | cut -d ' ' -f 2)"
alias prm="g prm"
alias prd="g prd"
alias gca="g ci -a --amend"
alias gcane="g ci --amend --no-edit"
alias cl="printf '\033[2J\033[3J\033[1;1H'"
alias vim=nvim
alias nvim=~/appimage/nvim.appimage
alias kb='pod=$(k get pods | cut -f1 -d" " | fzf); k exec -ti $pod bash || k exec -ti $pod sh'

# exports
export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git --ignore vendor --ignore node_modules -g ""'
export PATH=$PATH:/usr/local/go/bin:${GOPATH}/bin:~/.yarn/bin:~/.bin:~/.platform-tools/:~/go/bin/:~/.local/bin/
export TMPDIR=/tmp

# funcs
o(){xdg-open "$*" >/dev/null 2>/dev/null}
gop(){export GOPATH=~/gopath;}
port() {lsof -i ":$1" | ag LISTEN}

qq() {
    if [[ -f "$TMPDIR/q" ]]; then
        rm "$TMPDIR/q"
    fi
    clear
    local gpath="${GOPATH:-$HOME/gopath}"
    "${gpath%%:*}/src/github.com/y0ssar1an/q/q.sh" "$@"
}

# others
. /usr/share/autojump/autojump.sh
[ -f ~/.zshrc.local ] && source ~/.zshrc.local

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
