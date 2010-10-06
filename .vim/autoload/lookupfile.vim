" lookupfile.vim: See plugin/lookupfile.vim

" Make sure line-continuations won't cause any problem. This will be restored
"   at the end
let s:save_cpo = &cpo
set cpo&vim

" Some onetime initialization of variables
if !exists('s:myBufNum')
  let s:windowName = '[Lookup File]'
  let s:myBufNum = -1
endif
let g:lookupfile#lastPattern = ""
let g:lookupfile#lastResults = []

function! lookupfile#OpenWindow(bang, initPat)
  let origWinnr = winnr()
  let _isf = &isfname
  let _splitbelow = &splitbelow
  set nosplitbelow
  try
    if s:myBufNum == -1
      " Temporarily modify isfname to avoid treating the name as a pattern.
      set isfname-=\
      set isfname-=[
      if exists('+shellslash')
        call genutils#OpenWinNoEa("1sp \\\\". escape(s:windowName, ' '))
      else
        call genutils#OpenWinNoEa("1sp \\". escape(s:windowName, ' '))
      endif
      let s:myBufNum = bufnr('%')
    else
      let winnr = bufwinnr(s:myBufNum)
      if winnr == -1
        call genutils#OpenWinNoEa('1sb '. s:myBufNum)
      else
        let wasVisible = 1
        exec winnr 'wincmd w'
      endif
    endif
  finally
    let &isfname = _isf
    let &splitbelow = _splitbelow
  endtry

  call s:SetupBuf()
  let initPat = ''
  if a:bang != ''
    let initPat = ''
  elseif a:initPat != ''
    let initPat = a:initPat
  elseif g:lookupfile#lastPattern != '' && g:LookupFile_PreserveLastPattern
    let initPat = g:lookupfile#lastPattern
  endif
  $
  if getline('.') !=# initPat
    silent! put=''
    call setline('.', initPat)
  endif
  startinsert!
  call s:LookupFileSet()
  aug LookupFileReset
    au!
    au CursorMovedI <buffer> call <SID>LookupFileSet()
    au CursorMoved <buffer> call <SID>LookupFileSet()
    au WinEnter <buffer> call <SID>LookupFileSet()
    au TabEnter <buffer> call <SID>LookupFileSet()
    au WinEnter * call <SID>LookupFileReset(0)
    au TabEnter * call <SID>LookupFileReset(0)
    au CursorMoved * call <SID>LookupFileReset(0)
    " Better be safe than sorry.
    au BufHidden <buffer> call <SID>LookupFileReset(1)
  aug END
endfunction

function! lookupfile#CloseWindow()
  if bufnr('%') != s:myBufNum
    return
  endif

  call s:LookupFileReset(1)
  close
endfunction

function! lookupfile#ClearCache()
  let g:lookupfile#lastPattern = ""
  let g:lookupfile#lastResults = []
endfunction

function! s:LookupFileSet()
  if bufnr('%') != s:myBufNum || exists('s:_backspace')
    return
  endif
  let s:_backspace = &backspace
  set backspace=start
  let s:_completeopt = &completeopt
  set completeopt+=menuone
endfunction

function! s:LookupFileReset(force)
  if a:force
    aug LookupFileReset
      au!
    aug END
  endif
  " Ignore the event while in the same buffer.
  if exists('s:_backspace') && (a:force || (bufnr('%') != s:myBufNum))
    let &backspace = s:_backspace
    let &completeopt = s:_completeopt
    unlet s:_backspace s:_completeopt
  endif
endfunction

function! s:SetupBuf()
  call genutils#SetupScratchBuffer()
  resize 1
  setlocal wrap
  setlocal bufhidden=hide
  setlocal winfixheight
  setlocal wrapmargin=0
  setlocal textwidth=0
  syn clear
  set ft=lookupfile
  " Setup maps to open the file.
  inoremap <silent> <buffer> <expr> <CR> <SID>AcceptFile(0, "\<CR>")
  inoremap <silent> <buffer> <expr> <C-O> <SID>AcceptFile(1, "\<C-O>")
  " This prevents the "Whole line completion" from getting triggered with <BS>,
  " however this might make the dropdown kind of flash.
  inoremap <buffer> <expr> <BS>       pumvisible()?"\<C-E>\<BS>":"\<BS>"
  " Make <C-Y> behave just like <CR>
  imap     <buffer> <expr> <C-Y>      pumvisible()?"\<CR>":"\<C-Y>"
  inoremap <buffer> <expr> <Esc>      pumvisible()?"\<C-E>\<C-C>":"\<Esc>"
  inoremap <buffer> <expr> <silent> <Down> pumvisible()?"\<C-N>\<C-R>=(getline('.') == lookupfile#lastPattern)?\"\\<Lt>C-N>\":''\<CR>":"\<Down>"
  inoremap <buffer> <expr> <silent> <Up>   pumvisible()?"\<C-P>\<C-R>=(getline('.') == lookupfile#lastPattern)?\"\\<Lt>C-P>\":''\<CR>":"\<Up>"
  inoremap <buffer> <expr> <PageDown> pumvisible()?"\<PageDown>\<C-P>\<C-N>":"\<PageDown>"
  inoremap <buffer> <expr> <PageUp>   pumvisible()?"\<PageUp>\<C-P>\<C-N>":"\<PageUp>"
  nnoremap <silent> <buffer> o :OpenFile<CR>
  nnoremap <silent> <buffer> O :OpenFile!<CR>
  command! -buffer -nargs=0 -bang OpenFile
        \ :call <SID>OpenCurFile('<bang>' != '')
  command! -buffer -nargs=0 -bang AddPattern :call <SID>AddPattern()
  nnoremap <buffer> <silent> <Plug>LookupFile :call lookupfile#CloseWindow()<CR>
  inoremap <buffer> <silent> <Plug>LookupFile <C-E><C-C>:call lookupfile#CloseWindow()<CR>

  aug LookupFile
    au!
    if g:LookupFile_ShowFiller
      au CursorMovedI <buffer> call <SID>ShowFiller()
    endif
    au CursorMovedI <buffer> call lookupfile#LookupFile(0)
  aug END
endfunction

function! s:AddPattern()
  if g:LookupFile_PreservePatternHistory
    silent! put! =g:lookupfile#lastPattern
    $
  endif
endfunction

function! s:AcceptFile(splitWin, key)
  if pumvisible()
    let acceptCmd = ''
    if type(g:LookupFile_LookupAcceptFunc) == 2 ||
          \ (type(g:LookupFile_LookupAcceptFunc) == 1 &&
          \  substitute(g:LookupFile_LookupAcceptFunc, '\s', '', 'g') != '')
      let acceptCmd = call(g:LookupFile_LookupAcceptFunc, [a:splitWin, a:key])
    else
      let acceptCmd = lookupfile#AcceptFile(a:splitWin, a:key)
    endif

    return acceptCmd
  else
    return a:key
  endif
endfunction

function! s:IsValid(fileName)
  if bufnr('%') != s:myBufNum
    return 0
  endif
  if a:fileName == ''
    return 0
  endif
  if !filereadable(a:fileName) && !isdirectory(a:fileName)
    if g:LookupFile_AllowNewFiles
      " Check if the parent directory exists, then we can create a new buffer
      " (Ido feature)
      let parent = fnamemodify(a:fileName, ':h')
      if parent != '' && !isdirectory(parent)
        return 0
      endif
    endif
  endif
  return 1
endfunction

function! lookupfile#AcceptFile(splitWin, key)
  if len(g:lookupfile#lastResults) == 0 && !s:IsValid(getline('.'))
    return "\<C-O>:echohl ErrorMsg | echo 'No such file or directory' | echohl NONE\<CR>"
  endif

  " Skip the first match, which is essentially the same as pattern.
  let nextCmd = "\<C-N>\<C-R>=(getline('.') == lookupfile#lastPattern)?\"\\<C-N>\":''\<CR>"
  let acceptCmd = "\<C-Y>\<Esc>:AddPattern\<CR>:OpenFile".(a:splitWin?'!':'').
        \ "\<CR>"
  if getline('.') ==# g:lookupfile#lastPattern
    if len(g:lookupfile#lastResults) == 0
      let acceptCmd = acceptCmd
    elseif len(g:lookupfile#lastResults) == 1 || g:LookupFile_AlwaysAcceptFirst
      " If there is only one file, we will also select it (if not already
      " selected)
      let acceptCmd = nextCmd.acceptCmd
    else
      let acceptCmd = nextCmd
    endif
  endif

  return acceptCmd
endfunction

function! s:OpenCurFile(splitWin)
  let fileName = getline('.')
  if fileName =~ '^\s*$'
    return
  endif
  if !s:IsValid(fileName)
    echohl ErrorMsg | echo 'No such file or directory' | echohl NONE
  endif

  if type(g:LookupFile_LookupNotifyFunc) == 2 ||
        \ (type(g:LookupFile_LookupNotifyFunc) == 1 &&
        \  substitute(g:LookupFile_LookupNotifyFunc, '\s', '', 'g') != '')
    call call(g:LookupFile_LookupNotifyFunc, [])
  endif
  call lookupfile#CloseWindow()

  let winnr = bufwinnr(genutils#FindBufferForName(fileName))
  if winnr != -1
    exec winnr.'wincmd w'
  else
    let splitOpen = 0
    if &switchbuf ==# 'split' || a:splitWin
      let splitOpen = 1
    endif
    " First try opening as a buffer, if it fails, we will open as a file.
    try
      exec (splitOpen?'s':'').'buffer' fileName
    catch
      exec (splitOpen?'split':'edit') fileName
    endtry
  endif
endfunction

function! s:ShowFiller()
  return lookupfile#LookupFile(1)
endfunction

function! lookupfile#LookupFile(showingFiller)
  let pattern = getline('.')
  if pattern == "" || (pattern ==# g:lookupfile#lastPattern && pumvisible())
    return ""
  endif
  " The normal completion behavior is to stop completion when cursor is moved.
  if col('.') == 1 || (col('.') != col('$'))
    return ""
  endif

  let statusMsg = ''
  if strlen(pattern) < g:LookupFile_MinPatLength
    let statusMsg = '<<< Type at least '.g:LookupFile_MinPatLength.
          \ ' characters >>>'
    let files = []
  " We ignore filler when we have the result in hand.
  elseif g:lookupfile#lastPattern ==# pattern
    " This helps at every startup as we start with the previous pattern.
    let files = g:lookupfile#lastResults
  elseif a:showingFiller
    " Just show a filler and return. We could return this as the only match, but
    " unless 'completeopt' has "menuone", menu doesn't get shown.
    let statusMsg = '<<< Looking up files... hit ^C to break >>>'
    let files = []
  else
    if type(g:LookupFile_LookupFunc) == 2 ||
          \ (type(g:LookupFile_LookupFunc) == 1 &&
          \  substitute(g:LookupFile_LookupFunc, '\s', '', 'g') != '')
      let files = call(g:LookupFile_LookupFunc, [pattern])
    else
      let _tags = &tags
      try
        let &tags = eval(g:LookupFile_TagExpr)
        let tags = taglist(pattern)
      catch
        echohl ErrorMsg | echo "Exception: " . v:exception | echohl NONE
        return ""
      finally
        let &tags = _tags
      endtry

      " Show the matches for what is typed so far.
      let files = map(tags, 'v:val["filename"]')
    endif

    let pat = g:LookupFile_FileFilter
    if pat != ''
      call filter(files, '(type(v:val) == 4) ? v:val["word"] !~ pat : v:val !~ pat')
    endif

    call sort(files)
    let g:lookupfile#lastPattern = pattern
    let g:lookupfile#lastResults = files
  endif
  if statusMsg == ''
    if len(files) > 0
      let statusMsg = '<<< '.len(files).' Matching >>>'
    else
      let statusMsg = '<<< None Matching >>>'
    endif
  endif
  let abbr = pattern
  " NOTE: The following is not applicable anymore, as we don't support showing
  " completion menu when not in the middle of the pattern.
  "if col('.') != col('$')
  "  let pattern = strpart(pattern, 0, col('.')-1)
  "endif
  call complete(1, [{'word': pattern, 'abbr': abbr, 'menu': statusMsg}]+files)
  return ""
endfunction

" Restore cpo.
let &cpo = s:save_cpo
unlet s:save_cpo

" vim6:fdm=marker et sw=2
