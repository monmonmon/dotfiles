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
    if [ $repo != master -a $repo != main ]; then
        echo "# $dir: skip non-master branch ($repo)"
        skipped=(${skipped[@]} $dir)
        continue
    fi
    if ! git pull; then
        echo "# $dir: failed to git pull"
        failed=(${failed[@]} $dir)
    fi
done

echo
echo "skipped: ${skipped[@]}"
echo "failed: ${failed[@]}"