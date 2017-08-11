" While I use g:vc_donot_confirm_cmd = 1, I want reverts to be confirmed.
" Please do confirm reverts
command! -n=* -com=customlist,vc#cmpt#Revert -bang VCRevert call david#svn#ConfirmRevert(<q-bang>, <f-args>)

