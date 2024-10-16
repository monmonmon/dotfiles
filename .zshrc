test -r ~/.profile && . ~/.profile
say () {
    # echo "$(date +%H:%S.%3N) $*"
    :
}
__callable () {
    type "$1" > /dev/null 2>&1
}

say START .zshrc

### Prompts ###
# git
ulimit -f unlimited # file size
autoload -Uz vcs_info
setopt prompt_subst
zstyle ':vcs_info:git:*' formats '%b'
precmd () { vcs_info }
# color
export FGCOLOR=040
export BGCOLOR=256
if [ -r ~/.color ]; then
    eval $(grep '^\(F\|B\)GCOLOR=[0-9]\{3\}$' ~/.color)
fi
PROMPT=$'%B%K{$BGCOLOR}%F{$FGCOLOR}%D{%m/%d_%H:%M}:%m:[%f%k${vcs_info_msg_0_}%K{$BGCOLOR}%F{$FGCOLOR}]:%c%#%f%k%b '
SPROMPT=':P "%R" -> "%r" [ynae] ? '
zshcolors () {
    for c in {000..255}; do
        echo -n "\e[1m\e[38;5;${c}m $c"
        test $(($c%16)) -eq 15 && echo
    done
}

### Shell Options ###
say shell options
setopt correct              # コマンドのtypoの自動修正
setopt auto_cd              # ディレクトリ名だけで cd
setopt auto_name_dirs       # allow ~ abbreviation

## ヒストリ系
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt append_history
setopt inc_append_history   # 履歴を即時追加
setopt share_history        # コマンド履歴ファイルを共有する
setopt extended_history     # コマンドと共にunixtimestampと実行時間を記録
setopt hist_ignore_dups     # ignore duplicate history
setopt hist_ignore_all_dups # ignore duplicate history
setopt hist_ignore_space    # コマンドの先頭にスペースがある場合ヒストリに追加しない
setopt hist_reduce_blanks   # ヒストリに追加する時余計な空白を削除
setopt hist_no_store        # historyコマンドは履歴に登録しない

## globbing
setopt glob                 # Perform filename generation
setopt glob_dots
setopt extended_glob
setopt numeric_glob_sort

## 補完系
setopt auto_list            # 曖昧な補完で、自動的に選択肢をリストアップする
setopt auto_menu            # 補完を連打すると自動的にメニュー補完する
setopt always_last_prompt   # 補完してもスクロールしてかない
setopt always_to_end        # 単語の途中で「一意な補完」を実行した場合カーソルが末尾まで移動する
setopt auto_param_slash     # ディレクトリ名を保管すると末尾を / に
setopt auto_remove_slash    # 補完で末尾に補われた / が自動的に削除
# setopt complete_aliases
setopt list_types           # 補完でファイルをリストする時、末尾に / @ * とかのマークを付ける

setopt auto_resume
#setopt bash_auto_list
setopt brace_ccl
setopt chase_links              # Resolve symbolic links to their true values
setopt hash_cmds                # ykwkrn
setopt interactive_comments     # 対話シェルでもコメントを有効
setopt long_list_jobs           # ジョブリストがデフォルトでロングフォーマットになる
setopt magic_equal_subst        # ykwkrn
setopt multios                  # echo hoe >a >>b | less; みたいにマルチにリダイレクト出来る
setopt prompt_subst             # プロンプトが表示されるたびにプロンプト文字列を評価、置換する
setopt transient_rprompt        # コマンドを実行するときに右プロンプトを消す
setopt pushd_ignore_dups        # pushd で重複を無視
setopt rc_expand_param          # a=(a b c) の時に x${a} を保管すると "xa xb xc" 補完
setopt sh_word_split

unsetopt bg_nice
unsetopt flow_control
unsetopt hup
unsetopt list_ambiguous
unsetopt list_beep
unsetopt rm_star_silent

### Other ###
set bell-style visible
bindkey -e          # Emacs like keybind

### Completions ###
say "completions"
# if [ -f ~/ghq/github.com/agkozak/zsh-z/zsh-z.plugin.zsh ]; then
#     source ~/ghq/github.com/agkozak/zsh-z/zsh-z.plugin.zsh
# fi
fpath=(~/.zsh /usr/local/share/zsh/site-functions /usr/local/share/zsh-completions ${fpath})
autoload -U compinit; compinit -u >/dev/null 2>&1

compdef g=git

# port補完 http://d.hatena.ne.jp/hagure_beans/20101211/1292081391
if [ -d ~/.zsh/cache ]; then
    zstyle ':completion:*' use-cache yes
    zstyle ':completion:*' cache-path ~/.zsh/cache
fi

users=(
    monmon simon yamada ec2-user
)
_cache_hosts=(
    wakamatsuen.net
)
test -r ~/.zsh/git-flow-completion/git-flow-completion.zsh && source ~/.zsh/git-flow-completion/git-flow-completion.zsh

### 補完候補をオプションやディレクトリで分けて表示する ###
# 補完関数の表示を強化する
zstyle ':completion:*' verbose yes
#zstyle ':completion:*' completer _expand _complete _match _prefix _approximate _list _history
zstyle ':completion:*:messages' format '%F{green}%d'$DEFAULT
zstyle ':completion:*:warnings' format '%F{RED}No matches for:''%F{green} %d'$DEFAULT
zstyle ':completion:*:descriptions' format '%F{green}completing %B%d%b'$DEFAULT
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:descriptions' format '%F{green}Completing %B%d%b%f'$DEFAULT
# マッチ種別を別々に表示
zstyle ':completion:*' group-name ''

### MISC ###

# cd と同時に ls
function chpwd () {
    ls
}

# peco
# Ctrl-] でghqのリポジトリ一覧をpecoでリストし、フィルタしたリポジトリに移動
# cf. https://github.com/Songmu/ghq-handbook/blob/master/ja/05-ghq-list.md
peco-src () {
    local repo=$(ghq list | peco --query "$LBUFFER")
    if [ -n "$repo" ]; then
        repo=$(ghq list --full-path --exact $repo)
        BUFFER="cd ${repo}"
        zle accept-line
    fi
    zle clear-screen
}
zle -N peco-src
bindkey '^]' peco-src

# yarn
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

# gcloud
if [ -f ~/projects/google-cloud-sdk/path.zsh.inc ]; then
    source ~/projects/google-cloud-sdk/path.zsh.inc
fi
if [ -f ~/projects/google-cloud-sdk/completion.zsh.inc ]; then
    source ~/projects/google-cloud-sdk/completion.zsh.inc
fi

# # fzf
# [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# # fbr
# fbr() {
#   local branches branch
#   branches=$(git branch -vv) &&
#   branch=$(echo "$branches" | fzf +m) &&
#   git checkout $(echo "$branch" | awk '{print $1}' | sed "s/.* //")
# }

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

if __callable zoxide; then
    eval "$(zoxide init zsh)"
fi

# k8s
if __callable kubectl; then
    source <(kubectl completion zsh)
fi

# .zshrc.local
if [ -f ~/.zshrc.local ]; then
    . ~/.zshrc.local
fi

say FINISH .zshrc
