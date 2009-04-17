snippetfile=$1
if [ $# -eq 0 ] ; then
    echo Usage: ./listSnippets.sh python_snippets.vim 
    exit -1
fi
grep -B1 Snippet $snippetfile | cut -d\" -f2 | grep -v -e exec -e -- -e"^$"
