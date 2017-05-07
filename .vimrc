execute pathogen#infect()
filetype plugin on
filetype indent on
syntax on
au BufNewFile,BufRead *.ejs set filetype=jst
au BufNewFile,BufRead *.yaml.j2 set filetype=yaml
au BufNewFile,BufRead Jenkinsfile set filetype=groovy
au BufWritePre * %s/\s\{1,\}$//gce
au FileType ansible set filetype=yaml

function! NukeLhm()
    :%s/^ *.Lhm.Lhm::setAdapter($this->getAdapter());//
    :%s/^ *\zs.*changeTable(\('.*'\).*/$table = $this->table(\1);/c
    :%s/^ *});$//c
endfunction
command NukeLhm call NukeLhm()

function! WriteRun()
    :w | ! ./%
endfunction
command WR call WriteRun()

set pastetoggle=<F2>

set ruler
set number
highlight LineNr ctermfg=58 ctermbg=232
set foldcolumn=2
highlight FoldColumn ctermfg=86 ctermbg=232

set clipboard=unnamed ""enables putting yanks/deletes/etc in clipboard

set ttyfast
set lazyredraw

set backspace=eol,start,indent
set whichwrap+=<,>,h,l
set nowrap
set ignorecase
set smartcase
set hlsearch
set incsearch

set expandtab
set smarttab
set shiftwidth=4
set tabstop=4
""set et smarttab ts=4 sw=4 ai si
set ai
set si

au FileType go set noexpandtab
au FileType yaml set sw=2 ts=2

set virtualedit=block

set splitbelow
set splitright

"friendlier tab completion in vim command prompt
set wildmenu
set wildmode=list:longest

if has("autocmd")
    au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

nnoremap <CR> :noh<CR>

nnoremap <PageUp> <C-u>
nnoremap <PageDown> <C-d>
nnoremap Ox <C-Y>
nnoremap Or <C-E>
nnoremap Oy 10<C-Y>
nnoremap Os 10<C-E>
nnoremap Ot 5zh
nnoremap Ov 5zl

nnoremap n nzz
nnoremap N Nzz
nnoremap ZZ <nop>

vnoremap p pgvy
vnoremap P p

nnoremap <F7> :tabp<CR>
inoremap <F7> <Esc>:tabp<CR>i
vnoremap <F7> :tabp<CR>
nnoremap <F8> :tabn<CR>
inoremap <F8> <Esc>:tabn<CR>i
vnoremap <F8> :tabn<CR>

set mouse=a
map <ScrollWheelUp> <C-Y>
map <ScrollWheelDown> <C-E>

nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <silent> <C-Right> <c-w>l
nnoremap <silent> <C-Left> <c-w>h
nnoremap <silent> <C-Up> <c-w>k
nnoremap <silent> <C-Down> <c-w>j

imap <Tab> <C-P>
highlight Pmenu ctermbg=brown ctermfg=white
highlight PmenuSel ctermfg=black

"highlight Search ctermbg=235 ctermfg=white
highlight Search ctermbg=17 ctermfg=9
" hi DiffText   cterm=none ctermfg=Black ctermbg=Red gui=none guifg=Black guibg=Red
" hi DiffChange cterm=none ctermfg=Black ctermbg=LightMagenta gui=none guifg=Black guibg=LightMagenta
hi DiffAdd          ctermbg=235  ctermfg=108  guibg=#262626 guifg=#87af87 cterm=reverse        gui=reverse
hi DiffChange       ctermbg=235  ctermfg=103  guibg=#262626 guifg=#8787af cterm=reverse        gui=reverse
hi DiffDelete       ctermbg=235  ctermfg=131  guibg=#262626 guifg=#af5f5f cterm=reverse        gui=reverse
hi DiffText         ctermbg=235  ctermfg=208  guibg=#262626 guifg=#ff8700 cterm=reverse        gui=reverse
nnoremap do do]c
nnoremap dp dp]c

highlight OverLength ctermbg=234
au FileType markdown match OverLength /\%81v.\+/

"autocomplete options
set completeopt=menuone
" if version >= 704
"   set completeopt=longest,menuone,preview
"   au CompleteDone * pclose
" end
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
inoremap <expr> <C-n> pumvisible() ? '<C-n>' : '<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'

au FileType go inoremap <expr> <Tab> pumvisible() ? '<Down>' : '<C-x><C-o>'
au FileType go inoremap <expr> <S-Tab> pumvisible() ? '<Up>' : '<Tab>'

nnoremap <silent> gb :set opfunc=Base64Decode<CR>g@
vnoremap gb :<C-U>call Base64Decode(visualmode(), 1)<CR>
nnoremap <silent> gB :set opfunc=Base64Encode<CR>g@
vnoremap gB :<C-U>call Base64Encode(visualmode(), 1)<CR>

function! Base64Decode(type, ...)
  let sel_save = &selection
  let &selection = "inclusive"
  let reg_save = @a

  if a:0  " Invoked from Visual mode, use gv command.
    silent exe "normal! gv\"ac\<C-R>=system('echo -n \"' . @a  . '\" | base64 -D | xargs -n1 printf %s')\<CR>\<Esc>"
  elseif a:type == 'line'
    silent exe "normal! '[V']\"ac\<C-R>=system('echo -n \"' . @a  . '\" | base64 -D | xargs -n1 printf %s')\<CR>\<Esc>"
  else
    silent exe "normal! `[v`]\"ac\<C-R>=system('echo -n \"' . @a  . '\" | base64 -D | xargs -n1 printf %s')\<CR>\<Esc>"
  endif

  let &selection = sel_save
  let @a = reg_save
endfunction

function! Base64Encode(type, ...)
  let sel_save = &selection
  let &selection = "inclusive"
  let reg_save = @a

  if a:0  " Invoked from Visual mode, use gv command.
    silent exe "normal! gv\"ac\<C-R>=system('echo -n \"' . @a  . '\" | base64 | xargs -n1 printf %s')\<CR>\<Esc>"
  elseif a:type == 'line'
    silent exe "normal! '[V']\"ac\<C-R>=system('echo -n \"' . @a  . '\" | base64 | xargs -n1 printf %s')\<CR>\<Esc>"
  else
    silent exe "normal! `[v`]\"ac\<C-R>=system('echo -n \"' . @a  . '\" | base64 | xargs -n1 printf %s')\<CR>\<Esc>"
  endif

  let &selection = sel_save
  let @a = reg_save
endfunction
