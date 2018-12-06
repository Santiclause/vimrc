execute pathogen#infect()
filetype plugin on
filetype indent on
syntax on
au BufNewFile,BufRead *.ejs set filetype=jst
au BufNewFile,BufRead Jenkinsfile set filetype=groovy
au BufNewFile,BufRead Dockerfile.* set filetype=dockerfile
au BufWritePre * %s/\s\{1,\}$//gce
au FileType json set sw=2 ts=2

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

function! NiceSplit()
    let l:top = line("w0")
    let l:bottom = line("w$")
    let l:save_cursor = getcurpos()
    normal M
    let l:middle = line(".")
    let l:splitbelow = &splitbelow
    if l:save_cursor[1] <= l:middle
        let &splitbelow = 0
        split
        call cursor(l:top, 0)
        normal zt
        if l:save_cursor[1] > line("w$")
            call cursor(l:save_cursor[1], 0)
            normal zb
        endif
        let l:bottom = line("w$")
        wincmd j
        call cursor(l:bottom, 0)
        normal ztLj
        wincmd k
    else
        let &splitbelow = 1
        split
        call cursor(l:bottom, 0)
        normal zb
        if l:save_cursor[1] < line("w0")
            call cursor(l:save_cursor[1], 0)
            normal zt
        endif
        let l:top = line("w0")
        wincmd k
        call cursor(l:top, 0)
        normal zbHk
        wincmd j
    endif
    call setpos('.', l:save_cursor)
    let &splitbelow = l:splitbelow
endfunction
command Split call NiceSplit()

set pastetoggle=<F2>

set ruler
set number
highlight LineNr ctermfg=58 ctermbg=232
set foldcolumn=2
highlight FoldColumn ctermfg=86 ctermbg=232

hi jinjaFilter ctermfg=3

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
nnoremap Ow :prev<CR>
nnoremap Oq :next<CR>

nnoremap n nzz
nnoremap N Nzz
nnoremap ZZ <nop>

vnoremap p pgvy
vnoremap P p

" nnoremap <F6> :tabc<CR>
" inoremap <F6> <Esc>:tabc<CR>a
" vnoremap <F6> :tabc<CR>
" nnoremap <F7> :tabp<CR>
" inoremap <F7> <Esc>:tabp<CR>a
" vnoremap <F7> :tabp<CR>
" nnoremap <F8> :tabn<CR>
" inoremap <F8> <Esc>:tabn<CR>a
" vnoremap <F8> :tabn<CR>
nnoremap [26~ :WintabsCloseVimtab<CR>
inoremap [26~ <Esc>:WintabsCloseVimtab<CR>a
vnoremap [26~ :WintabsCloseVimtab<CR>
nnoremap [28~ :tabp<CR>
inoremap [28~ <Esc>:tabp<CR>a
vnoremap [28~ :tabp<CR>
nnoremap [29~ :tabn<CR>
inoremap [29~ <Esc>:tabn<CR>a
vnoremap [29~ :tabn<CR>
nnoremap <silent> <F6> :WintabsClose<CR>
inoremap <silent> <F6> <Esc>:WintabsClose<CR>a
vnoremap <silent> <F6> :WintabsClose<CR>
nnoremap <silent> <F7> :WintabsPrevious<CR>
inoremap <silent> <F7> <Esc>:WintabsPrevious<CR>a
vnoremap <silent> <F7> :WintabsPrevious<CR>
nnoremap <silent> <F8> :WintabsNext<CR>
inoremap <silent> <F8> <Esc>:WintabsNext<CR>a
vnoremap <silent> <F8> :WintabsNext<CR>

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

" Create fold text objects using [z and ]z
vnoremap if :<C-U>silent!normal![zjV]zk<CR>
onoremap if :normal Vif<CR>
vnoremap af :<C-U>silent!normal![zV]z<CR>
onoremap af :normal Vaf<CR>

imap <Tab> <C-P><Down>
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
if version >= 704
  set completeopt=longest,menuone,preview
  au CompleteDone * pclose
end
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
inoremap <expr> <C-n> pumvisible() ? '<C-n>' : '<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'

au FileType go inoremap <expr> <Tab> pumvisible() ? '<Down>' : '<C-x><C-o><Down>'
au FileType go inoremap <expr> <S-Tab> pumvisible() ? '<Up>' : '<Tab>'
au FileType go nnoremap gi :GoImports<CR>
au FileType go nmap gD <Plug>(go-def-tab)
au FileType go nmap gsd <Plug>(go-def-split)
au FileType go nmap gsv <Plug>(go-def-vertical)
au FileType go nmap gr <Plug>(go-referrers)

au FileType qf nnoremap <expr> <buffer> <CR> ":" . repeat(LocationType(), 2) . line(".") . "\<CR>"
function! LocationType()
	let l:type = "c"
	if getwininfo(win_getid())[0]['loclist']
		let l:type = "l"
	endif
    return l:type
endfunction

nnoremap [l :lprev<CR>
nnoremap ]l :lnext<CR>

nnoremap <silent> gb :set opfunc=Base64Decode<CR>g@
vnoremap gb :<C-U>call Base64Decode(visualmode(), 1)<CR>
nnoremap <silent> gB :set opfunc=Base64Encode<CR>g@
vnoremap gB :<C-U>call Base64Encode(visualmode(), 1)<CR>

function! Base64Decode(type, ...)
  let sel_save = &selection
  let &selection = "inclusive"
  let reg_save = @a
  let paste_save = &paste

  let &paste = 1
  if a:0  " Invoked from Visual mode, use gv command.
    silent exe "normal! gv\"ac\<C-R>=system('printf %s \"$(echo -n \"' . @a  . '\" | base64 --decode)\"')\<CR>\<Esc>"
  elseif a:type == 'line'
    silent exe "normal! '[V']\"ac\<C-R>=system('printf %s \"$(echo -n \"' . @a  . '\" | base64 --decode)\"')\<CR>\<Esc>"
  else
    silent exe "normal! `[v`]\"ac\<C-R>=system('printf %s \"$(echo -n \"' . @a  . '\" | base64 --decode)\"')\<CR>\<Esc>"
  endif

  let &selection = sel_save
  let &paste = paste_save
  let @a = reg_save
endfunction

function! Base64Encode(type, ...)
  let sel_save = &selection
  let &selection = "inclusive"
  let reg_save = @a
  let paste_save = &paste

  let &paste = 1
  if a:0  " Invoked from Visual mode, use gv command.
    silent exe "normal! gv\"ac\<C-R>=system('printf %s \"$(echo -n \"' . @a  . '\" | base64)\"')\<CR>\<Esc>"
  elseif a:type == 'line'
    silent exe "normal! '[V']\"ac\<C-R>=system('printf %s \"$(echo -n \"' . @a  . '\" | base64)\"')\<CR>\<Esc>"
  else
    silent exe "normal! `[v`]\"ac\<C-R>=system('printf %s \"$(echo -n \"' . @a  . '\" | base64)\"')\<CR>\<Esc>"
  endif

  let &selection = sel_save
  let &paste = paste_save
  let @a = reg_save
endfunction
