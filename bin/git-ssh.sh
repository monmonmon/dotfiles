#!/bin/bash
# cf. git clone 時に秘密鍵を指定する - Qiita
# http://qiita.com/sonots/items/826b90b085f294f93acf
# Usage:
# git-ssh.sh -i ~/.ssh/bv0003_id_rsa clone git@github.com:bv0003/pokeme_rails.git

usage_exit() {
    echo "Usage: $0 [-i identity_file] -- [GIT ARGUMENTS]" 1>&2
    exit 1
}

while getopts i:h OPT
do
    case $OPT in
        i) IDENTITY_FILE=$OPTARG
           ;;
        h) usage_exit
           ;;
    esac
done
shift $((OPTIND - 1))

if [ -n "$IDENTITY_FILE" ]; then
    tempfile=$(mktemp)
    cat <<EOF > $tempfile
#!/bin/sh
exec ssh -oIdentityFile=${IDENTITY_FILE} "\$@"
EOF
    chmod a+x $tempfile
    GIT_SSH=$tempfile git $@
    rm -f $tempfile
else
    git $@
fi
