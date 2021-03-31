export ZSH="/home/rafael/.oh-my-zsh"
ZSH_THEME="nuts"
plugins=(
  git kubectl zsh-autosuggestions
)
source $ZSH/oh-my-zsh.sh

# zsh-autosuggestions binds
bindkey  '^Y' autosuggest-accept
bindkey  '^N' history-beginning-search-backward

# alias
alias cl="printf '\033[2J\033[3J\033[1;1H'"
alias vim=nvim
alias nvim=~/appimage/nvim.appimage
alias kb='pod=$(k get pods | cut -f1 -d" " | fzf); k exec -ti $pod bash || k exec -ti $pod sh'
gro(){ gfo $1 && g reset --hard origin/$1; }
alias grom="gro master && g trim"
px(){ ps xao pid,ppid,pgid,args=ARGS | ag $1 | ag -v "ag $1"; }

# exports
export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git --ignore vendor --ignore node_modules -g ""'
export PATH=$PATH:/usr/local/go/bin:${GOPATH}/bin:~/.yarn/bin:~/.bin:~/go/bin/:~/.local/bin/:/snap/bin:/usr/local/node/bin
export TMPDIR=/tmp

# fix tmux colors
#export TERM=screen-256color

# funcs
o(){xdg-open "$*" >/dev/null 2>/dev/null}
port() {lsof -i ":$1" | ag LISTEN}
pf(){ k port-forward $2 $1; }
eff() {export $(cat $1 | ag -v '#' | xargs)}
qq() {
    clear

    logpath="$TMPDIR/q"
    if [[ -z "$TMPDIR" ]]; then
        logpath="/tmp/q"
    fi

    if [[ ! -f "$logpath" ]]; then
        echo 'Q LOG' > "$logpath"
    fi

    tail -100f -- "$logpath"
}

rmqq() {
    logpath="$TMPDIR/q"
    if [[ -z "$TMPDIR" ]]; then
        logpath="/tmp/q"
    fi
    if [[ -f "$logpath" ]]; then
        rm "$logpath"
    fi
    qq
}

# enc using gpg
encgpg(){gpg --output $1.gpg --encrypt --recipient `cat ~/.gitconfig_private| ag email | cut -d' ' -f7` $1}
decgpg(){gpg --output $2 --decrypt $1}

enc(){openssl enc -aes-256-cbc -md sha512 -pbkdf2 -iter 100000 -salt -in $1 -out $1.enc}
dec(){openssl enc -aes-256-cbc -md sha512 -pbkdf2 -d -in $1 -out $2}

# enc/dec base64 to clipboard
eb64(){base64 -w 0 < <(echo -n $1) | xsel -b}
db64(){base64 -dw 0 < <(echo -n $1) | xsel -b}

# make <tab>
zstyle ':completion:*:*:make:*' tag-order 'targets'
autoload -U compinit && compinit

# others
export GPG_TTY=$(tty)

. /usr/share/autojump/autojump.sh
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
