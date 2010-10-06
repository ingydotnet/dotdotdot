syntax on
syntax sync fromstart

filetype plugin on
filetype indent on

set incsearch ignorecase smartcase history=9999 ruler laststatus=2 backspace=2
set autoindent expandtab tabstop=8 shiftwidth=4 softtabstop=4 smartindent
set textwidth=78
set autoread autowrite nobackup exrc ttyfast viminfo='20,\"500
set backspace=indent,eol,start hlsearch notimeout clipboard=
set suffixes=.bak,~,.o,.h,.info,.swp,.obj,.class wildmode=list:longest,full
set background=dark visualbell
set encoding=utf-8 termencoding=utf-8
set keywordprg=LC_ALL=C\ man

" For :vsp - vertically split windows
set splitright

" Ubuntu Dapper changed this to link to perlInclude, which sux0rs since it's
" *is* a statement and making it an include makes it a really ugly color.
highlight link perlStatementInclude perlStatement

au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g`\"" | endif

" Set :grep to use Andy's ack instead - http://perladvent.pm.org/2006/5/
set grepprg=ack
