#!/usr/bin/env bash
# Run "git pull" in all git repositories (only when its current branch is main or master) under the current directory

skipped=()
failed=()

basedir=$PWD
for g in */.git; do
    dir=$(dirname $g)
    echo
    echo "### $dir"
    cd $basedir/$dir
    repo=$(git rev-parse --abbrev-ref HEAD)
    # main / master ブランチかどうかチェック
    if [ $repo != main -a $repo != master ]; then
        echo "# $dir: skip non-master branch ($repo)"
        skipped=(${skipped[@]} $dir)
        continue
    fi
    # git pull
    if ! git pull; then
        echo "# $dir: failed to git pull"
        failed=(${failed[@]} $dir)
        continue
    fi
    # remote を掃除
    if ! git remote update --prune; then
        echo "# $dir: failed to update remote"
    fi
    # git submodule update
    if ! git submodule update; then
        echo "# $dir: failed to update remote"
    fi
done

echo
echo "skipped: ${skipped[@]}"
echo "failed: ${failed[@]}"