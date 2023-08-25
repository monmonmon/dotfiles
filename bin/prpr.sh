#!/usr/bin/env bash

if ! echo -n $PWD | grep -wq shokutsu-app; then
    echo ":P"
    exit
fi

cd ${PWD%shokutsu-app*}shokutsu-app

set -e
set -v

git checkout \
    package-lock.json \
    ios/Podfile.lock \
    ios/ShokutsuApp/Info.plist \
    ios/ShokutsuApp/GoogleService-Info.plist

branch_name=$(git branch | grep '^\*' | cut -d' ' -f2)
if git branch -vv | grep "$branch_name" | grep -wq origin; then
    git pull
fi

cp ios/ShokutsuApp/Info-Development.plist ios/ShokutsuApp/Info.plist
cp ios/ShokutsuApp/GoogleService-Info-Development.plist ios/ShokutsuApp/GoogleService-Info.plist
npm i --legacy-peer-deps
npx pod-install
