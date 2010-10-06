" lookupfile.vim: Lookup filenames by pattern
" Author: Hari Krishna (hari_vim at yahoo dot com)
" Last Change: 30-Aug-2006 @ 21:42
" Created:     11-May-2006
" Requires:    Vim-7.0, genutils.vim(1.2)
" Version:     1.4.1
" Licence: This program is free software; you can redistribute it and/or
"          modify it under the terms of the GNU General Public License.
"          See http://www.gnu.org/copyleft/gpl.txt 
" Download From:
"     http://www.vim.org//script.php?script_id=1581
" Usage:
"     See :help lookupfile.txt

if exists('loaded_lookupfile')
  finish
endif
if v:version < 700
  " echomsg 'lookupfile: You need at least Vim 7.0' " Noise sucks. -mml
  finish
endif
if !exists('loaded_genutils')
  runtime plugin/genutils.vim
endif
if !exists('loaded_genutils') || loaded_genutils < 200
  echomsg 'lookupfile: You need a newer version of genutils.vim plugin'
  finish
endif

let g:loaded_lookupfile = 1

" Make sure line-continuations won't cause any problem. This will be restored
"   at the end
let s:save_cpo = &cpo
set cpo&vim

if !exists('g:LookupFile_TagExpr')
  " Default tag expression.
  let g:LookupFile_TagExpr = '&tags'
endif

if !exists('g:LookupFile_LookupFunc')
  " An alternate user function to lookup matches.
  let g:LookupFile_LookupFunc = ''
endif

if !exists('g:LookupFile_LookupNotifyFunc')
  " The function that should be notified when a file is selected.
  let g:LookupFile_LookupNotifyFunc = ''
endif

if !exists('g:LookupFile_LookupAcceptFunc')
  " The function that should be notified when user presses <Enter>. This is
  " like handling the selection yourself.
  let g:LookupFile_LookupAcceptFunc = ''
endif

if !exists('g:LookupFile_MinPatLength')
  " Min. length of the pattern to trigger lookup.
  let g:LookupFile_MinPatLength = 4
endif

if !exists('g:LookupFile_PreservePatternHistory')
  " Show the past patterns also in the buffers.
  let g:LookupFile_PreservePatternHistory = 1
endif

if !exists('g:LookupFile_PreserveLastPattern')
  " Start with the last pattern when a new lookup is started.
  let g:LookupFile_PreserveLastPattern = 1
endif

if !exists('g:LookupFile_ShowFiller')
  " Show "Looking up files.." while the tags are being looked up.
  let g:LookupFile_ShowFiller = 1
endif

if !exists('g:LookupFile_AlwaysAcceptFirst')
  " Pressing <CR> or <C-O> when popup is visible always accepts the first
  " entry.
  let g:LookupFile_AlwaysAcceptFirst = 0
endif

if !exists('g:LookupFile_FileFilter')
  " A regular expression, which when matched against the result is filtered
  " out.
  let g:LookupFile_FileFilter = ''
endif

if !exists('g:LookupFile_AllowNewFiles')
  " If set, entering a non-existing filename will allow the plugin to create a
  " new buffer for it.
  let g:LookupFile_AllowNewFiles = 1
endif

if !exists('g:LookupFile_Bufs_SkipUnlisted')
  let g:LookupFile_Bufs_SkipUnlisted = 1
endif

if (! exists("no_plugin_maps") || ! no_plugin_maps) &&
      \ (! exists("no_lookupfile_maps") || ! no_lookupfile_maps)
  noremap <script> <silent> <Plug>LookupFile :LookupFile<CR>

  if !hasmapto('<Plug>LookupFile', 'n')
    silent! nmap <unique> <silent> <F5> <Plug>LookupFile
  endif
  if !hasmapto('<Plug>LookupFile', 'i')
    silent! imap <unique> <expr> <silent> <F5> (pumvisible()?"\<C-E>":"")."\<Esc>\<Plug>LookupFile"
  endif
endif

command! -nargs=? -bang -complete=file LookupFile :call lookupfile#OpenWindow("<bang>", <q-args>)

command! -nargs=? -bang -complete=file LUPath :call <SID>LookupUsing("<bang>", <q-args>, s:SNR().'LookupPath', g:LookupFile_MinPatLength)
command! -nargs=? -bang -complete=file LUArgs :call <SID>LookupUsing("<bang>", <q-args>, s:SNR().'LookupArgs', 0)
command! -nargs=? -bang -complete=file LUBufs :call <SID>LookupUsing("<bang>", <q-args>, s:SNR().'LookupBuf', 0) | call <SID>ConfigIdo('buffer')
command! -nargs=? -bang -complete=dir LUWalk :call <SID>LookupUsing("<bang>", <q-args>, s:SNR().'LookupIdo', 0) | call <SID>ConfigIdo('file')

let s:mySNR = ''
function! s:SNR()
  if s:mySNR == ''
    let s:mySNR = matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSNR$')
  endif
  return s:mySNR
endfun

let s:baseBufNr = 0
function! s:LookupUsing(bang, initPat, func, minPatLen)
  call s:SaveSett('LookupFunc')
  call s:SaveSett('LookupNotifyFunc')
  call s:SaveSett('MinPatLength')
  unlet! g:LookupFile_LookupFunc g:LookupFile_LookupNotifyFunc
  let g:LookupFile_LookupFunc = function(a:func)
  let g:LookupFile_LookupNotifyFunc = function(s:SNR().'LookupReset')
  let g:LookupFile_MinPatLength = a:minPatLen
  let s:baseBufNr = bufnr('%')
  exec 'LookupFile'.a:bang a:initPat
endfunction

function! s:LookupReset()
  if exists('s:saved')
    for sett in keys(s:saved)
      unlet! g:LookupFile_{sett}
      let g:LookupFile_{sett} = s:saved[sett]
    endfor
    unlet s:saved
  endif
  if exists('s:cleanup')
    for cmd in s:cleanup
      try
        exec cmd
      catch
        echoerr v:exception . ', while executing cleanup command: ' . cmd
      endtry
    endfor
    unlet s:cleanup
  endif
  aug ConfigIdo
    au!
  aug END
endfunction

function! s:SaveSett(sett)
  if !exists('s:saved')
    let s:saved = {}
  endif
  " Avoid overwriting the original value.
  if !has_key(s:saved, a:sett)
    let s:saved[a:sett] = g:LookupFile_{a:sett}
  endif
endfunction

function! s:AddCleanup(cmd)
  if !exists('s:cleanup')
    let s:cleanup = []
  endif
  if index(s:cleanup, a:cmd) == -1
    call add(s:cleanup, a:cmd)
  endif
endfunction

function! s:LookupPath(pattern)
  let files = globpath(&path, '*'.a:pattern.'*')
  return map(split(files, "\<NL>"), '{"word": v:val,'.
        \ '"abbr": fnamemodify(v:val, ":t"), "menu": fnamemodify(v:val, ":h")}')
endfunction

function! s:LookupBuf(pattern)
  let results = []
  let i = 1
  let lastBufNr = bufnr('$')
  while i <= lastBufNr
    try
      if ! bufexists(i)
        continue
      endif
      if g:LookupFile_Bufs_SkipUnlisted && ! buflisted(i)
        continue
      endif
      let fname = expand('#'.i.':p')
      let bname = fnamemodify(bufname(i), ':t')
      if bname =~ a:pattern
        call add(results, {
              \ 'word': fname,
              \ 'abbr': bname,
              \ 'menu': bufname(i),
              \ })
      endif
    finally
      let i = i + 1
    endtry
  endwhile
  return results
endfunction

function! s:LookupArgs(pattern)
  return filter(argv(), 'v:val =~ a:pattern')
endfunction

function! s:LookupIdo(pattern)
  " Determine the parent dir.
  let parent = matchstr(a:pattern, '^.*/')
  let filePat = strpart(a:pattern, len(parent))
  " We will wait till '/' is typed
  if filePat == '**'
    return []
  endif
  " Remove a leading or trailing '*' as we add it anyway. This also makes
  " '**' as '', but we handle this case above anyway.
  let filePat = substitute(filePat, '^\*\|\*$', '', 'g')
  "exec BPBreak(1)
  let _shellslash = &shellslash
  set shellslash
  try
    let files = glob(parent.((filePat != '') ? '*'.filePat.'*' : '*'))
  catch
    " Ignore errors in patterns.
    let files = ''
  finally
    let &shellslash = _shellslash
  endtry
  let fl = split(files, "\<NL>")
  let regexPat = s:TranslateFileRegex(filePat)
  " Find the start of path component that uses any of the *, [], ? or {
  " wildcard. Path until this is unambiguously common to all, so we can strip
  " it off, for brevity.
  let firstWildIdx = match(a:pattern, '[^/]*\%(\*\|\[\|?\|{\)')
  return s:FormatFileResults(fl, firstWildIdx!=-1 ? firstWildIdx : strlen(parent), regexPat)
endfunction

function! s:FormatFileResults(fl, parentLen, matchPat)
  let entries = []
  for f in a:fl
    let suffx = isdirectory(f)?'/':''
    let word = f.suffx
    let fname = matchstr(f, '[^/]*$')
    let dir = fnamemodify(f, ':h').'/'
    if dir != '/' && a:parentLen != -1
      let dir = strpart(dir, a:parentLen)
    else
      let dir = ''
    endif
    "let dir = (dir == '/'?'':dir)
    call add(entries, {
          \ 'word': word,
          \ 'abbr': fname.suffx,
          \ 'menu': (a:matchPat!='') ? dir.substitute(fname, (genutils#OnMS()?'\c':'').'\V'.a:matchPat, '[&]', '') : dir.fname,
          \ 'kind': suffx,
          \ })
  endfor
  return entries
endfunction

function! s:ConfigIdo(mode)
  if a:mode == 'buffer'
    " Allow switching to file mode.
    inoremap <expr> <buffer> <C-F> <SID>IdoSwitchTo('file')
    call s:AddCleanup('iunmap <buffer> <C-F>')
  else
    call s:SaveSett('LookupAcceptFunc')
    unlet! g:LookupFile_LookupAcceptFunc
    let g:LookupFile_LookupAcceptFunc = function(s:SNR().'IdoAccept')
    " Make sure we have the right slashes, in case user passed in init path
    " with wrong slashes.
    call setline('.', substitute(getline('.'), '\\', '/', 'g'))

    inoremap <buffer> <expr> <BS> <SID>IdoBS()
    call s:AddCleanup('iunmap <buffer> <BS>')
    imap <buffer> <expr> <Tab> <SID>IdoTab()
    call s:AddCleanup('iunmap <buffer> <Tab>')
    inoremap <expr> <buffer> <C-B> <SID>IdoSwitchTo('buffer')
    call s:AddCleanup('iunmap <buffer> <C-B>')
  endif
  aug ConfigIdo
    au!
    au BufHidden <buffer> call <SID>LookupReset()
  aug END
endfunction

function! s:IdoSwitchTo(mode)
  call s:LookupReset()
  if a:mode == 'buffer'
    let tok = matchstr(getline('.'), '[^/]*$')
    let cmd = 'LUBufs'.(tok == "" ? '!' : ' '.tok)
  else
    let cmd = 'LUWalk '.s:GetDefDir().getline('.')
  endif
  return (pumvisible()?"\<C-E>":'')."\<Esc>:".cmd."\<CR>"
endfunction

function! s:IdoAccept(splitWin, key)
  let refreshCmd = "\<C-O>:call lookupfile#LookupFile(0)\<CR>\<C-O>:\<BS>"
  if getline('.') !=# g:lookupfile#lastPattern && getline('.')[strlen(getline('.'))-1] == '/'
    return refreshCmd
  elseif getline('.') ==# g:lookupfile#lastPattern
        \ && len(g:lookupfile#lastResults) > 0
        \ && g:lookupfile#lastResults[0]['kind'] == '/'
    " When the first entry is a directory, accept it, and trigger a fresh
    " completion on that.
    return "\<C-N>\<C-R>=(getline('.') == lookupfile#lastPattern)?\"\\<C-N>\":''\<CR>".refreshCmd
  endif
  return lookupfile#AcceptFile(a:splitWin, a:key)
endfunction

function! s:IdoBS()
  if !pumvisible()
    return "\<BS>"
  elseif getline('.') !~ '/$'
    return "\<C-E>\<BS>"
  else
    " Determine the number of <BS>'s required to remove the patch component.
    let lastComp = matchstr(getline('.'), '[^/]*/$')
    return "\<C-E>".repeat("\<BS>", strlen(lastComp))
  endif
endfunction

function! s:IdoTab()
  " When no pattern yet, fill up with current directory.
  if !pumvisible() && getline('.') == ''
    return s:GetDefDir()
  else
    return "\<Tab>"
  endif
endfunction

function! s:GetDefDir()
  return substitute(expand('#'.s:baseBufNr.':p:h'), '\\', '/', 'g').'/'
endfunction

" Convert file wildcards ("*", "?" etc. |file-pattern|) to a Vim string
"   regex metachars (see |pattern.txt|). Returns metachars that work in "very
"   nomagic" mode.
let s:fileWild = {}
function! s:TranslateFileWild(fileWild)
  let strRegex = ''
  if a:fileWild ==# '*'
    let strRegex = '\[^/]\*'
  elseif a:fileWild ==# '**'
    let strRegex = '\.\*'
  elseif a:fileWild ==# '?'
    let strRegex = '\.'
  elseif a:fileWild ==# '['
    let strRegex = '\['
  endif
  return strRegex
endfunction

" Convert a |file-pattern| to a Vim string regex (see |pattern.txt|). Returns
"   patterns that work in "very nomagic" mode. No error checks for now,
"   for simplicity.
function! s:TranslateFileRegex(filePat)
  let pat = substitute(a:filePat, '\(\*\*\|\*\|\[\)',
        \ '\=s:TranslateFileWild(submatch(1))', 'g')
  let unprotectedMeta = genutils#CrUnProtectedCharsPattern('?,', 1)
  let pat = substitute(pat, unprotectedMeta,
        \ '\=s:TranslateFileWild(submatch(1))', 'g')
  return pat
endfunction

" Restore cpo.
let &cpo = s:save_cpo
unlet s:save_cpo

" vim6:fdm=marker et sw=2
