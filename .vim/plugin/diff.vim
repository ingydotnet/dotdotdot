au FileType diff set iskeyword+=. iskeyword+=/ iskeyword+=-
au FileType diff map \fp :!prove -lv <cword><cr>
