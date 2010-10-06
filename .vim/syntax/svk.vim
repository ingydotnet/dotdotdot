" Vim syntax file
" Language:	SVK commit file
"
" Totally cut-and-pasted from
" Language:	Subversion (svn) commit file
" Maintainer:	Dmitry Vasiliev <dima@hlabs.spb.ru>
" URL:		http://www.hlabs.spb.ru/vim/svn.vim
" Last Change:	$Date: 2003/06/10 11:55:20 $
" $Revision: 1.4 $

" For version 5.x: Clear all syntax items.
" For version 6.x: Quit when a syntax file was already loaded.
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

syn region svkRegion	start="=== Targets to commit (you may delete items from it) ===" end="\%$" contains=ALL
syn match svkRemoved	"^D   .*$" contained
syn match svkAdded	"^A[ M]  .*$" contained
syn match svkModified	"^M[ M]  .*$" contained
syn match svkProperty	"^_M  .*$" contained

" Synchronization.
syn sync clear
syn sync match svkSync	grouphere svkRegion "=== Targets to commit (you may delete items from it) ==="me=s-1

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already.
" For version 5.8 and later: only when an item doesn't have highlighting yet.
if version >= 508 || !exists("did_svk_syn_inits")
  if version <= 508
    let did_svk_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink svkRegion	Comment
  HiLink svkRemoved	Constant
  HiLink svkAdded	Identifier
  HiLink svkModified	Special
  HiLink svkProperty	Special

  delcommand HiLink
endif

let b:current_syntax = "svk"
