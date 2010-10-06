if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

" the "done" detection could be better here... any X in the string will
" highlight when we define it this way:
syn match hwdWorkDone "X" contained
syn match hwdWorkEnd ".*" contains=hwdWorkDone contained
syn match hwdWorkTime "\d\+\(\.\d\+\)*h\?\>" nextgroup=hwdWorkEnd contained
syn match hwdWorkId "\d\+\>" nextgroup=hwdWorkTime skipwhite contained
syn match hwdWorkDate "\(\(\d\{1,2\}\)\{1,2\}/\)\?\d\{1,2\}/\d\{1,2\}\>" nextgroup=hwdWorkId skipwhite contained

syn case ignore
syn match hwdWork /^[a-z]\+\>/ nextgroup=hwdWorkDate skipwhite

syn match hwdSpecId "#\d\+\>" contained
syn match hwdSpecTime "\d\+\(\.\d\+\)*h\>" contained
syn match hwdSpecWhence "added \(\(\d\{1,2\}\)\{1,2\}/\)\?\d\{1,2\}/\d\{1,2\}\>" contained
syn cluster hwdSpec contains=hwdSpecId,hwdSpecTime,hwdSpecWhence
syn match hwdTaskDesc ".*" contains=hwdTaskSpec contained skipwhite
syn match hwdTaskSpec "(.\+,.\+\(,.\+\)\?)\s*$" contains=@hwdSpec contained skipwhite
syn match hwdTask /^-\+/ nextgroup=hwdTaskDesc 

syn keyword hwdTodo contained TODO FIXME XXX
syn match hwdComment /^#.*$/ contains=hwdTodo

"
" highlighting defs
"
hi def link hwdComment      Comment
hi def link hwdTodo         Todo

hi def link hwdTask         Special
hi def link hwdTaskDesc     Normal
hi def link hwdTaskSpec     Normal
hi def link hwdSpecTime     hwdHiTime
hi def link hwdSpecWhence   hwdHiDate
hi def link hwdSpecId       hwdHiId

hi def link hwdWork         Special
hi def link hwdWorkTime     hwdHiTime
hi def link hwdWorkDate     hwdHiDate
hi def link hwdWorkId       hwdHiId
hi def link hwdWorkDone     SpecialChar
hi def link hwdWorkEnd      Normal
"
"
" highlighting classes
"
hi def link hwdHiTime       Number
hi def link hwdHiDate       Type
hi def link hwdHiId         Identifier

let b:current_syntax = "hwd"
