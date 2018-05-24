setlocal sw=2 ts=2 sts=2 et
finish
" This function is from https://gist.github.com/871107
" Author: Ian Young
"
" function! GetYamlIndent()
"   let cnum = v:lnum
"   let lnum = v:lnum - 1
"   if lnum == 0
"     return 0
"   endif
"   let line = substitute(getline(lnum),'\s\+$','','')
"   let cline = substitute(getline(cnum),'\s\+$','','')
"   let indent = indent(lnum)
"   let increase = indent + &sw
"   let decrease = indent - &sw
"   if line =~ ':$'
"     return increase
"   elseif line !~ ':$' && cline =~ ':$'
"     return decrease
"   elseif line =~ ':$'
"   else
"     return indent
"   endif
" endfunction

" setlocal indentexpr=GetYamlIndent()
"
"" Vim indent file
" Language:        YAML (with Ansible)
" Maintainer:      Benji Fisher, Ph.D. <benji@FisherFam.org>
" Author:          Chase Colman <chase@colman.io>
" Version:         1.0
" Latest Revision: 2014-11-18
" URL:             https://github.com/chase/vim-ansible-yaml

" Only load this indent file when no other was loaded.
if exists("b:did_indent")
  finish
endif

let b:did_indent = 1

setlocal sw=2 ts=2 sts=2 et
setlocal indentexpr=GetAnsibleIndent(v:lnum)
setlocal indentkeys=!^Fo,O,0#,<:>,-
setlocal nosmartindent

function! s:isInBlock(hlstack)
  return index(a:hlstack, 'haskellDelimiter') > -1 || index(a:hlstack, 'haskellParens') > -1 || index(a:hlstack, 'haskellBrackets') > -1 || index(a:hlstack, 'haskellBlock') > -1 || index(a:hlstack, 'haskellBlockComment') > -1 || index(a:hlstack, 'haskellPragma') > -1
endfunction
function! s:isSYN(grp, line, col)
  return index(s:getHLStack(a:line, a:col), a:grp) != -1
endfunction

function! s:getNesting(hlstack)
  return filter(a:hlstack, 'v:val == "haskellBlock" || v:val == "haskellBrackets" || v:val == "haskellParens" || v:val == "haskellBlockComment" || v:val == "haskellPragma" ')
endfunction

function! s:getHLStack(line, col)
  return map(synstack(a:line, a:col), 'synIDattr(v:val, "name")')
endfunction

" Only define the function once.
if exists('*GetAnsibleIndent')
  finish
endif

function GetAnsibleIndent(lnum)
  " Check whether the user has set g:ansible_options["ignore_blank_lines"].
  let ignore_blanks = !exists('g:ansible_options["ignore_blank_lines"]')
	\ || g:ansible_options["ignore_blank_lines"]

  let prevlnum = ignore_blanks ? prevnonblank(a:lnum - 1) : a:lnum - 1
  if prevlnum == 0
    return 0
  endif
  let prevline = getline(prevlnum)

  let indent = indent(prevlnum)
  let increase = indent + &sw

  " Do not adjust indentation for comments
  if prevline =~ '\%(^\|\s\)#'
    return indent
  elseif prevline =~ ':\s*[>|]?$'
    return increase
  elseif prevline =~ ':$'
    return increase
  elseif prevline =~ '^\s*-\s*$'
    return increase
  elseif prevline =~ '^\s*-\s\+[^:]\+:\s*\S'
    return increase
  else
    return indent
  endif
endfunction

if exists("b:did_indent")
  finish
endif
runtime! indent/html.vim

unlet! b:did_indent

if &l:indentexpr == ''
  if &l:cindent
    let &l:indentexpr = 'cindent(v:lnum)'
  else
    let &l:indentexpr = 'indent(prevnonblank(v:lnum-1))'
  endif
endif
let b:html_indentexpr = &l:indentexpr

let b:did_indent = 1

setlocal indentexpr=GetJinjaIndent()
setlocal indentkeys=o,O,*<Return>,{,},o,O,!^F,<>>

" Only define the function once.
if exists("*GetJinjaIndent")
  finish
endif

function! GetJinjaIndent(...)
  if a:0 && a:1 == '.'
    let v:lnum = line('.')
  elseif a:0 && a:1 =~ '^\d'
    let v:lnum = a:1
  endif
  let vcol = col('.')

  call cursor(v:lnum,vcol)

  exe "let ind = ".b:html_indentexpr

  let lnum = prevnonblank(v:lnum-1)
  let pnb = getline(lnum)
  let cur = getline(v:lnum)

  let tagstart = '.*' . '{%\s*'
  let tagend = '.*%}' . '.*'

  let blocktags = '\(block\|for\|if\|with\|autoescape\|filter\|trans\|macro\|set\)'
  let midtags = '\(else\|elif\|pluralize\)'

  let pnb_blockstart = pnb =~# tagstart . blocktags . tagend
  let pnb_blockend   = pnb =~# tagstart . 'end' . blocktags . tagend
  let pnb_blockmid   = pnb =~# tagstart . midtags . tagend

  let cur_blockstart = cur =~# tagstart . blocktags . tagend
  let cur_blockend   = cur =~# tagstart . 'end' . blocktags . tagend
  let cur_blockmid   = cur =~# tagstart . midtags . tagend

  if pnb_blockstart && !pnb_blockend
    let ind = ind + &sw
  elseif pnb_blockmid && !pnb_blockend
    let ind = ind + &sw
  endif

  if cur_blockend && !cur_blockstart
    let ind = ind - &sw
  elseif cur_blockmid
    let ind = ind - &sw
  endif

  return ind
endfunction
