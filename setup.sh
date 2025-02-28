#!/bin/bash

while getopts "bvh" opt; do
    case $opt in
        b)
            backup=1
            ;;
        v)
            vim_jetpack=1
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
dot_files=$(ls -A | grep '^\.' | grep -vw "^\.\(DS_Store\|git\|gitignore\|gitmodules\|ssh_config\)$")
visible_files=$(ls -d bin lib)

# ドットファイルのシンボリックリンク作成
for f in $dot_files $visible_files; do
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

# git submodule
git submodule update -i

# vim-jetpackのパッケージをインストール
if [ "$vim_jetpack" = "1" -a ! -d ~/.vim/pack/jetpack/opt/nerdcommenter ]; then
    vim +JetpackSync +qall
fi
