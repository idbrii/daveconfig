#! /bin/bash

# Requires gh and jq
#   apt-get install jq
#   https://github.com/cli/cli#installation
#
# Source: https://stackoverflow.com/a/65539398/79125
#
#
# Use when you forgot bto set short values for retention-days:
# 
#     - uses: actions/upload-artifact
#       with:
#         name: my-artifact
#         path: ./my_path
#         retention-days: 1

OWNER=idbrii
REPO=TODO
# copy the ID of the workflow you want to clear and set it
WORKFLOW_ID=TODO
# change to "destroy" when you're ready to lose data
DELETE_THEM_ALL=TODO


if [[ $WORKFLOW_ID == "TODO" ]]; then
    # list workflows to get a value for WORKFLOW_ID
    gh api -X GET /repos/$OWNER/$REPO/actions/workflows | jq '.workflows[] | .name,.id'

elif [[ $DELETE_THEM_ALL == "TODO" ]]; then
    # list runs to confirm what you're deleting
    gh api -X GET /repos/$OWNER/$REPO/actions/workflows/$WORKFLOW_ID/runs | jq '.workflow_runs[] | .id'

elif [[ $DELETE_THEM_ALL == "destroy" ]]; then
    # delete runs (you'll have to run this multiple times if there's many because of pagination)
    gh api -X GET /repos/$OWNER/$REPO/actions/workflows/$WORKFLOW_ID/runs | jq '.workflow_runs[] | .id' | xargs -I{} gh api -X DELETE /repos/$OWNER/$REPO/actions/runs/{}
fi
