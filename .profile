### PREFACE ###
umask 022
mesg n || true

say () {
    # echo "$(date +%H:%S.%3N) $*"
    :
}
__callable () {
    type "$1" > /dev/null 2>&1
}

say START .profile

### PATH / MANPATH ###
say PATH / MANPATH
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
export MANPATH=/usr/share/man
if __callable brew && test -d /usr/local/opt/coreutils; then
    # coreutils
    export PATH=/usr/local/opt/coreutils/libexec/gnubin:$PATH
    export MANPATH=/usr/local/opt/coreutils/libexec/gnuman:$MANPATH
fi
if uname -r|grep -q microsoft; then
    # WSL2
    export PATH=$PATH:$HOME/bin/win:/mnt/c/Windows:/mnt/c/Windows/System32
    export PATH=$PATH:'/mnt/c/Program Files/Microsoft VS Code/bin'
    export PATH=$PATH:'/mnt/c/Program Files/Docker/Docker/resources/bin:/mnt/c/ProgramData/DockerDesktop/version-bin'
    alias ex='/mnt/c/Windows/explorer.exe .'
fi

### ENVIRONMENT VARIABLES ###
say ENVIRONMENT VARIABLES
if [ -e ~/.env ]; then
    . ~/.env
fi
export LANG=ja_JP.UTF-8
export LC_ALL=ja_JP.UTF-8
export PAGER=less
export EDITOR=$(which vim 2>/dev/null)
export LESS="-RMij3x4"
export LESSCHARSET=utf-8
if [ -e /usr/local/bin/src-hilite-lesspipe.sh ]; then
    export LESSOPEN='| /usr/local/bin/src-hilite-lesspipe.sh %s'
elif [ -e /usr/share/source-highlight/src-hilite-lesspipe.sh ]; then
    export LESSOPEN='| /usr/share/source-highlight/src-hilite-lesspipe.sh %s'
fi
export HISTCONTROL=ignoreboth
export HISTIGNORE="[     ]*:&:bg:fg"
export HISTSIZE=10000
export BLOCKSIZE=K
export HOMEBREW_CASK_OPTS="--appdir=/Applications"
export HOMEBREW_INSTALL_CLEANUP=1
#export SUDO_PROMPT="さっさとパスワード入れなさいよ、このバカ！ > "

### PROMPT ###
if [ -r ~/.color ]; then
    COLOR=$(cat ~/.color)
else
    COLOR=32 # red:31 green:32 yellow:33 blue:34 pink:35 cyan:36  red:91 green:92 yellow:99 blue:94 pink:95 cyan:96
fi
PS1='\[\033[${COLOR}m\]\D{%m/%d_%H:%M}:\h:\W\$\[\033[0m\] '

# ### SHOPT ###
# # check the window size after each command and, if necessary, update the values of LINES and COLUMNS.
# shopt -s checkwinsize
# # append to the history file, don't overwrite it
# shopt -s histappend

### ALIASES ###
say ALIASES
alias ls='ls -FG'
if uname -s|grep -q Linux; then
    alias ls='ls -F --color=tty'
fi
alias la='ls -A'
alias ll='ls -l'
alias lal='ls -Al'
alias l=less
alias zl=zless
alias p='ps -ef|less'
alias pj='ps ajxww|less'
alias cp='cp -i'
alias mv='mv -i'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias .......='cd ../../../../../..'
alias ........='cd ../../../../../../..'
alias cd-='cd -'
alias v=vim
alias vv=view
alias vd=vimdiff
alias tml='tmux ls'
alias jql='jq | less'
alias mysql='mysql --default-character-set=utf8'
alias mem='top -stats command,rsize,vsize -o rsize'
alias ehe="find . \( -name .DS_Store -o -name '._*' \)"
alias ehehe="find . \( -name .DS_Store -o -name '._*' -o -name Thumbs.db \) -print -execdir touch -r . /tmp/ehehe \; -execdir rm {} \; -execdir touch -r /tmp/ehehe . \;"
if __callable ss; then
    alias np="ss -ltn"
else
    alias np="netstat -an | grep LISTEN | grep -vw -e '^unix' -e '^tcp6'"
fi
alias g='git'
alias gb='git br'
alias gba='git br -a'
alias gs='git status -sb && git stash list|cat'
alias gl='git log --stat'
alias gl1="git log --format='format:%h %ad [%an]: %s' --date='format:%y/%m/%d_%H:%M:%S'"
alias glg='git log --graph'
alias gll="git log \$(git tag | tail -1)..HEAD --pretty='format:%h %ad [%an]: %s' --date='format:%y/%m/%d_%H:%M:%S' | cat; echo"
alias gsh='git show'
gshs () { test -n "$1" && n=$1 || n=0; git show stash@\{$n\}; }
alias gt='git tag --contains'
alias gstash='git stash'
alias gsl='git stash list | cat'
alias gsp='git stash pop'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gw='git switch'
alias gw-='git switch -'
alias gwc='git switch -c'
alias grup='git remote update --prune'
alias grv='git remote -v'
alias gk='git push'
alias gko='git push -u origin'
alias gj='git pull'
alias gjj='git fetch'
alias gjr='git pull --rebase'
alias ga='git add'
alias gm='git merge'
alias gmc='git merge --continue'
alias greset='git reset'
alias grs='git reset --soft HEAD~'
alias grs2='git reset --soft HEAD~~'
alias grs3='git reset --soft HEAD~~~'
alias grestore='git restore'
alias gd='git diff'
alias gds='git diff --staged'
alias ggd=git-diff-per-commit.sh
alias ggdd='git-diff-per-commit.sh -d'
alias ggdm='git-diff-per-commit.sh -m'
gcm () { git commit -m "$*"; }
gca () {
    if [ $# -eq 0 ]; then
        git commit --amend --no-edit
    else
        git commit --amend -m "$*"
    fi
}
alias gr='git rebase'
alias gri='git rebase -i'
alias grc='git rebase --continue'
alias gra='git rebase --abort'
alias git-base-branch="git show-branch | grep '*' | grep -v \"\$(git rev-parse --abbrev-ref HEAD)\" | head -1 | awk -F'[]~^[]' '{print $2}'"
alias grm='git rm'
alias gch='git cherry -v'
alias sls='sl status'
alias sll='sl log'
alias sld='sl diff'
alias slsh='sl show'
alias slshelve='sl shelve'
alias slunshelve='sl unshelve'
alias slgo='sl go'
alias sln='sl next'
alias slp='sl prev'
alias slj='sl pull'
alias slc='sl commit'
slcm () { sl commit -m "$*"; }
sla () {
    if [ $# -eq 0 ]; then
        sl amend
    else
        sl amend -m "$*"
    fi
}
alias slrev='sl revert'
alias slpr='sl pr'
alias be='bundle exec'
alias mimicurl="curl \
  -A 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99.0.4844.74 Safari/537.36' \
  -e 'https://www.google.co.jp/' \
  -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8' \
  -H 'Accept-Language: ja-JP,ja;q=0.9,en-US;q=0.6,en;q=0.5' \
  -H 'Accept-Encoding: gzip, deflate, br'"
alias rak="rak -k 'log|tmp|assets' --nogroup --follow"
alias da='direnv allow'
alias mux=tmuxinator
alias grep="grep --color=auto --exclude='*.swp' --exclude='.#*' --exclude='*.jpg' --exclude='*.jpeg' --exclude='*.gif' --exclude='*.png' --exclude='*.bmp' --exclude='*.pdf' --exclude='*.dump' --exclude-dir=.git --exclude-dir=.svn --exclude-dir=log --exclude-dir=tmp --exclude-dir=images --exclude-dir=node_modules --exclude-dir=vendor --exclude-dir=.next"
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias rsync='rsync --iconv=UTF8-MAC,UTF-8'
if uname -o|grep -q Darwin; then
    alias top='top -ocpu -s2 -stats pid,ppid,pgrp,command,time,cpu,mem,cpu_me,cpu_others,state,faults'
else
    alias top='top -d2'
fi
alias d=docker
alias dc=docker-compose
alias de='docker exec'
alias dp='docker ps -a'
alias dcp='docker-compose ps -a'
alias ds='docker search'
alias htb='sudo openvpn ~/security/monmonmon.ovpn'
if which colordiff > /dev/null 2>&1; then
    alias diff="colordiff -u"
else
    alias diff="diff -u"
fi
alias x=xargs
alias wh=which
alias t=type
alias c='code .'
alias s="ruby -e \"puts ARGV.map{|arg| arg.gsub(',', '').to_f }.sum\""
alias gemgem='gem list -era'
o () {
    if [ $# -eq 0 ]; then
        open .
    else
        open $1
    fi
}
alias p1='ping 1.1.1.1'
alias e='ej'
alias sortl='sort|less'
alias brewup='time ( brew update && brew upgrade && brew upgrade --cask && brew cleanup )'
alias aptup='time ( sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y )'
alias bomify='nkf --oc=utf-8-bom --overwrite'
rate() {
    if [ -z "$ALPHAVANTAGE_APIKEY" ]; then
        echo API key is missing :P
        return
    fi
    from=${1:-usd}
    to=${2:-jpy}
    echo $from $to
    curl -s "https://www.alphavantage.co/query?function=CURRENCY_EXCHANGE_RATE&from_currency=$from&to_currency=$to&apikey=$ALPHAVANTAGE_APIKEY" | jq -r '.["Realtime Currency Exchange Rate"]["5. Exchange Rate"]'
}
safefilename() {
    test $# -eq 0 && return
    echo "$*" | tr '\/:*?"<>|' '￥／：＊？” ＜＞｜'
}
alias uncolor='sed -r "s/\x1B\[([0-9]{1,3}((;[0-9]{1,3})*)?)?[m|K]//g"'

### SHELL FUNCTIONS ###
say SHELL FUNCTIONS
# echo してから実行
function run () {
    echo "> ${*}"
    $*
}
if ! __callable setopt; then
    function cd () {
        if [ $# -eq 0 ]; then
            builtin cd
            ls
        elif [ -d "$1" -o "$1" = "-" ]; then
            builtin cd "$1"
            ls
        else
            echo cd: no such file or directory: $1
        fi
    }
fi
# find all files under the specified or current directory
function ff () {
    case $# in
        0) dir=.;;
        *) dir="$1";;
    esac
    find $dir -type f
    unset dir
}
function fn () {
    case $# in
        1)    name=$1; dir=.;;
        2)    name=$1; dir=$2;;
        *)    echo "Usage: fn pattern [dir]"; return;;
    esac
    find $dir -name "$name"
    unset dir name
}
# ip address to number
function ip2nr () {
    if echo "$1" | egrep '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$' &>/dev/null; then
        arr=(`echo $1 | tr . ' '`)
        echo $(( (${arr[1]} * 16777216) + (${arr[2]} * 65536) + (${arr[3]} * 256) + (${arr[4]}) ))
        unset arr
    fi
}
# number to ip address
function nr2ip () {
    if echo "$1" | egrep '^[0-9]+$' &>/dev/null; then
        echo $(($1/16777216)).$(($1/65536%256)).$(($1/256%256)).$(($1%256))
    fi
}
# space alc
function a () {
    test $# -eq 0 && return
    s=$(echo "$*" | tr ' ' '+')
    w3m -dump "http://eow.alc.co.jp/${s}/UTF-8/?ref=sa" | gsed -n '/の意味・使い方・読み方\|検索結果一覧を見る\|に該当する項目は見つかりませんでした。/,/^\[btn-arr2]\|^ページの先頭に戻る$/ p' | gsed 's/    単語帳//' | less
}
function alc () {
    test $# -eq 0 && return
    s=$(echo "$*" | tr ' ' '+')
    w3m -dump "http://eow.alc.co.jp/${s}/UTF-8/?ref=sa" | less
}
# tmux attach
function tma () {
    if [ -n "$1" ]; then
        tmux attach -t $1
    else
        tmux attach
    fi
}
function timer () {
    if [ -n "$1" ]; then
        seconds=$1
        t1=$((`date +%s` + $seconds));
        while [ "$t1" -ge `date +%s` ]; do
            echo -ne "$(($t1 - $(date +%s)))     \r"
        done
        echo "\a"
    else
        echo "Usage: $0 <number of seconds>"
    fi
}
function uppercase () {
    if [ -n "$1" ]; then echo "$*" | tr '[a-z]' '[A-Z]'; fi
}
function lowercase () {
    if [ -n "$1" ]; then echo "$*" | tr '[A-Z]' '[a-z]'; fi
}
# 2進数->10進数
function 2to10 () {
    if [ -n "$1" ]; then echo "ibase=2; $1" | bc; fi
}
# 2進数->16進数
function 2to16 () {
    if [ -n "$1" ]; then echo "obase=16; ibase=2; $1" | bc; fi
}
# 10進数->2進数
function 10to2 () {
    if [ -n "$1" ]; then echo "obase=2; ibase=10; $1" | bc; fi
}
# 10進数->16進数
function 10to16 () {
    if [ -n "$1" ]; then echo "obase=16; ibase=10; $1" | bc; fi
}
# 16進数->2進数
function 16to2 () {
    if [ -n "$1" ]; then echo "obase=2; ibase=16; $(uppercase $1)" | bc; fi
}
# 16進数->10進数
function 16to10 () {
    if [ -n "$1" ]; then echo "ibase=16; $(uppercase $1)" | bc; fi
}
function urlencode () {
    echo $1 | nkf -WwMQ | tr = %
}
function urldecode () {
    echo $1 | nkf --url-input
}
function swap () {
    if [ $# != 2 -o ! -f "$1" -o ! -f "$2" -o "$1" = "$2" ]; then
        echo ":P"
    else
        local tmpfile=$(mktemp)
        \mv "$1" $tmpfile
        \mv "$2" "$1"
        \mv $tmpfile "$2"
    fi
}
function nocomment () {
    if [ $# -le 0 ]; then
        return
    fi
    prefix='#'
    # if [ -n "$2" ]; then
    #     prefix="$2"
    # fi
    egrep -h -v -e "^\s*${prefix}" -e '^\s*$' $*
}
function opendir () {
    if [ $# -eq 1 -a -e "$1" ]; then
        echo "$1"
        if [ -d "$1" ]; then
            echo "$1"
            open "$1"
        else
            open $(dirname "$1")
        fi
    fi
}
function mkdircd () {
    mkdir -p "$*" && cd "$*"
}
alias mkdirr=mkdircd
# mainとdevelopを互いにマージしてpush
function gkk () {
    original_branch=$(git symbolic-ref --short HEAD)
    if [ $original_branch != develop ]; then
        run git switch develop
    fi
    run git merge main
    if [ $(git diff origin/develop | wc -l) -ne 0 ]; then
        run git push
    fi
    run git switch main
    run git merge develop
    if [ $(git diff origin/main | wc -l) -ne 0 ]; then
        run git push
    fi
    run git switch $original_branch
}
# iTerm2 のタブ名を変更
function tn () {
    echo -ne "\e]1;$1\a"
    # echo -ne "\033]0;"$1"\007"
}
# alert
if uname -s|grep -q Darwin; then
    function alert () {
        if [ $# -eq 1 ]; then
            osascript -e "display notification \"$1\""
        elif [ $# -gt 1 ]; then
            osascript -e "display notification \"$1\" with title \"$2\""
        fi
    }
fi
# git cherry bash completion
_git_cherry ()
{
        __gitcomp "$(__git_refs)"
}
# 全ての拡張属性を削除
rmattr () {
    if [ ! -e "$1" ]; then
        echo :P
        return
    fi
    for attr in $(xattr "$1"); do
        xattr -d $attr "$1"
    done
}
# パーミッションを644/755に
chmodd () {
    if [ $# -eq 0 ]; then
        dir=.
    elif [ $# -eq 1 -a -d "$1" ]; then
        dir="$1"
    fi
    find "$dir" -perm 777 -a -type d -exec chmod 755 {} \;
    find "$dir" -perm 777 -a -type f -exec chmod 644 {} \;
}
# 指定番目のフィールドを出力
aw () {
    if [ $# -ge 1 -a "$1" -eq "$1" ] 2>/dev/null; then
        if [ -n "$2" ]; then
            awk -F"$2" "{print \$$1}"
        else
            awk "{print \$$1}"
        fi
    else
        echo :P
    fi
}
# nginxのgzip_staticでの配信用に指定ディレクトリ以下のファイルをgz圧縮
compress-files () {
    for f in $@; do
        if [ ! -f $f -a ! -d $f ]; then
            echo "no such file or directory: $f"
            continue
        fi
        for f in $(find $f -type f | grep -v '\.gz$'); do
            if file -b --mime-type "$f" | grep -wq image; then
                continue
            fi
            echo "compress $f"
            zopfli "$f"
        done
    done
}
# 体重からBMIを計算
bmi () {
    if [ -n "$1" ]; then
        printf "%.3f\n" $(($1 / 1.76 ** 2))
    fi
}
# 0詰めした数字列を生成
numbers () {
    if [ $# -eq 1 ]; then
        s=1
        e=$1
    elif [ $# -eq 2 ]; then
        s=$1
        e=$2
    else
        return
    fi
    for i in $(seq $s $e); do printf "%03d\n" $i; done
}
# ランダムなhex文字列を生成
hex () {
    n=8
    if [ $# -eq 1 ]; then
        n=$1
    fi
    h=$(hexdump -vn$(($n/2)) -e'1 "%02x"' /dev/urandom)
    echo -n $h | pbcopy
    echo $h
}
# dockerコンテナに振られたIPをリスト
dip () {
    ( docker-compose ps -q 2>/dev/null || docker ps -q ) | xargs docker inspect | jq -r '.[] | "\(.Name | ltrimstr("/"))\t\([.NetworkSettings.Networks[].IPAddress] | join(", "))"'
}

### MISC ###
say MISC
# xmodmap
if [ -f ~/.xmodmaprc ]; then
    xmodmap ~/.xmodmaprc
fi
# bash completion
if __callable brew && [ -d $(brew --prefix)/etc/bash_completion.d ]; then
    say bash_completion
    . $(brew --prefix)/etc/bash_completion.d
fi

# anyenv
if ! __callable rbenv && [ -d ~/.anyenv ]; then
    say anyenv
    eval "$(anyenv init -)"
fi

# composer
if [ -d ~/.composer/vendor/bin ]; then
    say composer
    export PATH=~/.composer/vendor/bin/:$PATH
fi

# ghq
export GHQ_ROOT=~/ghq

# volta
if [ -d "$HOME/.volta" ]; then
    export VOLTA_HOME="$HOME/.volta"
    export PATH="$VOLTA_HOME/bin:$PATH"
fi

# deno
if [ -d ~/.deno/bin ]; then
    export PATH=~/.deno/bin:$PATH
fi

# postgres
function pz () {
    datadir=/usr/local/pgsql/data
    logdir=/var/log/pgsql
    if [ ! -d $logdir ]; then
        sudo mkdir -p $logdir
        sudo chown $(whoami):staff $logdir
    fi
    pg_ctl -D $datadir -l $logdir/server.log start
}

# direnv
__callable direnv && eval "$(direnv hook $(basename $SHELL))"

# brewfile
# https://homebrew-file.readthedocs.io/en/latest/brew-wrap.html
if __callable brew && [ -x $(brew --prefix)/bin/brew -a -f $(brew --prefix)/etc/brew-wrap ]; then
    say brewfile
    source $(brew --prefix)/etc/brew-wrap
fi

# gcc
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# # # golang
# # if [ -n "$GOPATH" ]; then
# #     export PATH=$GOPATH/bin:$PATH
# # fi
# export GOROOT=$HOME/go
# export GOPATH=$GOROOT/path
# # export GOMODCACHE=$GOROOT/pkg/mod
# export PATH=$GOROOT/bin:$GOPATH/bin:$PATH

# golang
if __callable go; then
    export PATH=$(go env GOPATH)/bin:$PATH
fi

# Android SDK
if [ -d $HOME/Library/Android/sdk/platform-tools ]; then
    export ANDROID_HOME=$HOME/Library/Android/sdk
    export PATH=$PATH:$ANDROID_HOME/emulator
    export PATH=$PATH:$ANDROID_HOME/tools
    export PATH=$PATH:$ANDROID_HOME/tools/bin
    export PATH=$PATH:$ANDROID_HOME/platform-tools
fi

# # 繋いでるSSIDとスマホ(Pixel 5)を確認したうえで yarn android
# function ya () {
#     if ! networksetup -getairportnetwork en0|grep -q MIG-2; then
#         echo wrong ssid
#     elif ! adb devices|grep -q xx; then
#         echo device not connected
#     else
#         yarn android
#     fi
# }

# # java
# if [ -x /usr/libexec/java_home ] && /usr/libexec/java_home 2>&1 >/dev/null; then
#     export JAVA_HOME=`/usr/libexec/java_home -v 15`
#     export PATH=$JAVA_HOME/bin:$PATH
# elif __callable update-alternatives && update-alternatives --list java 2>&1 >/dev/null; then
#     export JAVA_HOME=$(dirname $(dirname $(update-alternatives --list java)))
# fi

# cargo
if [ -f ~/.cargo/env ]; then
    . "$HOME/.cargo/env"
    export CARGO_NET_GIT_FETCH_WITH_CLI=true
fi

# flutter (~/flutter/bin)
if [ -d ~/flutter/bin ]; then
    export PATH="$PATH:$HOME/flutter/bin"
fi
if [ -d ~/flutter/bin/cache/dart-sdk ]; then
    export DART_SDK=$HOME/flutter/bin/cache/dart-sdk
    export PATH="$PATH:$DART_SDK/bin"
fi
if [ -d "$HOME/.pub-cache/bin" ]; then
    export PATH="$PATH":"$HOME/.pub-cache/bin"
fi

if [ -f ~/.profile.local ]; then
    . ~/.profile.local
fi

# conda
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/monmon/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/monmon/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/monmon/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/monmon/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup

# terraform
if [ -f /usr/bin/terraform ]; then
    autoload -U +X bashcompinit && bashcompinit
    complete -o nospace -C /usr/bin/terraform terraform
fi

say FINISH .profile
