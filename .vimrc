" vim: foldmethod=marker
" Vim Settings {{{
set autoindent
set autoread
set clipboard=unnamedplus
set display+=lastline
set encoding=utf-8
set fillchars=vert:\ ,fold:\ " Must keep the space after the backslash
set foldmethod=indent
set formatoptions+=j " Delete comment character when joining commented lines
set hidden " Allows opening a new buffer with unsaved changes
set hlsearch
set ignorecase
set incsearch
set laststatus=2
set lazyredraw
set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
set expandtab
set noshowmode " Mode is shown using airline instead
set number
set ruler
set scrolloff=3
set shiftwidth=2
set showcmd " Shows the number of lines selected
set sidescrolloff=5
set signcolumn=yes
set smartcase
set splitbelow
set synmaxcol=160 " Prevents slow vim on large files
set tabstop=2
set termguicolors
set textwidth=80
set ttimeout " Only wait ttimeoutlen milliseconds for a complete key sequence
set ttimeoutlen=100
set undodir=~/.vim/undodir/
set undofile
set updatetime=100
set visualbell t_vb=
set wildignore+=.git/,.*cache/,node_modules/,.meteor/,__pycache__/,.*env/
set wildignorecase
set wildmenu
set wildmode=longest:full,full
let &colorcolumn = '+1,+'.join(range(2,999),',+')
let g:tex_flavor = "latex"
let g:netrw_fastbrowse = 0 " Closes netrw after opening a file

" Close the [No Name] buffer that is created when using --remote-silent
if bufname('%') == ''
  set bufhidden=wipe
endif

if has('gui_running')
  set guioptions-=mrL
  set guicursor+=a:blinkon0

  if has('gui_gtk')
    set guifont=Cascadia\ Code\ PL 12
  else
    set guifont=Cascadia\ Code\ PL:h12
  endif
endif
" }}}

" Plugins {{{
call plug#begin('~/.vim/plugged')

Plug 'Yggdroot/indentLine'
Plug 'airblade/vim-gitgutter'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'dense-analysis/ale'
Plug 'easymotion/vim-easymotion'
Plug 'editorconfig/editorconfig-vim'
Plug 'godlygeek/tabular'
Plug 'mbbill/undotree'
Plug 'roxma/nvim-yarp'
Plug 'roxma/vim-hug-neovim-rpc'
Plug 'thinca/vim-quickrun'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'

" Interface
Plug 'lifepillar/vim-solarized8'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Language specific
Plug 'sheerun/vim-polyglot'
Plug 'thosakwe/vim-flutter'

call plug#end()

" Settings
let g:ale_fixers = {
  \ 'css': ['prettier'],
  \ 'dart': ['dartfmt'],
  \ 'javascript': ['prettier'],
  \ 'javascriptreact': ['prettier'],
  \ 'python': ['black'],
\ }
let g:ale_linters = {
  \ 'dart': ['analysis_server'],
  \ 'python': ['flake8', 'pyls'],
  \ 'tex': ['chktex'],
\ }
let g:ale_completion_enabled = 1
let g:ale_cpp_clang_options = '-std=c++17 -Wall -Wextra'
let g:ale_cpp_gcc_options = '-std=c++17 -Wall -Wextra'
let g:ale_fix_on_save = 1
let g:ale_sign_error = '✗'
let g:ale_sign_warning = '⚠'
let g:ctrlp_map = '<Leader>f'
let g:indentLine_char = '|'
let g:indentLine_color_gui = '#1e1e1e'
let g:vim_markdown_conceal = 0
" }}}

" Interface {{{
set background=dark
colorscheme solarized8_flat
let g:airline_theme='solarized'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline_section_y = airline#section#create([
  \ '%L' . g:airline_symbols.maxlinenr
\ ])
let g:airline_section_z = airline#section#create(['%2v'])
" }}}

" Key Mappings {{{
let mapleader=','
let maplocalleader='\\'

nnoremap <C-s> :update<CR>
inoremap <C-s> <Esc>:update<CR>
cmap w!! w !sudo -E tee > /dev/null %
nnoremap <F12> :syntax sync fromstart<CR>
inoremap <F12> :syntax sync fromstart<CR>

" Toggles
nnoremap tl :set list!<CR>
nnoremap tu :UndotreeToggle<CR>
nnoremap tc :set cursorline! cursorcolumn!<CR>
nnoremap tp :set paste!<CR>
nnoremap ts :set spell!<CR>

" Copy and paste
if has('clipboard')
  vnoremap x "+x
  vnoremap y "+y
endif
nnoremap <C-p> :pu<CR>
vnoremap <C-p> :pu<CR>
vnoremap <Leader>p "_dP

" Navigation
nnoremap <space> zz
nnoremap n nzz
nnoremap N Nzz
nnoremap <silent> <C-n> :nohlsearch<CR><Esc>
nnoremap <C-e> 3<C-e>
nnoremap <C-y> 3<C-y>
nnoremap 0 g0
vnoremap 0 g0
nnoremap $ g$
vnoremap $ g$
nnoremap j gj
nnoremap k gk
vnoremap k gk
nnoremap <Leader>bd :bprevious\|bdelete #<CR>
nnoremap ]b :bnext<CR>
nnoremap [b :bprevious<CR>
nnoremap ]B :bfirst<CR>
nnoremap [B :blast<CR>
nnoremap ]c :cnext<CR>
nnoremap [c :cprevious<CR>
nnoremap ]l :lnext<CR>
nnoremap [l :lprevious<CR>
nnoremap ]t :tabnext<CR>
nnoremap [t :tabprevious<CR>
nnoremap ]g :GitGutterNextHunk<CR>
nnoremap [g :GitGutterPrevHunk<CR>

" Window management
nnoremap <Leader>c :pclose<CR>
inoremap <C-w> <C-o><C-w>
nnoremap <Leader><C-k> <C-w>K
nnoremap <Leader><C-j> <C-w>J
nnoremap <Leader><C-h> <C-w>H
nnoremap <Leader><C-l> <C-w>L
nnoremap <C-k> <C-w>k
nnoremap <C-j> <C-w>j
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l
nnoremap - <C-w>-
nnoremap + <C-w>+
nnoremap < <C-w><
nnoremap > <C-w>>

" Plugins
nnoremap gd :ALEGoToDefinition<CR>
nnoremap gh :ALEHover<CR>
map <Leader>r <Plug>(quickrun)
" }}}

" Functions {{{
" }}}

" Auto Commands {{{
augroup autocommands
  au!
  au BufNewFile,BufRead * if &filetype == '' | set foldlevel=99 | endif
  au BufNewFile,BufRead *.jsx.snap set filetype=jsx
  au BufNewFile,BufRead *.php set filetype=php.html
  au FileType gitcommit setl spell textwidth=72
  au FileType html setl spell
  au FileType tex setl spell
augroup END
" }}}
