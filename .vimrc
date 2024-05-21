" Most vim config is in .config/nvim, this file exists to provide sensible
" defaults for situations where nvim is not installed.
"
" =====================================================
" Plugins 
" - Requires https://github.com/junegunn/vim-plug
" - Run :PlugInstall after starting
" =====================================================

" call plug#begin('~/.vim/plugged')

" See https://github.com/neoclide/coc.nvim
" Requires: curl -sL install-node.now.sh/lts | bash
" Plug 'neoclide/coc.nvim', { 'branch': 'release' }

" call plug#end()

" =====================================================
" Usability
" =====================================================

" Don't try to be vi compatible
set nocompatible

" Helps force plugins to load correctly when it is turned back on below
filetype off

" For plugins to load correctly
filetype plugin indent on

" Pick a leader key
let mapleader = " "

" Security
set modelines=0

" Default to the system clipboard
set clipboard=unnamedplus

" Show file stats
set ruler

" Blink cursor on error instead of beeping (grr)
set visualbell

" Encoding
set encoding=utf-8

" Whitespace
set wrap
set textwidth=0
set formatoptions=tcqrn1
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set noshiftround

" Cursor motion
set scrolloff=3
set backspace=indent,eol,start
set matchpairs+=<:> " use % to jump between pairs
runtime! macros/matchit.vim

" Allow hidden buffers
set hidden

"  Better switching of buffers, regardless of how it's split
set switchbuf=useopen,usetab

" Rendering
set ttyfast

" Status bar
set laststatus=2

" Last line
set showmode
set showcmd

" Searching
" nnoremap / /\v
" vnoremap / /\v
set hlsearch
set incsearch
set ignorecase
set smartcase
set showmatch

" =====================================================
" Interface Tweaks
" =====================================================

" Turn on syntax highlighting
syntax on

" Show line numbers
set number

" Visualize tabs and newlines
set listchars=tab:▸\ ,eol:¬

" Color scheme (terminal)
set t_Co=256
set background=dark
let g:solarized_termcolors=256
let g:solarized_termtrans=1
" put https://raw.github.com/altercation/vim-colors-solarized/master/colors/solarized.vim
" in ~/.vim/colors/ and uncomment:
" colorscheme solarized

" Turn on the Wild menu
set wildmenu
set wildmode=longest:full,full

" changes the cursor while running on tmux/iterm/mac
" stolen from: http://vim.wikia.com/wiki/Change_cursor_shape_in_different_modes
let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
let &t_SR = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=2\x7\<Esc>\\"
let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"

" =====================================================
" Key Bindings / Remapping
" =====================================================

" leader-w / leader-s to save
nmap <leader>w :w!<cr>
nmap <leader>s :w!<cr>

" Remap help key.
"inoremap <F1> <ESC>:set invfullscreen<CR>a
"nnoremap <F1> :set invfullscreen<CR>
"vnoremap <F1> :set invfullscreen<CR>

" Formatting
map <leader>F gqip

" Open file navigation
nmap <leader>n :bnext<cr>
nmap <leader>p :bprev<cr>
cnoremap <expr> ls (getcmdtype() == ':' && getcmdpos() == 1) ? "ls\<CR>:b" : "ls"

" Uncomment this to enable by default:
" set list " To enable by default
" Or use your leader key + l to toggle on/off
" map <leader>l :set list!<CR> " Toggle tabs and EOL

" clears the current search
map <leader><space> :let @/=''<cr>

" split management to mirror emacs settings
map <leader>2 :split<CR>
map <leader>3 :vsplit<CR>
map <leader>0 :on<CR>
nnoremap <silent> <A-Right> <c-w>l
nnoremap <silent> <A-Left> <c-w>h
nnoremap <silent> <A-Up> <c-w>k
nnoremap <silent> <A-Down> <c-w>j
