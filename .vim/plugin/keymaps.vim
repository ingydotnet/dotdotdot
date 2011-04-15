imap  
 
" Fix delete
if &term == "xterm-color"
  set t_kb=
  fixdel
endif

map \` !G perl -MText::Autoformat -eautoformat<CR>))
map \8 <C-w>80<bar>
map \h <C-w>h<C-w><bar>
map \l <C-w>l<C-w><bar>
map \j <C-w>j<C-w>_
map \k <C-w>k<C-w>_
map \= <C-w>=
map \- <C-w>_
map \| <C-w><bar>
map \+ <C-^>

map \] :w<UP><CR>
map \[ :<UP><CR>

map \1 :w<CR>
map \2 :w<CR>:!perlcheck -Ilib %<CR>

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

map \d :.!echo -n 'date:    '; date<CR>

" Like ^] (tag lookup), but only in this file.  Sort of.  It looks for
" 'sub <cword>'.
map \<C-]> /<C-r>='\<sub ' . expand('<cword>') . '\>'<CR><CR>

map \gf :sp <cword><CR>

map \K :!LC_ALL=C perldoc %<CR>

noremap <C-l> :nohls<CR><C-l>
noremap! <C-l> <Esc>:nohls<CR><C-l>a
