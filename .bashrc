if [ -f ~/.bashrc-common ]; then
    source ~/.bashrc-common
fi
if [ -f ~/.bashrc-local ]; then
    source ~/.bashrc-local
fi
if [ -f ~/.bashrc-$USER ]; then
    source ~/.bashrc-$USER
fi
if [ -f ~/.bashrc-$LOCAL ]; then
    source ~/.bashrc-$LOCAL;
fi
