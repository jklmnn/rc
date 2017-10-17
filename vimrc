set nocompatible
filetype off

" git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

    Plugin 'VundleVim/Vundle.vim'
    Plugin 'https://github.com/terryma/vim-multiple-cursors.git'
    Plugin 'https://github.com/rhysd/committia.vim.git'
    Plugin 'rust-lang/rust.vim'
    Plugin 'https://github.com/Raimondi/delimitMate.git'
    Plugin 'https://github.com/tpope/vim-fugitive.git'
    Plugin 'https://github.com/vim-scripts/sgmlendtag.git'

call vundle#end()

filetype plugin indent on

syntax on

set wildmenu
set showcmd
set encoding=utf-8
set autoindent
set number
set showmatch
set hlsearch
set ignorecase
set smartcase
set backspace=indent,eol,start
set pastetoggle=<F11>
set shiftwidth=4
set softtabstop=4
set expandtab
set cindent
set splitright
set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:␣

map Y y$

let g:ycm_enable_diagnostic_highlighting = 0
let g:ycm_error_symbol = 'e:'
let g:ycm_warning_symbol = 'w:'
