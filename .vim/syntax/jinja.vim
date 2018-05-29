if exists("b:current_syntax")
  finish
endif

syntax case match

" Jinja template built-in tags and parameters (without filter, macro, is and raw, they
" have special threatment)
syn keyword jinjaStatement containedin=jinjaVarBlock,jinjaTagBlock,jinjaNested contained and if else in not or recursive as import

syn keyword jinjaStatement containedin=jinjaVarBlock,jinjaTagBlock,jinjaNested contained is filter skipwhite nextgroup=jinjaFilter
syn keyword jinjaStatement containedin=jinjaTagBlock contained macro skipwhite nextgroup=jinjaFunction
syn keyword jinjaStatement containedin=jinjaTagBlock contained block skipwhite nextgroup=jinjaBlockName

" Variable Names
syn match jinjaVariable containedin=jinjaVarBlock,jinjaTagBlock,jinjaNested contained skipwhite /[a-zA-Z_][a-zA-Z0-9_]*/
syn keyword jinjaSpecial containedin=jinjaVarBlock,jinjaTagBlock,jinjaNested contained false true none loop super caller varargs kwargs

" Filters
syn match jinjaOperator "|" containedin=jinjaVarBlock,jinjaTagBlock,jinjaNested contained skipwhite nextgroup=jinjaFilter
" syn match jinjaFilter contained skipwhite /[a-zA-Z_][a-zA-Z0-9_]*/
syn keyword jinjaFilter contained abs attr batch capitalize center default
syn keyword jinjaFilter contained dictsort escape filesizeformat first
syn keyword jinjaFilter contained float forceescape format groupby indent
syn keyword jinjaFilter contained int join last length list lower pprint
syn keyword jinjaFilter contained random replace reverse round safe slice
syn keyword jinjaFilter contained sort string striptags sum
syn keyword jinjaFilter contained title trim truncate upper urlize
syn keyword jinjaFilter contained wordcount wordwrap
" ansible jinja filters
syn keyword jinjaFilter contained to_json to_yaml to_nice_json to_nice_yaml from_json from_yaml
syn keyword jinjaFilter contained mandatory
syn keyword jinjaFilter contained min max flatten unique union intersect difference symmetric_difference shuffle combine map
syn keyword jinjaFilter contained log pow root
syn keyword jinjaFilter contained json_query
syn keyword jinjaFilter contained ipaddr ipv4 ipv6
syn keyword jinjaFilter contained parse_cli parse_cli_textfsm parse_xml
syn keyword jinjaFilter contained hash checksum password_hash
syn keyword jinjaFilter contained comment
syn keyword jinjaFilter contained url_split regex_search regex_findall regex_replace
syn keyword jinjaFilter contained quote
syn keyword jinjaFilter contained ternary
syn keyword jinjaFilter contained basename win_basename win_splitdrive dirname win_dirname
syn keyword jinjaFilter contained expanduser
syn keyword jinjaFilter contained realpath relpath splitext
syn keyword jinjaFilter contained b64decode b64encode
syn keyword jinjaFilter contained to_uuid bool to_datetime strftime
syn keyword jinjaFilter contained permutations combinations zip zip_longest
syn keyword jinjaFilter contained type_debug
syn match jinjaFunction contained skipwhite /[a-zA-Z_][a-zA-Z0-9_]*/
syn match jinjaBlockName contained skipwhite /[a-zA-Z_][a-zA-Z0-9_]*/

" Jinja template constants
syn region jinjaString containedin=jinjaVarBlock,jinjaTagBlock,jinjaNested contained start=/"/ skip=/\(\\\)\@<!\(\\\\\)*\\"/ end=/"/
syn region jinjaString containedin=jinjaVarBlock,jinjaTagBlock,jinjaNested contained start=/'/ skip=/\(\\\)\@<!\(\\\\\)*\\'/ end=/'/
syn match jinjaNumber containedin=jinjaVarBlock,jinjaTagBlock,jinjaNested contained /[0-9]\+\(\.[0-9]\+\)\?/

" Operators
syn match jinjaOperator containedin=jinjaVarBlock,jinjaTagBlock,jinjaNested contained /[+\-*\/<>=!,:~%]/
syn match jinjaPunctuation containedin=jinjaVarBlock,jinjaTagBlock,jinjaNested contained /[()\[\]]/
syn match jinjaOperator containedin=jinjaVarBlock,jinjaTagBlock,jinjaNested contained /\./ nextgroup=jinjaAttribute
syn match jinjaAttribute contained /[a-zA-Z_][a-zA-Z0-9_]*/

" Jinja template tag and variable blocks
syn region jinjaNested matchgroup=jinjaDelimiter start="(" end=")" transparent display containedin=jinjaVarBlock,jinjaTagBlock,jinjaNested contained
syn region jinjaNested matchgroup=jinjaOperator start="\[" end="\]" transparent display containedin=jinjaVarBlock,jinjaTagBlock,jinjaNested contained
syn region jinjaNested matchgroup=jinjaDelimiter start="{" end="}" transparent display containedin=jinjaVarBlock,jinjaTagBlock,jinjaNested contained
syn region jinjaTagBlock matchgroup=jinjaTagDelim start=/{%-\?/ end=/-\?%}/ skipwhite containedin=ALLBUT,jinjaTagBlock,jinjaVarBlock,jinjaRaw,jinjaString,jinjaNested,jinjaComment

syn region jinjaVarBlock matchgroup=jinjaVarDelim start=/{{-\?/ end=/-\?}}/ containedin=ALLBUT,jinjaTagBlock,jinjaVarBlock,jinjaRaw,jinjaString,jinjaNested,jinjaComment

" Jinja template 'raw' tag
syn region jinjaRaw matchgroup=jinjaRawDelim start=/{%-\?\s*raw\s*-\?%}/ end=/{%-\?\s*endraw\s*-\?%}/ containedin=ALLBUT,jinjaTagBlock,jinjaVarBlock,jinjaString,jinjaComment contains=TOP,@Jinja fold

" Jinja comments
syn region jinjaComment matchgroup=jinjaCommentDelim start="{#" end="#}" containedin=ALLBUT,jinjaTagBlock,jinjaVarBlock,jinjaString

" Block start keywords.  A bit tricker.  We only highlight at the start of a
" tag block and only if the name is not followed by a comma or equals sign
" which usually means that we have to deal with an assignment.
syn match jinjaStatement containedin=jinjaTagBlock contained skipwhite /\(^\s*%\s*\|{%-\?\s*\)\@<=\<[a-zA-Z_][a-zA-Z0-9_]*\>\(\s*[,=]\)\@!/

" and context modifiers
syn match jinjaStatement containedin=jinjaTagBlock contained /\<with\(out\)\?\s\+context\>/ skipwhite

" line statements set to %
syn region jinjaTagBlock matchgroup=jinjaTagDelim start=#^\s*%# end=#$# keepend containedin=ALLBUT,jinjaTagBlock,jinjaVarBlock,jinjaRaw,jinjaString,jinjaNested,jinjaComment

" Block regions so that we can do syntax folding on jinja blocks. There's some
" nuance involved with the start/end pattern matching and matchgroups, in
" regards to colliding with the jinjaTagBlock pattern.
syn region jinjaBlockAutoescape contains=TOP containedin=ALLBUT,jinjaRaw,jinjaTagBlock,jinjaVarBlock,jinjaString,jinjaComment fold start=/\c{%-\?\s*autoescape \(true\|false\)\s*-\?%}/ matchgroup=jinjaBlockEnd end=/{%-\?\(\s*endautoescape\s*-\?%}\)\@=/ nextgroup=jinjaBlockEndStatement skipwhite
syn region jinjaBlockBlock contains=TOP containedin=ALLBUT,jinjaRaw,jinjaTagBlock,jinjaVarBlock,jinjaString,jinjaComment fold start=/{%-\?\s*block \w\+\s*-\?%}/ matchgroup=jinjaBlockEnd end=/{%-\?\(\s*endblock\s*\w*\s*-\?%}\)\@=/ nextgroup=jinjaBlockEndStatement skipwhite
syn region jinjaBlockCall contains=TOP containedin=ALLBUT,jinjaRaw,jinjaTagBlock,jinjaVarBlock,jinjaString,jinjaComment fold start=/{%-\?\s*call\>/ matchgroup=jinjaBlockEnd end=/{%-\?\(\s*endcall\s*-\?%}\)\@=/ nextgroup=jinjaBlockEndStatement skipwhite
syn region jinjaBlockFilter contains=TOP containedin=ALLBUT,jinjaRaw,jinjaTagBlock,jinjaVarBlock,jinjaString,jinjaComment fold start=/{%-\?\s*filter\>/ matchgroup=jinjaBlockEnd end=/{%-\?\(\s*endfilter\s*-\?%}\)\@=/ nextgroup=jinjaBlockEndStatement skipwhite
syn region jinjaBlockFor contains=TOP containedin=ALLBUT,jinjaRaw,jinjaTagBlock,jinjaVarBlock,jinjaString,jinjaComment fold start=/{%-\?\s*for / matchgroup=jinjaBlockEnd end=/{%-\?\(\s*endfor\s*-\?%}\)\@=/ nextgroup=jinjaBlockEndStatement skipwhite
syn region jinjaBlockIf contains=TOP containedin=ALLBUT,jinjaRaw,jinjaTagBlock,jinjaVarBlock,jinjaString,jinjaComment fold start=/{%-\?\s*if / matchgroup=jinjaBlockEnd end=/{%-\?\(\s*endif\s*-\?%}\)\@=/ nextgroup=jinjaBlockEndStatement skipwhite
syn region jinjaBlockMacro contains=TOP containedin=ALLBUT,jinjaRaw,jinjaTagBlock,jinjaVarBlock,jinjaString,jinjaComment fold start=/{%-\?\s*macro / matchgroup=jinjaBlockEnd end=/{%-\?\(\s*endmacro\s*-\?%}\)\@=/ nextgroup=jinjaBlockEndStatement skipwhite
" This will technically fail to determine the start of a set block if it uses
" the filter syntax and the filter has a string argument containing an equals
" sign, but that's an almost pathological corner case
syn region jinjaBlockSet contains=TOP containedin=ALLBUT,jinjaRaw,jinjaTagBlock,jinjaVarBlock,jinjaString,jinjaComment fold start=/{%-\?\s*set [^=]\{-}%}/ matchgroup=jinjaBlockEnd end=/{%-\?\(\s*endset\s*-\?%}\)\@=/ nextgroup=jinjaBlockEndStatement skipwhite
syn region jinjaBlockTrans contains=TOP containedin=ALLBUT,jinjaRaw,jinjaTagBlock,jinjaVarBlock,jinjaString,jinjaComment fold start=/{%-\?\s*trans / matchgroup=jinjaBlockEnd end=/{%-\?\(\s*endtrans\s*-\?%}\)\@=/ nextgroup=jinjaBlockEndStatement skipwhite
syn region jinjaBlockWith contains=TOP containedin=ALLBUT,jinjaRaw,jinjaTagBlock,jinjaVarBlock,jinjaString,jinjaComment fold start=/{%-\?\s*with / matchgroup=jinjaBlockEnd end=/{%-\?\(\s*endwith\s*-\?%}\)\@=/ nextgroup=jinjaBlockEndStatement skipwhite
" This is some ugly nonsense to get proper syntax highlighting on block-ending
" tags.
syn match jinjaBlockEndStatement contained /end\w\+/ nextgroup=jinjaBlockEndTag skipwhite
syn match jinjaBlockEndTag contained /-\?%}/
hi def link jinjaBlockEndStatement jinjaStatement
hi def link jinjaBlockEndTag jinjaTagDelim

" Every jinja syntax group. This is for jinjaRaw, effectively - we want
" jinjaRaw to include non-jinja syntax, but no jinja syntax.
syn cluster Jinja contains=jinjaAttribute,jinjaBlockAutoescape,jinjaBlockBlock,jinjaBlockCall,jinjaBlockFilter,jinjaBlockFor,jinjaBlockIf,jinjaBlockMacro,jinjaBlockName,jinjaBlockSet,jinjaBlockTrans,jinjaBlockWith,jinjaComment,jinjaFilter,jinjaFunction,jinjaNested,jinjaNumber,jinjaOperator,jinjaPunctuation,jinjaRaw,jinjaSpecial,jinjaStatement,jinjaString,jinjaTagBlock,jinjaVarBlock,jinjaVariable

hi def link jinjaPunctuation jinjaOperator

hi def link jinjaTagDelim PreProc
hi def link jinjaVarDelim PreProc
hi def link jinjaRawDelim jinjaVarDelim
hi def link jinjaDelimiter Delimiter
hi def link jinjaCommentDelim jinjaComment
hi def link jinjaBlockEnd jinjaTagDelim

hi def link jinjaSpecial Special
hi def link jinjaOperator Normal
hi def link jinjaRaw Normal
hi def link jinjaTagBlock Normal
hi def link jinjaVarBlock Normal
hi def link jinjaStatement Statement
hi def link jinjaFilter Function
hi def link jinjaFunction Function
hi def link jinjaBlockName Function
hi def link jinjaVariable Normal
hi def link jinjaAttribute Identifier
hi def link jinjaString Constant
hi def link jinjaNumber Constant
hi def link jinjaComment Comment

let b:current_syntax = "jinja"
