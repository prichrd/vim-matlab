if exists("b:current_syntax")
  finish
endif

syn keyword matlabStatement   function return end break continue pause
syn keyword matlabConditional if elseif else switch case otherwise 
syn keyword matlabRepeat      for parfor while
syn keyword matlabException   try catch rethrow throw
syn keyword matlabConstant    eps flintmax Inf pi NaN
syn keyword matlabBoolean     true false

" match * / \ ^ ' .* ./ .\ .^ .'
syn match matlabOperator /\.\?[*/\\^']/
" match + -
syn match matlabOperator /[+-]/
" match = > < ~ == >= <= ~=
syn match matlabOperator /[=><~]=\?/
" match & | :
syn match matlabOperator /[&|:]/

" match integers
syn match matlabInteger /\<\d\+[ij]\=\>/
" match double values
syn match matlabDouble  /\<\d\+\(\.\d*\)\=\([edED][-+]\=\d\+\)\=[ij]\=\>/
" match double values
syn match matlabDouble  /\.\d\+\([edED][-+]\=\d\+\)\=[ij]\=\>/
" match string
syn region matlabString start=+'+ end=+'+	oneline contains=@Spell
syn region matlabString start=+"+ end=+"+	oneline contains=@Spell

" match highlights for comments
syn keyword matlabTodo contained TODO NOTE FIXME XXX
" match comments
syn match matlabComment /%.*$/ contains=matlabTodo,@Spell
" match block comment
syn region matlabBlockComment start=+%{+ end=+%}+ contains=@Spell

" match multiline indicator
syn match matlabMultiLine /\.\.\.$/

hi def link matlabStatement     Statement
hi def link matlabConditional   Conditional
hi def link matlabRepeat        Repeat
hi def link matlabException     Exception
hi def link matlabBoolean       Boolean
hi def link matlabConstant      Constant
hi def link matlabOperator      Operator
hi def link matlabInteger       Number
hi def link matlabDouble        Number
hi def link matlabString        String
hi def link matlabTodo          Todo
hi def link matlabComment       Comment
hi def link matlabBlockComment  Comment
hi def link matlabMultiLine     Comment

let b:current_syntax = "matlab"
