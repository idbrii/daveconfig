" Jenkins CI uses groovy and doesn't have dots in the name
" Ex: Steam-Jenkinsfile
au BufRead,BufNewFile Jenkinsfile,*-Jenkinsfile setf groovy
