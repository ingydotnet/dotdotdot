runtime! syntax/perl.vim

" test_http
" The entire test_http block.  We use indentation of the left margin to
" find the matching curly brace.  Icky, but expeditious.
syn region testHttpBlock start=/^\z\(\s*\)test_http.*{/ end=/^\z1}/ contains=testHttpKeyword,testHttpRequestBlock
syntax keyword testHttpKeyword test_http contained skipwhite nextgroup=@perlExpr

" Request block.
syntax region testHttpRequestBlock start=/^\s*>> .*/ skip=/^\s*>>.*/ end=/\ze\(.\)/ contains=testHttpRequestHeaderLine,testHttpRequestStart,testHttpRequestBlank
syntax region testHttpRequestHeaderLine start=/^\s*>> [A-Za-z\-]\+:/ end=/$/ contained contains=testHttpRequestFleche,testHttpHeader,@perlInterpDQ
syntax region testHttpRequestStart start=/^\s*>> [^:]\+ .*/ end=/$/ contains=testHttpRequestFleche,testHttpMethod,@perlInterpDQ
"syntax match testHttpHeader /[A-Za-z-]: /he=e-2 contained
syntax match testHttpRequestFleche /^\s*>>/ contained
syntax keyword testHttpMethod GET PUT POST DELETE HEAD contained

" Common elements
syntax match testHttpHeader /[A-Za-z\-]\+:/he=e-1 contained

" __END__ and __DATA__ clauses
if exists("perl_fold")
  syntax region perlDATA		start="^__\(DATA\|END\)__$" skip="." end="." contains=TestLiveBlock fold
else
  syntax region perlDATA		start="^__\(DATA\|END\)__$" skip="." end="." contains=TestLiveBlock
endif

syntax region TestLiveBlock start="^===" end="^===" contains=TestLiveMatchSection,TestLiveNameSection,TestLiveDataSection contained

syntax region TestLiveNameSection start="^===" end="^\ze\(--- \|$\)" contains=TestLiveNameOperator contained

syntax match TestLiveNameOperator /^=== \+/ nextgroup=TestLiveName contained
syntax match TestLiveNameOperator /^===$/ contained
syntax match TestLiveName /.*$/ contained

syntax region TestLiveMatchSection start="^--- match\>" end="^\ze\(--- \|$\)" contains=TestLiveDataSpec,perlSpecialMatch contained

syntax region TestLiveDataSection start="^--- \(match\>\)\@!" end="^\ze\(--- \|$\)" contains=TestLiveDataSpec contained
syntax region TestLiveDataSpec start="^--- " end="$" contains=TestLiveDataOperator,TestLiveDataFilter contained
syntax match TestLiveDataOperator /^--- \+/ nextgroup=TestLiveDataName contained
syntax match TestLiveDataName /[^ :]\+\ze:\>/ contained nextgroup=TestLiveData
syntax match TestLiveDataName /[^ :]\+\>/ contained
syntax match TestLiveData /.*$/ contained
syntax match TestLiveDataFilter / \zs[^ ]\+/ contained

if version >= 508 || !exists("did_perl_syn_inits")
  if version < 508
    let did_perl_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink TestLiveNameOperator   perlOperator
  HiLink TestLiveName           perlPackageDecl
  HiLink TestLiveDataOperator   perlOperator
  HiLink TestLiveDataName       ModeMsg
  HiLink TestLiveDataFilter     perlIdentifier
  HiLink TestLiveMatchSection   perlQQ

  HiLink testHttpKeyword        perlRepeat
  HiLink testHttpRequestFleche  perlOperator
  HiLink testHttpHeader         perlString

  "HiLink testHttpBlock          ErrorMsg
  "HiLink testHttpRequestBlock ErrorMsg
  "HiLink testHttpRequestHeaderLine ErrorMsg

  delcommand HiLink
endif
