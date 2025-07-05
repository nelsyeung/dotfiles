" vim: foldmethod=marker
" Vim Settings {{{
set autoindent
set autoread
set belloff=all
set clipboard=unnamedplus
set cursorcolumn
set cursorline
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
set modelines=5
set mouse=a
set nobackup
set noshowmode " Mode is shown using airline instead
set re=0
set relativenumber
set ruler
set scrolloff=3
set shiftwidth=2
set shortmess+=c
set showcmd " Shows the number of lines selected
set sidescrolloff=5
set signcolumn=yes
set smartcase
set splitbelow
set synmaxcol=3000 " Prevents slow vim on large files
set tabstop=2
set termguicolors
set textwidth=80
set ttimeout " Only wait ttimeoutlen milliseconds for a complete key sequence
set ttimeoutlen=100
set updatetime=100
set wildignore+=.git/,.*cache/,.meteor/,.*env/
set wildignore+=__pycache__/,intermediates/,node_modules/,Pods/
set wildignorecase
set wildmenu
set wildmode=longest:full,full
let &colorcolumn = '+1,+'.join(range(2,999),',+')
let g:tex_flavor = "latex"
let g:netrw_banner = 0
let g:netrw_bufsettings = "noma nomod nonu nobl nowrap ro rnu" " Relative number
let g:netrw_fastbrowse = 0 " Closes netrw after opening a file
let g:netrw_winsize = -40

if has('win32')
  set shell=powershell
  set shellcmdflag=-c
endif

" Close the [No Name] buffer that is created when using --remote-silent
if bufname('%') == ''
  set bufhidden=wipe
endif

if has('gui_running')
  set guicursor+=a:blinkon0
  set guioptions-=mrL
  set linespace=0

  if has('gui_gtk')
    set guifont=Cascadia\ Mono 12
  elseif has('win32')
    set guioptions-=T
    set guifont=Cascadia\ Mono:h9
  else
    set guifont=Cascadia\ Mono:h12
  endif

  if has("gui_macvim")
    set macligatures
  endif
endif
" }}}

" Plugins settings {{{
let g:coc_global_extensions = [
  \ 'coc-eslint',
  \ 'coc-flutter',
  \ 'coc-json',
  \ 'coc-markdownlint',
  \ 'coc-prettier',
  \ 'coc-pyright',
  \ 'coc-rust-analyzer',
  \ 'coc-tsserver',
  \ 'coc-yaml',
\ ]
if has('win32')
  let g:coc_global_extensions += [
    \ 'coc-powershell',
  \ ]
else
  let g:coc_global_extensions += [
    \ 'coc-sh',
  \ ]
endif
let g:ctrlp_custom_ignore = 'intermediates\|node_modules\|Pods'
let g:ctrlp_working_path_mode = 'a'
let g:floaterm_height = 0.2
let g:floaterm_keymap_kill = '<leader>fk'
let g:floaterm_keymap_new = '<leader>fn'
let g:floaterm_keymap_next = ']f'
let g:floaterm_keymap_prev = '[f'
let g:floaterm_keymap_toggle = 'tf'
let g:floaterm_wintype = 'split'
let g:indentLine_char = '|'
let g:vim_markdown_conceal = 0
" }}}

" Interface {{{
set background=dark
let ps_theme_cmd = 'Get-ItemPropertyValue -Path
  \ HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize
  \ -Name AppsUseLightTheme'
if has('win32')
  if trim(system(ps_theme_cmd)) == '1'
    set background=light
  endif
elseif has('mac')
  if trim(system('defaults read -g AppleInterfaceStyle 2>/dev/null')) != "Dark"
    set background=light
  endif
else
  let output = system('uname -a | grep microsoft')
  if v:shell_error == 0 &&
    \ trim(system('powershell.exe -Command "' . ps_theme_cmd . '"')) == '1'
    set background=light
  endif
endif

if &background ==# 'dark'
  colorscheme high_contrast
  let g:airline_theme='simple'
  let g:indentLine_color_gui = '#282828'
else
  colorscheme solarized8
  let g:airline_theme='solarized'
  let g:indentLine_color_gui = '#eee8d5'
endif

let g:airline#extensions#tabline#enabled = 1
let g:airline_section_z = airline#section#create([
  \ '%p%% %l/%L:%v' . g:airline_symbols.maxlinenr
\ ])
" }}}

" Key Mappings {{{
let mapleader=','
let maplocalleader='\\'

nnoremap <c-s> :update<cr>
inoremap <c-s> <Esc>:update<cr>
nnoremap <c-x> :Lexplore<cr>
cmap w!! w !sudo -E tee > /dev/null %
nnoremap <F12> :syntax sync fromstart<cr>
inoremap <F12> :syntax sync fromstart<cr>

" Toggles
nnoremap tl :set list!<cr>
nnoremap tq :call ToggleQuickFix()<cr>
nnoremap tu :UndotreeToggle<cr>
nnoremap tc :set cursorline! cursorcolumn!<cr>
nnoremap tp :set paste!<cr>
nnoremap ts :set spell!<cr>

" Copy and paste
if has('clipboard')
  vnoremap x "+x
  vnoremap y "+y
endif
nnoremap P :pu<cr>
vnoremap P :pu<cr>
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
nnoremap <leader>bw :%bdelete\|e#\|bdelete#<cr>  " Wipe all buffer but one
nnoremap <leader>bc :bprevious\|bdelete #<cr>
nnoremap <leader>tc :tabclose<cr>
nnoremap ]b :bnext<cr>
nnoremap [b :bprevious<cr>
nnoremap ]B :bfirst<cr>
nnoremap [B :blast<cr>
nnoremap ]q :cnext<cr>
nnoremap [q :cprevious<cr>
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
nmap <leader>qf <Plug>(coc-fix-current)
xmap <silent> <leader>a <Plug>(coc-codeaction-selected)
nmap <silent> <leader>a <Plug>(coc-codeaction-selected)
nmap <silent> gd <Plug>(coc-definition)
nnoremap <silent> gh :call <SID>show_documentation()<cr>
nmap gn <Plug>(coc-rename)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> [e <Plug>(coc-diagnostic-prev)
nmap <silent> ]e <Plug>(coc-diagnostic-next)
nnoremap <silent><nowait> <space>d :<C-u>CocList diagnostics<cr>
nnoremap <silent><nowait> <space>c :<C-u>CocList commands<cr>
nnoremap <silent><nowait> <space>o :<C-u>CocList outline<cr>
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
inoremap <silent><expr> <cr> coc#pum#visible() ? coc#pum#confirm()
  \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
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

function! SwiftFormat()
  let formatted = system('swift-format', join(getline(1,'$'), "\n"))
  if v:shell_error == 0
    let view = winsaveview()
    :%delete _
    call setline(1, split(formatted, '\n'))
    call winrestview(view)
  endif
endfunction

function! ToggleQuickFix()
  if empty(filter(getwininfo(), 'v:val.quickfix'))
    copen
  else
    cclose
  endif
endfunction
" }}}

" Auto Commands {{{
augroup autocommands
  au!
  au BufEnter * if &buftype == 'terminal' | setlocal norelativenumber signcolumn=no | endif
  au BufNewFile,BufRead * if empty(&filetype) | setl synmaxcol=160 | endif
  au BufWritePre *.py,*.dart,*.ts,*.tsx :silent call CocAction('runCommand', 'editor.action.organizeImport')
  au BufWritePre *.swift :call SwiftFormat()
  au CursorHold * silent call CocActionAsync('highlight')
  au FileType gitcommit setl spell textwidth=72
  au FileType html setl spell
  au FileType python setl textwidth=79
  au FileType swift setl textwidth=100
  au FileType tex setl spell
  au QuickFixCmdPost [^l]* cwindow
augroup END
" }}}
