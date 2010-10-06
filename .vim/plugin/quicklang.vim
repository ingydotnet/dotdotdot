fu! ToggleSecondLang()
    if &keymap == ''
        echo "Switching to " . $SECOND_LANG
        exe "set keymap=" . $SECOND_LANG
    else
        echo "Switching to default language."
        set keymap=
    endif
endfu
