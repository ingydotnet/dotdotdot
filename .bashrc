if [ -f ~/.bashrc-common ]; then
    . ~/.bashrc-common
fi
if [ -f ~/.bashrc-local ]; then
    . ~/.bashrc-local
fi
if [ -f ~/.bashrc-$USER ]; then
    . ~/.bashrc-$USER
fi
if [ -f ~/.bashrc-$LOCAL ]; then
    . ~/.bashrc-$LOCAL;
fi
