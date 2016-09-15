execute pathogen#infect()
filetype plugin on
filetype indent on
syntax on
au BufNewFile,BufRead *.ejs set filetype=jst

function! NukeLhm()
    :%s/^ *.Lhm.Lhm::setAdapter($this->getAdapter());//
    :%s/^ *\zs.*changeTable(\('.*'\).*/$table = $this->table(\1);/c
    :%s/^ *});$//c
endfunction
command NukeLhm call NukeLhm()

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

set virtualedit=block

set splitbelow
set splitright

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
