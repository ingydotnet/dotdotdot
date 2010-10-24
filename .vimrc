" Links for easy hopping (!!sh -v):
"ls" -1 ~/.vim/plugin | sort | perl -pe 's,^," ~/.vim/plugin/,'
" ~/.vim/plugin/basics.vim
" ~/.vim/plugin/cygwin-rxvt-broken-function-keys.vim
" ~/.vim/plugin/diff.vim
" ~/.vim/plugin/functionkeys.vim
" ~/.vim/plugin/gpg.vim
" ~/.vim/plugin/keymaps.vim
" ~/.vim/plugin/mail.vim
" ~/.vim/plugin/perl.vim
" ~/.vim/plugin/svn.vim

autocmd BufRead *.wiki set ft=wiki tw=0
au FileType vim set iskeyword+=. iskeyword+=/ iskeyword+=~
set splitright

set termencoding=utf-8
set encoding=utf-8
set fileencoding=utf-8
set pastetoggle=<F13>
set vb t_vb=

set exrc

" ============================================
" lookupfile.vim
" ============================================
nmap <unique> <silent> <C-S> :LUBufs ^.*<CR>
let g:LookupFile_AlwaysAcceptFirst=1
let g:LookupFile_PreserveLastPattern=0
let g:LookupFile_AllowNewFiles=0
let no_lookupfile_maps=1 

" ============================================
" open perl module with gf
" ============================================
autocmd FileType perl set isfname-=-

" ============================================
" statusline
" ============================================
set statusline=%y%{GetFileEncoding()}%F%m%r%=%c:%l%5(\ %)%3p%%

function! GetFileEncoding()
    let str = &fileformat . ']'
    if has('multi_byte') && &fileencoding != ''
        let str = &fileencoding . ':' . str
    endif
    let str = '[' . str
    return str
endfunction

" ============================================
" surround.vim
" ============================================
" gettextnize texts
let g:surround_103 = "loc('\r')"  " 103 = g
let g:surround_71 = "loc(\"\r\")" " 71 = G
nmap g' cs'g
nmap g" cs"G

" recognize .psgi files as perl
au BufNewFile,BufRead *.psgi set filetype=perl
