" vim: foldmethod=marker
" Vim Settings {{{
set autoindent
set autoread
set clipboard=unnamedplus
set display+=lastline
set encoding=utf-8
set expandtab
set fillchars+=fold:\ " Must keep the space after the backslash
set formatoptions+=j " Delete comment character when joining commented lines
set gdefault
set hidden " Allows opening a new buffer with unsaved changes
set hlsearch
set ignorecase
set incsearch
set laststatus=2
set lazyredraw
set linespace=4
set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
set modeline
set mouse=a
set noshowmode " Mode is shown using airline instead
set number
set ruler
set scrolloff=3
set shiftwidth=2
set shortmess+=c
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
Plug 'easymotion/vim-easymotion'
Plug 'editorconfig/editorconfig-vim'
Plug 'godlygeek/tabular'
Plug 'jiangmiao/auto-pairs'
Plug 'mbbill/undotree'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'roxma/nvim-yarp'
Plug 'roxma/vim-hug-neovim-rpc'
Plug 'thinca/vim-quickrun'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'

" Interface
Plug 'lifepillar/vim-colortemplate'
Plug 'nelsyeung/high-contrast', { 'rtp': 'vim' }
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Language specific
Plug 'sheerun/vim-polyglot'
Plug 'thosakwe/vim-flutter'

call plug#end()

" Settings
let g:coc_global_extensions = ['coc-flutter', 'coc-json', 'coc-pyright']
let g:ctrlp_map = '<leader>f'
let g:indentLine_char = '|'
let g:indentLine_color_gui = '#282828'
let g:vim_markdown_conceal = 0
" }}}

" Interface {{{
set background=dark
colorscheme high_contrast
let g:airline_theme='simple'
let g:airline#extensions#tabline#enabled = 1
let g:airline_section_y = airline#section#create([
  \ '%L' . g:airline_symbols.maxlinenr
\ ])
let g:airline_section_z = airline#section#create(['%2v'])
" }}}

" Key Mappings {{{
let mapleader=','
let maplocalleader='\\'

nnoremap <c-s> :update<cr>
inoremap <c-s> <Esc>:update<cr>
cmap w!! w !sudo -E tee > /dev/null %
nnoremap <F12> :syntax sync fromstart<cr>
inoremap <F12> :syntax sync fromstart<cr>

" Toggles
nnoremap tl :set list!<cr>
nnoremap tu :UndotreeToggle<cr>
nnoremap tc :set cursorline! cursorcolumn!<cr>
nnoremap tp :set paste!<cr>
nnoremap ts :set spell!<cr>

" Copy and paste
if has('clipboard')
  vnoremap x "+x
  vnoremap y "+y
endif
nnoremap <c-p> :pu<cr>
vnoremap <c-p> :pu<cr>
vnoremap <leader>p "_dP

" Navigation
nnoremap <space> zz
nnoremap n nzz
nnoremap N Nzz
nnoremap <silent> <c-n> :nohlsearch<cr><esc>
nnoremap <c-e> 3<c-e>
nnoremap <c-y> 3<c-y>
nnoremap 0 g0
vnoremap 0 g0
nnoremap $ g$
vnoremap $ g$
nnoremap j gj
nnoremap k gk
vnoremap k gk
nnoremap <leader>bd :bprevious\|bdelete #<cr>
nnoremap ]b :bnext<cr>
nnoremap [b :bprevious<cr>
nnoremap ]B :bfirst<cr>
nnoremap [B :blast<cr>
nnoremap ]c :cnext<cr>
nnoremap [c :cprevious<cr>
nnoremap ]l :lnext<cr>
nnoremap [l :lprevious<cr>
nnoremap ]t :tabnext<cr>
nnoremap [t :tabprevious<cr>
nnoremap ]g :GitGutterNextHunk<cr>
nnoremap [g :GitGutterPrevHunk<cr>

" Window management
nnoremap <leader>c :pclose<cr>
inoremap <c-w> <c-o><c-w>
nnoremap <leader><c-k> <c-w>K
nnoremap <leader><c-j> <c-w>J
nnoremap <leader><c-h> <c-w>H
nnoremap <leader><c-l> <c-w>L
nnoremap <c-k> <c-w>k
nnoremap <c-j> <c-w>j
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l
nnoremap - <c-w>-
nnoremap + <c-w>+
nnoremap < <c-w><
nnoremap > <c-w>>

" Plugins
nmap <silent> gd <Plug>(coc-definition)
nnoremap <silent> gh :call <SID>show_documentation()<cr>
nmap <F2> <Plug>(coc-rename)
nmap <silent> [e <Plug>(coc-diagnostic-prev-error)
nmap <silent> ]e <Plug>(coc-diagnostic-next-error)
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
  \ : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

map <leader>r <Plug>(quickrun)
" }}}

" Functions {{{
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction
" }}}

" Auto Commands {{{
augroup autocommands
  au!
  au CursorHold * silent call CocActionAsync('highlight')
  au FileType gitcommit setl spell textwidth=72
  au FileType html setl spell
  au FileType tex setl spell
augroup END
" }}}
