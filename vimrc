set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

    Plugin 'VundleVim/Vundle.vim'
    Plugin 'https://github.com/terryma/vim-multiple-cursors.git'
    Plugin 'https://github.com/rhysd/committia.vim.git'
    Plugin 'rust-lang/rust.vim'
    Plugin 'https://github.com/Raimondi/delimitMate.git'
    Plugin 'https://github.com/tpope/vim-fugitive.git'
    Plugin 'https://github.com/vim-scripts/sgmlendtag.git'
    Plugin 'https://github.com/cohama/agit.vim'
    Plugin 'https://github.com/vim-scripts/DoxygenToolkit.vim.git'
    Plugin 'https://github.com/easymotion/vim-easymotion.git'
    Plugin 'https://github.com/jeffkreeftmeijer/vim-numbertoggle.git'
    Plugin 'https://github.com/vim-scripts/cscope.vim.git'
    Plugin 'https://github.com/romainl/vim-cool.git'
    Plugin 'https://github.com/Valloric/YouCompleteMe.git'
    Plugin 'https://github.com/maxbrunsfeld/vim-yankstack.git'
    Plugin 'https://github.com/lervag/vimtex.git'
    Plugin 'https://github.com/SirVer/ultisnips.git'
    Bundle 'honza/vim-snippets'
    Plugin 'ntpeters/vim-better-whitespace'

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

colorscheme ron

map Y y$

let g:ycm_enable_diagnostic_highlighting = 0
let g:ycm_error_symbol = 'e:'
let g:ycm_warning_symbol = 'w:'

let g:UltiSnipsEditSplit="vertical"
let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"
let g:UltiSnipsSnippetDirectories=["UltiSnips", "usnippets"]
