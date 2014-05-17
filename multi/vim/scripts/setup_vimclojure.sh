#! /bin/sh
# Downloads and builds clojure-contrib and vimclojure
# Gets files from git and hg using tagged downloads.
# Expects Clojure 1.0.0 (uses matching contrib)
# If you don't have the vimclojure vimfiles, see below to install
clojure_vim=$HOME/.clojure-vim
clojure_jar=/usr/share/java/clojure.jar
clojure_contrib_jar=$clojure_vim/clojure-contrib.jar
vimfiles=$HOME/.vim

mkdir $clojure_vim /tmp/vimclojure
cd /tmp/vimclojure

export CLASSPATH=$CLASSPATH:$clojure_jar

# Built jars with path to jars (progressively adding classpaths to bashrc):

curl http://github.com/richhickey/clojure-contrib/tarball/1.0.0 > clojure-contrib.tar.gz
tar xzf clojure-contrib.tar.gz
cd clojure-contrib/
ant -Dclojure.jar=$clojure_jar
read -p"Check for errors and press enter to continue"
mv *.jar $clojure_vim/.
cd -
export CLASSPATH=$CLASSPATH:$clojure_contrib_jar


curl http://bitbucket.org/kotarak/vimclojure/get/v2.1.2.tar.gz > vimclojure.tar.gz
tar xzf vimclojure.tar.gz
cd vimclojure/

cat >local.properties << EOF
clojure.jar = $clojure_jar
clojure-contrib.jar = $clojure_contrib_jar
nailgun-client = $clojure_vim/ng
vimdir = $vimfiles
EOF

ant -Dclojure-contrib.jar=$clojure_contrib_jar
read -p"Check for errors and press enter to continue"
mv ./build/*.jar $clojure_vim/.
make
mv ./ng $clojure_vim/.
mv ./ng.exe $clojure_vim/.
# Run install to copy vimclojure vim files, but daveconfig already has these
#ant -Dclojure-contrib.jar=$clojure_contrib_jar install
cd -

echo you may need to add this to your .bashrc:
echo export CLASSPATH=$CLASSPATH:$clojure_vim/vimclojure.jar
