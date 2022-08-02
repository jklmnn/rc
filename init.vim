if &compatible
    set nocompatible
endif

if has('nvim')
call plug#begin(stdpath('data').'plugged')
else
call plug#begin('~/.vim/plugged')
endif
    Plug 'https://github.com/mg979/vim-visual-multi.git'
    Plug 'https://github.com/rhysd/committia.vim.git'
    Plug 'https://github.com/Raimondi/delimitMate.git'
    Plug 'https://github.com/tpope/vim-fugitive.git'
    Plug 'https://github.com/vim-scripts/sgmlendtag.git'
    Plug 'https://github.com/jeffkreeftmeijer/vim-numbertoggle.git'
    Plug 'https://github.com/romainl/vim-cool.git'
    Plug 'https://github.com/maxbrunsfeld/vim-yankstack.git'
    Plug 'ntpeters/vim-better-whitespace'
    Plug 'junegunn/vim-easy-align'
    Plug 'https://github.com/AndrewRadev/linediff.vim.git'
    Plug 'https://github.com/thindil/a.vim.git'
    Plug 'rust-lang/rust.vim'
    Plug 'https://github.com/Yggdroot/indentLine.git'
    Plug 'vim-airline/vim-airline'
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

let g:airline#extensions#tabline#enabled = 1

if !has('nvim')
" mucomplete
    set completeopt+=menuone
    set completeopt+=noselect
    set shortmess+=c
endif

colorscheme ron

map Y y$

func! Multiple_cursors_before()
endfunc
func! Multiple_cursors_after()
endfunc

if has('nvim')
    let g:LanguageClient_serverCommands = {
        \ 'rust': ['rustup', 'run', 'stable', 'rls'],
        \ 'python': ['pyls'],
        \ 'ada': ['ada_language_server']
        \ }
    let g:deoplete#enable_at_startup = 1
    ""<TAB>: completion.
    inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
    inoremap <expr><S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
    inoremap <expr><up> pumvisible() ? '<c-e><up>' : '<up>'
    inoremap <expr><down> pumvisible() ? '<c-e><down>' : '<down>'
else
    let g:mucomplete#enable_auto_at_startup = 1
    let g:mucomplete#completion_delay = 1
endif

au BufRead,BufNewFile *.anod             setfiletype python
au BufRead,BufNewFile *.rflx             setfiletype ada
