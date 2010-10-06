# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the defaults are set in /etc/profile

if [ -f ~/.profile-common ]; then
    . ~/.profile-common
fi
if [ -f ~/.profile-local ]; then
    . ~/.profile-local
fi
if [ -f ~/.profile-$USER ]; then
    . ~/.profile-$USER
fi
if [ -f ~/.profile-$LOCAL ]; then
    . ~/.profile-$LOCAL;
fi

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi
