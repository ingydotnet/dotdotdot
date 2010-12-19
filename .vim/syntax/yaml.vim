" Vim syntax file
" Language:         YAML (YAML Ain't Markup Language)
" Maintainer:       Oleksiy Golovko <alexei.golovko@gmail.com>
" Latest Revision:  2010-10-15


if exists("b:current_syntax")
    finish
endif

syntax clear

" ^\(\s*\)\S[^:]*:\s\+\S.\+\(\n\1\s\+\S.*\)*
"


syn match yStrContinued "\(\S\s*\n\)\@<=\s\+\S.*$" contains=yComment
hi link yStrContinued Constant

" --- contained structures
syn region yContStrQ1 matchgroup=Operator start="'" skip="''" 
    \ end="'" contained
syn region yContStrQ2 matchgroup=Operator start='"' skip='\\"' 
    \ end='"' contained
syn match yContKey "[^,:,{},\[\]]*:\s"me=e-2 contained
syn region yContObj matchgroup=Operator start="{" end="}" contained
    \ contains=@yContained
syn region yContArray matchgroup=Operator start="\[" end="\]" contained
    \ contains=@yContained
syn match yContColon ":" contained
syn match yContComma "," contained
syn match yContMinus "-" contained

"hi link yContStr Constant
hi link yContStrQ1 Constant
hi link yContStrQ2 Constant
hi link yContObj Constant
hi link yContArray Constant
hi link yContKey Identifier
hi link yContColon Operator
hi link yContComma Operator
hi link yContMinus Operator

syn cluster yContained contains=yContStrQ1,yContStrQ2,yContKey,yContObj,yContArray,yContColon,yContComma
" ---

" --- start of file 
syn region yFileStartStrQ1 matchgroup=Operator start="\%^\(\n\|\s\)*'" 
    \ skip="''" end="'"
syn region yFileStartStrQ2 matchgroup=Operator start='\%^\(\n\|\s\)*"' 
    \ skip='\\"' end='"'
syn region yFileStartObj matchgroup=Operator start="\%^\(\n\|\s\)*{" end="}"
    \ contains=@yContained
syn region yFileStartArray matchgroup=Operator start="\%^\(\n\|\s\)*\[" 
    \ end="\]" contains=@yContained

hi link yFileStartStrQ1 Constant
hi link yFileStartStrQ2 Constant
hi link yFileStartObj Constant
hi link yFileStartArray Constant
" ---

" --- start of document (---)

syn region yDocStartStrQ1 matchgroup=Operator start="^---\(\n\|\s\)*'" 
    \ skip="''" end="'"
syn region yDocStartStrQ2 matchgroup=Operator start='^---\(\n\|\s\)*"' 
    \ skip='\\"' end='"'
syn region yDocStartObj matchgroup=Operator start="^---\(\n\|\s\)*{" end="}"
    \ contains=@yContained
syn region yDocStartArray matchgroup=Operator start="^---\(\n\|\s\)*\[" 
    \ end="\]" contains=@yContained

hi link yDocStartStrQ1 Constant
hi link yDocStartStrQ2 Constant
hi link yDocStartObj Constant
hi link yDocStartArray Constant
" ---

" --- dictionary
syn region yKeyStr matchgroup=Operator start=":\s" end="$" oneline 
           \ contains=yComment
syn match yKey "^\s*-\{0,1\}\s*\S[^:]*:\(\s\|\n\)"me=e-2
           \ contains=yContStrQ1,yContStrQ2,yContMinus,yContColon

syn region yKeyStartStrQ1 matchgroup=Operator start=":\s*'" 
    \ skip="''" end="'"
syn region yKeyStartStrQ2 matchgroup=Operator start=':\s*"' 
    \ skip='\\"' end='"'
syn region yKeyStartObj matchgroup=Operator start=":\s*{" end="}"
    \ contains=@yContained
syn region yKeyStartArray matchgroup=Operator start=":\s*\[" 
    \ end="\]" contains=@yContained

hi link yKey Identifier
hi link yKeyStr Constant
hi link yKeyStartStrQ1 Constant
hi link yKeyStartStrQ2 Constant
hi link yKeyStartObj Constant
hi link yKeyStartArray Constant
" ---
"

syn region yComment start="#" end="$" keepend
hi link yComment Comment

"syn match yMapKey "^\s*\S[^:]*:"me=e-1 nextgroup=yMapStr,yMapObj,yMapArr
"hi link yMapKey Identifier

syntax sync fromstart

let b:current_syntax = "yaml"
