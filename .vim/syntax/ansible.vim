" Vim syntax file
"
if exists("b:current_syntax")
  finish
endif

if !exists("main_syntax")
  let main_syntax = 'yaml'
endif

:runtime! syntax/yaml.vim
unlet b:current_syntax
:runtime! syntax/jinja.vim
unlet b:current_syntax

let b:current_syntax = "ansible"
