git diff --summary 2>&1 | grep -e "mode change" | cut -c30- | xargs git checkout
