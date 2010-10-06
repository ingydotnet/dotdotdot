" No use for Ex mode; use Q for formatting.
map Q gq

map ` !G perl -MText::Autoformat -eautoformat<CR>))
map `j <C-W>j<C-w>_
map `k <C-W>k<C-w>_
map + <C-^>

imap  
 
" Fix delete
if &term == "xterm-color"
  set t_kb=
  fixdel
endif

map \] :w<UP><CR>
map \[ :<UP><CR>

map \\\ :noh<CR>:set nopaste<CR>:set nolist<CR>
map \q :q!<CR>
map \p :set paste<CR>
map \v :!vim .vimrc<CR>:so .vimrc<CR>
map \V :!vim ~/.vimrc<CR>:so ~/.vimrc<CR>
map \vf :!vim <cword><CR>:so <cword><CR>

map \# :s/^/# / <CR> :noh <CR>
map \\# :s/^# // <CR> :noh <CR>
map \/ :s,^,// , <CR> :noh <CR>
map \\/ :s,^// ,, <CR> :noh <CR>

" map \1 :up<CR> " ingy doesn't like this (yet)
map \1 :w<CR>
map \2 :up<CR>:!perlcheck -Ilib %<CR>
map \3 :up<CR>:call RunLastT()<CR>
map \4 :up<CR>:!prove -ls t<CR>
map \5 :up<CR>:!run-wiki-tests --fake-content-file %<CR>
map \6 :up<CR>:!make all install<CR>

map \d :.!echo -n 'date:    '; date<CR>
map \h :up<CR>:call TryPerlCompile()<CR>

" Like ^] (tag lookup), but only in this file.  Sort of.  It looks for
" 'sub <cword>'.
map \<C-]> /<C-r>='\<sub ' . expand('<cword>') . '\>'<CR><CR>

map \gf :sp <cword><CR>

map \K :!LC_ALL=C perldoc %<CR>

noremap <C-l> :nohls<CR><C-l>
noremap! <C-l> <Esc>:nohls<CR><C-l>a
