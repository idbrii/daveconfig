#!/bin/bash

# https://github.com/samoshkin/vim-mergetool

if [[ -z $@ || $# != "5" ]] ; then
    echo -e "Usage: $0 \$EDITOR \$BASE \$LOCAL \$REMOTE \$MERGED"
    exit 1
fi

cmd=$1
BASE="$2"
LOCAL="$3"
REMOTE="$4"
MERGED="$5"

$cmd -f -c "MergetoolStart" "$MERGED" "$BASE" "$LOCAL" "$REMOTE"
