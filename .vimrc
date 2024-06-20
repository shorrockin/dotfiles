" Most vim config is in .config/nvim, this file exists to provide sensible
" defaults for situations where nvim is not installed.
"
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

" Better switching of buffers, regardless of how it's split
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

" Turn on the Wild menu
set wildmenu
set wildmode=longest:full,full

" =====================================================
" Key Bindings / Remapping
" =====================================================

" leader-w / leader-s to save
nmap <leader>w :w!<cr>


" split management to mirror emacs settings
nnoremap <silent> <A-Right> <c-w>l
nnoremap <silent> <A-Left> <c-w>h
nnoremap <silent> <A-Up> <c-w>k
nnoremap <silent> <A-Down> <c-w>j
