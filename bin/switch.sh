#!/bin/bash
# apache <-> puma-dev をスイッチ
if pgrep -fl puma-dev >/dev/null; then
    echo switch to apache
    puma-dev -uninstall -d test
    sudo apachectl restart
else
    echo switch to puma-dev
    sudo apachectl stop
    puma-dev -install -d test
fi
