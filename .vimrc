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

Plug 'Shougo/denite.nvim'
Plug 'Yggdroot/indentLine'
Plug 'airblade/vim-gitgutter'
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
Plug 'gkapfham/vim-vitamin-onec'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Language specific
Plug 'sheerun/vim-polyglot'
Plug 'thosakwe/vim-flutter'

call plug#end()

" Settings
let g:OmniSharp_server_use_mono = 1
let g:ale_fixers = {
  \ 'dart': ['dartfmt'],
  \ 'python': ['black'],
  \ 'javascript': ['prettier'],
  \ 'css': ['prettier'],
\ }
let g:ale_linters = {
  \ 'dart': ['analysis_server'],
  \ 'cs': ['OmniSharp'],
  \ 'python': ['flake8', 'pyls'],
  \ 'tex': ['chktex'],
\ }
let g:ale_completion_enabled = 1
let g:ale_cpp_clang_options = '-std=c++17 -Wall -Wextra'
let g:ale_cpp_gcc_options = '-std=c++17 -Wall -Wextra'
let g:ale_fix_on_save = 1
let g:ale_sign_error = '✗'
let g:ale_sign_warning = '⚠'
let g:indentLine_char = '|'
let g:indentLine_color_gui = '#1e1e1e'
let g:vim_markdown_conceal = 0
let g:vimtex_quickfix_enabled = 0

call denite#custom#var('grep', 'recursive_opts', [
  \ '-r',
  \ '--exclude-dir=.git',
  \ '--exclude-dir=.*cache',
  \ '--exclude-dir=node_modules',
  \ '--exclude-dir=.meteor',
  \ '--exclude-dir=__pycache__',
  \ '--exclude-dir=.*env',
\ ])
call denite#custom#var('file/rec', 'command', [
  \ 'scantree.py', '--path', ':directory',
  \ '--ignore',
  \ '.git,.*cache,node_modules,.meteor,__pycache__,.*env,*.pyc,*.swp'
\ ])
" }}}

" Interface {{{
colorscheme vitaminonec
hi Normal guibg=#000000
hi Cursor guifg=#ffffff guibg=#ffb472
hi Folded ctermbg=0 guibg=#000000
hi ColorColumn guibg=#0F0F0F
let g:airline_theme='minimalist'

hi tsxTagName ctermfg=4 guifg=#268BD2
hi tsxCloseString ctermfg=4 guifg=#268BD2
hi tsxCloseTag ctermfg=4 guifg=#268BD2

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
nnoremap <Leader>f :Denite buffer file/rec<CR>
nnoremap <Leader>g :Denite grep<CR>
" }}}

" Functions {{{
function! s:denite_mappings() abort
  nnoremap <silent><buffer><expr> <CR> denite#do_map('do_action')
  nnoremap <silent><buffer><expr> p denite#do_map('do_action', 'preview')
  nnoremap <silent><buffer><expr> q denite#do_map('quit')
  nnoremap <silent><buffer><expr> i denite#do_map('open_filter_buffer')
  nnoremap <silent><buffer><expr> <Space> denite#do_map('toggle_select').'j'
endfunction

function! s:denite_filter_mappings() abort
  imap <silent><buffer> <C-j> <Plug>(denite_filter_quit)
endfunction
" }}}

" Auto Commands {{{
augroup autocommands
  au!
  au BufNewFile,BufRead * if &filetype == '' | set foldlevel=99 | endif
  au BufNewFile,BufRead *.jsx.snap set filetype=jsx
  au BufNewFile,BufRead *.php set filetype=php.html textwidth=150
  au BufNewFile,BufRead *.tsx,*.jsx set filetype=typescript.tsx
  au FileType cs setl textwidth=120
  au FileType denite call s:denite_mappings()
  au FileType denite-filter call s:denite_filter_mappings()
  au FileType fortran setl noai nocin nosi inde=
  au FileType gitcommit setl spell textwidth=72
  au FileType html setl spell
  au FileType python setl textwidth=88
  au FileType tex setl spell
augroup END
" }}}
