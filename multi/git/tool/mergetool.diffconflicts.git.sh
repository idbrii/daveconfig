#!/bin/bash

# https://github.com/samoshkin/vim-mergetool
# But I replaced MergetoolStart with Merge.

if [[ -z $@ || $# != "5" ]] ; then
    echo -e "Usage: $0 \$EDITOR \$BASE \$LOCAL \$REMOTE \$MERGED"
    exit 1
fi

cmd=$1
BASE="$2"
LOCAL="$3"
REMOTE="$4"
MERGED="$5"

$cmd -f -c "Merge" "$MERGED" "$BASE" "$LOCAL" "$REMOTE"
