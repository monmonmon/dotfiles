#!/usr/bin/env bash

current_branch () {
    git rev-parse --abbrev-ref HEAD
}

develop_branch () {
    if git branch -l develop | grep -q develop; then
        echo -n develop
    fi
}

main_or_master_branch () {
    if git branch -l main | grep -q main; then
        echo -n main
    elif git branch -l master | grep -q master; then
        echo -n master
    fi
}

usage () {
    echo "Usage: $(basename $0) [-d] [-m] [-h] [<branch 1> [<branch 2>]] " >&2
    exit
}

while getopts "dmh" opt; do
    case $opt in
        d)    # develop
            b1=$(develop_branch)
            b2=$(current_branch)
            ;;
        m)    # main / master
            b1=$(main_or_master_branch)
            b2=$(current_branch)
            ;;
        h)  # help
            usage
            ;;
    esac
done
shift $(($OPTIND - 1))

if [ -z "$b1$b2" ]; then
    if [ $# -eq 0 ]; then
        b1=$(main_or_master_branch)
        b2=$(develop_branch)
    elif [ $# -eq 1 ]; then
        b1=$(current_branch)
        b2=$1
    elif [ $# -eq 2 ]; then
        b1=$1
        b2=$2
    else
        usage
    fi
fi

if [ -z "$b1$b2" -o "$b1" = "$b2" ]; then
    echo ":p"
    exit
fi

git_log_format='format:%h %ad [%an]: %s'
git_log_date_format='format:%FT%R:%S'

if git log $b1..$b2 | grep -wq commit; then
    echo "### $b1..$b2 ###"
    echo
    git log --format="$git_log_format" --date="$git_log_date_format" $b1..$b2 | cat
    echo
    echo
fi

if git log $b2..$b1 | grep -wq commit; then
    echo "### $b2..$b1 ###"
    echo
    git log --format="$git_log_format" --date="$git_log_date_format" $b2..$b1 | cat
    echo
fi
