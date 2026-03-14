" ── core behaviour ──────────────────────────────────────────────────────────
set nocompatible            " must be first — disables Vi quirks
filetype plugin indent on   " filetype detection + per-type indentation
syntax enable               " syntax highlighting

" ── display ─────────────────────────────────────────────────────────────────
set number                  " absolute line numbers
set relativenumber          " relative numbers (5j, 12k jumps)
set cursorline              " highlight current line
set colorcolumn=80          " ruler at 80 chars
set scrolloff=8             " keep 8 lines above/below cursor
set nowrap                  " don't wrap long lines
set showmatch               " briefly jump to matching bracket
set laststatus=2            " always show status bar
set ruler                   " show line/col in status bar
set showcmd                 " show partial command in bottom right
set wildmenu                " tab-completion menu for commands

" ── search ──────────────────────────────────────────────────────────────────
set ignorecase
set smartcase
set incsearch
set hlsearch

" ── indentation (C style) ───────────────────────────────────────────────────
set tabstop=4
set shiftwidth=4
set expandtab
set smartindent
set cindent                 " C-aware indentation (braces, switch/case, etc.)

" ── files & buffers ─────────────────────────────────────────────────────────
set hidden                  " switch buffers without saving
set autoread                " reload files changed outside vim
set noswapfile
set nobackup
set undofile                " persistent undo across sessions
set undodir=~/.vim/undo//

" ── clipboard ───────────────────────────────────────────────────────────────
set clipboard=unnamedplus   " yank/paste uses system clipboard

" ── splits ──────────────────────────────────────────────────────────────────
set splitright
set splitbelow

" ── keymaps ─────────────────────────────────────────────────────────────────
let mapleader = " "

nnoremap <leader>h :nohlsearch<CR>
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>

" split navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" move selected lines up/down in visual mode
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" keep cursor centred when jumping
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz
nnoremap n nzzzv
nnoremap N Nzzzv

" paste without clobbering register
xnoremap <leader>p "_dP

" ── C shortcuts ─────────────────────────────────────────────────────────────
nnoremap <leader>cb :!gcc -std=c17 -Wall -Wextra -g % -o %:r && echo "OK"<CR>
nnoremap <leader>cr :!./%:r<CR>
