if &compatible
    set nocompatible
endif

call plug#begin(stdpath('data').'plugged')
    Plug 'VundleVim/Vundle.vim'
    Plug 'https://github.com/terryma/vim-multiple-cursors.git'
    Plug 'https://github.com/rhysd/committia.vim.git'
    Plug 'https://github.com/Raimondi/delimitMate.git'
    Plug 'https://github.com/tpope/vim-fugitive.git'
    Plug 'https://github.com/vim-scripts/sgmlendtag.git'
    Plug 'https://github.com/jeffkreeftmeijer/vim-numbertoggle.git'
    Plug 'https://github.com/romainl/vim-cool.git'
    Plug 'https://github.com/maxbrunsfeld/vim-yankstack.git'
    Plug 'ntpeters/vim-better-whitespace'
    Plug 'https://github.com/ap/vim-buftabline.git'
    Plug 'junegunn/vim-easy-align'
    Plug 'https://github.com/AndrewRadev/linediff.vim.git'
    Plug 'https://github.com/thindil/a.vim.git'
    "Plug extend
call plug#end()

filetype plugin indent on
syntax enable

autocmd FileType ada setlocal expandtab shiftwidth=3 softtabstop=3 colorcolumn=120

set path+=**
set wildmenu
set wildmode=longest:full
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
set tabpagemax=100
set hidden

colorscheme ron

map Y y$

let g:deoplete#enable_at_startup = 1

" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr><up> pumvisible() ? '<c-e><up>' : '<up>'
inoremap <expr><down> pumvisible() ? '<c-e><down>' : '<down>'
