if exists("did_load_filetypes")
    finish
endif
augroup filetypedetect
    au! BufNewFile,BufRead svk-commit*.tmp      setf svk

    au! BufNewFile,BufRead mason/*.html         setf mason
    au BufRead,BufNewFile *.mas set ft=mason

    au! BufNewFile,BufRead *.t                  setf perltest
    au! BufNewFile,BufRead *.hwd                setf hwd
    au! BufNewFile,BufRead *.st                 setf wiki
    au! BufNewFile,BufRead *.wiki               setf wiki

    au! BufNewFile,BufRead *.html
        \ if ( getline(1) . getline(2) . getline(3) =~ '\[%' ) |
        \   setf tt2html |
        \ else |
        \   setf html |
        \ endif
    au BufNewFile,BufRead *.tt2
        \ if ( getline(1) . getline(2) . getline(3) =~ '<\chtml'
        \           && getline(1) . getline(2) . getline(3) !~ '<[%?]' )
        \   || getline(1) =~ '<!DOCTYPE HTML' |
        \   setf tt2html |
        \ else |
        \   setf tt2 |
        \ endif
    "TT2 and HTML"
    :let b:tt2_syn_tags = '\[% %] <!-- -->'
augroup END

