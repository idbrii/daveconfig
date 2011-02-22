#! /bin/sh

# Links everything in the current directory as a dotfile in home
# $PWD/configrc will linked by ~/.configrc

for a in `ls $PWD` ;do
    ln -s $PWD/$a ~/.$a
done

