export ZSH="/home/rafael/.oh-my-zsh"
ZSH_THEME="nuts"
plugins=(
  git kubectl zsh-autosuggestions
)
source $ZSH/oh-my-zsh.sh

# alias
alias cl="printf '\033[2J\033[3J\033[1;1H'"
alias vim=nvim
alias nvim=~/appimage/nvim.appimage
alias kb='pod=$(k get pods | cut -f1 -d" " | fzf); k exec -ti $pod bash || k exec -ti $pod sh'
alias grom="gfo master && groh"

# exports
export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git --ignore vendor --ignore node_modules -g ""'
export PATH=$PATH:/usr/local/go/bin:${GOPATH}/bin:~/.yarn/bin:~/.bin:~/go/bin/:~/.local/bin/:/snap/bin
export TMPDIR=/tmp

# fix tmux colors
#export TERM=screen-256color

# funcs
o(){xdg-open "$*" >/dev/null 2>/dev/null}
gop(){export GOPATH=~/gopath;}
port() {lsof -i ":$1" | ag LISTEN}
pf(){ k port-forward $2 $1; }

qq() {
    if [[ -f "$TMPDIR/q" ]]; then
        rm "$TMPDIR/q"
    fi
    clear
    local gpath="${GOPATH:-$HOME/gopath}"
    "${gpath%%:*}/src/github.com/y0ssar1an/q/q.sh" "$@"
}

# make <tab>
zstyle ':completion:*:*:make:*' tag-order 'targets'
autoload -U compinit && compinit

# others
. /usr/share/autojump/autojump.sh
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
