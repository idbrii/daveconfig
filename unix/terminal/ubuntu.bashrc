#! /bin/bash
#
# bashrc for Ubuntu
#

# if the command-not-found package is installed, use it
if [ -x /usr/lib/command-not-found ]; then
	function command_not_found_handle {
        # check because c-n-f could've been removed in the meantime
        if [ -x /usr/lib/command-not-found ]; then
		   /usr/bin/python /usr/lib/command-not-found -- $1
           return $?
		else
		   return 127
		fi
	}
fi


export ANDROID_HOME=$HOME/data/.android_devkit/android-sdk-linux_86

export ECLIM_ECLIPSE_HOME=$HOME/data/apps/eclipse

# Clojure
export CLASSPATH=/usr/share/java/clojure.jar:$HOME/.clojure-vim/clojure-contrib.jar:$HOME/.clojure-vim/clojure-contrib-slim.jar:$HOME/.clojure-vim/vimclojure.jar:$HOME/.clojure-vim/vimclojure-source.jar

# Set our primary development gpg key to be default
export GPGKEY=D4D6822E
