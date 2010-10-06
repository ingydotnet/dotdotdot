" vim:ft=vim
" If you call this, it works even if path is a symlink to a working copy.
function ResolvedShellCmd(cmd, path)
    exe '! ' . a:cmd . ' ' . resolve(expand(a:path))
endfunction

map \sCI :!scm ci<CR>
map \sD :!svndiff<cr>

map \sd :call ResolvedShellCmd('svndiff', '"%"')<cr>
map \sld :call ResolvedShellCmd('svnlastdiff', '"%"')<cr>
" v == verbose, cause this gives you the diff and the log both.
map \sv :call ResolvedShellCmd('svndifflog', '"%"')<cr>
map \sb :call ResolvedShellCmd('svnblame ', '"%"')<cr>
map \sl :call ResolvedShellCmd('svnlog ', '"%"')<cr>
map \sci :call ResolvedShellCmd('scm ci ', '"%"')<cr>
map \sREVERT :call ResolvedShellCmd('scm revert', '"%"')<cr>:e<cr>

" It would be interesting to figure out a way for files with spaces to work
" with these.  Mayhaps we should just use the visual selection || <cword>.
map \sfd :call ResolvedShellCmd('svndiff', '<cword>')<cr>
map \sfld :call ResolvedShellCmd('svnlastdiff', '<cword>')<cr>
" v == verbose, cause this gives you the diff and the log both.
map \sfv :call ResolvedShellCmd('svndifflog', '<cword>')<cr>
map \sfb :call ResolvedShellCmd('svnblame', '<cword>')<cr>
map \sfl :call ResolvedShellCmd('svnlog', '<cword>')<cr>
map \sfci :call ResolvedShellCmd('scm ci', '<cword>')<cr>
map \sfREVERT :call ResolvedShellCmd('scm revert', '<cword>')<cr>
