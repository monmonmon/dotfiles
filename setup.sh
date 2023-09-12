#!/bin/bash

while getopts "bvh" opt; do
    case $opt in
        b)
            backup=1
            ;;
        v)
            vim_vundle=1
            ;;
        h)
            echo "Usage: $0 [-b] [-h]" >&2
            exit
            ;;
    esac
done
shift $(($OPTIND - 1))

# リポジトリのディレクトリパスを取得＆移動
basedir=$(cd $(dirname $0); pwd)
cd "$basedir"

# ホームディレクトリに設置するファイルリストを作成
dot_files=$(ls -A | grep '^\.' | grep -vw "^\.\(DS_Store\|git\|gitignore\|gitmodules\)$")
visible_files=$(ls -d bin lib)

# ドットファイルのシンボリックリンク作成
for f in $dot_files $visible_files; do
# for f in hoge hoe; do
    from_path=$basedir/"$f"
    target_path=~/"$f"
    if [ ! -e "$target_path" ]; then
        echo "$f"
        ln -sf "$from_path" "$target_path"
    else
        line=$(ls -ld $target_path)
        ftype="${line:0:1}"
        if [ "$backup" = "1" -a "$ftype" != "l" ]; then
            bak_path=~/"$f.BAK"
            echo "rename existing $target_path to $bak_path"
            mv -f "$target_path" "$bak_path"
            echo "$f"
            ln -sf "$from_path" "$target_path"
        else
            case "$ftype" in
                l) ftypestring="symlink" ;;
                d) ftypestring="directory" ;;
                *) ftypestring="regular file" ;;
            esac
            echo "$ftypestring already exists: $target_path"
        fi
    fi
done

# known_hosts に github.com を追加
# cf. https://docs.github.com/ja/authentication/keeping-your-account-and-data-secure/githubs-ssh-key-fingerprints
if ! grep -wq github.com ~/.ssh/known_hosts 2>/dev/null; then
    echo add github.com to ~/.ssh/known_hosts
    mkdir -p ~/.ssh
    chmod 700 ~/.ssh
    cat <<- HERE >> ~/.ssh/known_hosts
github.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl
github.com ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBEmKSENjQEezOmxkZMy7opKgwFB9nkt5YRrYMjNuG5N87uRgg6CLrbo5wAdT/y6v0mKV0U2w0WZ2YB/++Tpockg=
github.com ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCj7ndNxQowgcQnjshcLrqPEiiphnt+VTTvDP6mHBL9j1aNUkY4Ue1gvwnGLVlOhGeYrnZaMgRK6+PKCUXaDbC7qtbW8gIkhL7aGCsOr/C56SJMy/BCZfxd1nWzAOxSDPgVsmerOBYfNqltV9/hWCqBywINIR+5dIg6JTJ72pcEpEjcYgXkE2YEFXV1JHnsKgbLWNlhScqb2UmyRkQyytRLtL+38TGxkxCflmO+5Z8CSSNY7GidjMIZ7Q4zMjA2n1nGrlTDkzwDCsw+wqFPGQA179cnfGWOWRVruj16z6XyvxvjJwbz0wQZ75XK5tKSb7FNyeIEs4TT4jk+S4dhPeAUC5y+bDYirYgM4GC7uEnztnZyaVWQ7B381AK4Qdrwt51ZqExKbQpTUNn+EjqoTwvqNj4kqx5QUCI0ThS/YkOxJCXmPUWZbhjpCg56i+2aB6CmK2JGhn57K5mj0MNdBXA4/WnwH6XoPWJzK5Nyu2zB3nAZp+S5hpQs+p1vN1/wsjk=
HERE
    chmod 600 ~/.ssh/known_hosts
fi

# git submodule
git submodule update -i

# vimのセットアップ
if [ "$vim_vundle" = "1" -a ! -d ~/.vim/bundle/emmet-vim ]; then
    set -e
    # Vundleパッケージをインストール
    vim +PluginInstall +qall
    # vimprocをmake
    ( cd ~/.vim/bundle/vimproc.vim; make )
    set +e
fi
