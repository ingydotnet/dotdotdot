imap <buffer> <C-x> var a=[],str='';for(p in )a.push(p);a.sort();alert(a.join(' '));<esc>5F)i

" 'Alert Here'
map <buffer> \ah :exec 'normal OXXX("' . expand('%:t') . ':' . line('.') . '");'<cr>
map <buffer> \ch :exec 'normal Oconsole.log("' . expand('%:t') . ':' . line('.') . '");'<cr>
