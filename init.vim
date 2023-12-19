if &compatible
    set nocompatible
endif

if has('nvim')
call plug#begin(stdpath('data').'plugged')
else
call plug#begin('~/.vim/plugged')
endif
    " color theme
    Plug 'https://github.com/tobi-wan-kenobi/zengarden.git'
    " multi cursor support
    Plug 'https://github.com/mg979/vim-visual-multi.git'
    " git commit message editing
    Plug 'https://github.com/rhysd/committia.vim.git'
    " automatic closing of quotes and parenthesis etc.
    Plug 'https://github.com/Raimondi/delimitMate.git'
    " git commands
    Plug 'https://github.com/tpope/vim-fugitive.git'
    " comment stuff out
    Plug 'https://github.com/tpope/vim-commentary.git'
    " automatic end tags in html, xml, etc
    Plug 'https://github.com/vim-scripts/sgmlendtag.git'
    " absolute and relative line numbers
    Plug 'https://github.com/jeffkreeftmeijer/vim-numbertoggle.git'
    " disable search highlighting after search
    Plug 'https://github.com/romainl/vim-cool.git'
    " yank and delete in a stack
    Plug 'https://github.com/maxbrunsfeld/vim-yankstack.git'
    " highlight trailing whitespace
    Plug 'ntpeters/vim-better-whitespace'
    " operator alignment
    Plug 'junegunn/vim-easy-align'
    " diff visual blocks
    Plug 'https://github.com/AndrewRadev/linediff.vim.git'
    " switch between source and header files
    Plug 'https://github.com/thindil/a.vim.git'
    " rust support
    Plug 'rust-lang/rust.vim'
    " display vertical lines in indentations
    Plug 'https://github.com/Yggdroot/indentLine.git'
    " tab and status bar
    Plug 'vim-airline/vim-airline'
    " fuzzy search
    Plug 'junegunn/fzf'
    " black formatting for python
    Plug 'psf/black'
    if has('nvim')
        " gdb support
        Plug 'sakhnik/nvim-gdb'
        " nvim-cmp source for buffer words
        Plug 'hrsh7th/cmp-buffer'
        " nvim-cmp source for vim's cmdline
        Plug 'hrsh7th/cmp-cmdline'
        " nvim-cmp source for built-in LSP client
        Plug 'hrsh7th/cmp-nvim-lsp'
        " nvim-cmp source for filesystem paths
        Plug 'hrsh7th/cmp-path'
        " auto completion
        Plug 'hrsh7th/nvim-cmp'
        " asynchronous linting
        Plug 'mfussenegger/nvim-lint'
        " collection of configurations for built-in LSP client
        Plug 'neovim/nvim-lspconfig'
        " LSP signature hint as you type
        Plug 'ray-x/lsp_signature.nvim'
        " quick jump to locations
        Plug 'phaazon/hop.nvim'
    else
        " vim auto completion
        Plug 'https://github.com/lifepillar/vim-mucomplete.git'
    endif
    "Plug extend
call plug#end()

filetype plugin indent on
syntax enable

autocmd FileType ada setlocal expandtab shiftwidth=3 softtabstop=3 colorcolumn=120
autocmd FileType python setlocal colorcolumn=100

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

augroup Binary
  au!
  au BufReadPre  *.raw let &bin=1
  au BufReadPost *.raw if &bin | %!xxd
  au BufReadPost *.raw set ft=xxd | endif
  au BufWritePre *.raw if &bin | %!xxd -r
  au BufWritePre *.raw endif
  au BufWritePost *.raw if &bin | %!xxd
  au BufWritePost *.raw set nomod | endif
augroup END

let g:airline#extensions#tabline#enabled = 1
let g:black_linelength = 100

if !has('nvim')
" mucomplete
    set completeopt+=menuone
    set completeopt+=noselect
    set shortmess+=c
    let g:mucomplete#enable_auto_at_startup = 1
    let g:mucomplete#completion_delay = 1
endif

colorscheme zengarden
set background=dark

map Y y$

func! Multiple_cursors_before()
endfunc
func! Multiple_cursors_after()
endfunc

if has('nvim')
  " nvim-cmp
  set completeopt=menu,menuone,noselect

  lua <<EOF
    local has_words_before = function()
      local line, col = unpack(vim.api.nvim_win_get_cursor(0))
      return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
    end

    local feedkey = function(key, mode)
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
    end

    -- Set up nvim-cmp
    local cmp = require'cmp'

    cmp.setup({
      snippet = {
        expand = function(args)
          vim.fn["vsnip#anonymous"](args.body)
        end,
      },
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      mapping = {
          ["<Tab>"] = cmp.mapping(function(fallback)
             if cmp.visible() then
               cmp.complete()
               cmp.select_next_item()
             elseif has_words_before() then
               cmp.complete()
             else
               fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
             end
           end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function()
          if cmp.visible() then
            cmp.select_prev_item()
          elseif vim.fn["vsnip#jumpable"](-1) == 1 then
            feedkey("<Plug>(vsnip-jump-prev)", "")
          end
        end, { "i", "s" }),
      },
      sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'vsnip' },
      }, {
        { name = 'buffer' },
      })
    })

    -- Set configuration for specific filetype
    cmp.setup.filetype('gitcommit', {
      sources = cmp.config.sources({
        { name = 'cmp_git' }, -- You can specify the `cmp_git` source if it is installed.
      }, {
        { name = 'buffer' },
      })
    })

    -- Use buffer source for `/` and `?` (if you enable `native_menu`, this won't work anymore)
    cmp.setup.cmdline({ '/', '?' }, {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = 'buffer' }
      }
    })

    -- Use cmdline & path source for ':' (if you enable `native_menu`, this won't work anymore)
    cmp.setup.cmdline(':', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = 'path' }
      }, {
        { name = 'cmdline' }
      })
    })

    -- Mappings
    -- See `:help vim.diagnostic.*` for documentation on any of the below functions
    local opts = { noremap=true, silent=true }
    vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
    vim.keymap.set('n', '<C-k>', vim.diagnostic.goto_prev, opts)
    vim.keymap.set('n', '<C-j>', vim.diagnostic.goto_next, opts)
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
    vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

    -- Use an on_attach function to only map the following keys
    -- after the language server attaches to the current buffer
    local on_attach = function(client, bufnr)
      -- Enable completion triggered by <c-x><c-o>
      vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

      -- Mappings
      -- See `:help vim.lsp.*` for documentation on any of the below functions
      local bufopts = { noremap=true, silent=true, buffer=bufnr }
      vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
      vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
      -- vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
      vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
      vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
      vim.keymap.set('n', '<space>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end, bufopts)
      vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
      vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
      vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
      vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
      vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)
    end

    -- Set up nvim-lint
    require('lint').linters_by_ft = {
      python = {'pylint', 'mypy', 'pydocstyle'}
    }

    vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost" }, {
      callback = function()
        require("lint").try_lint()
      end,
    })

    -- Set up lsp_signature
    require('lsp_signature').setup()

    -- Set up lspconfig
    local capabilities = require('cmp_nvim_lsp').default_capabilities()
    require('lspconfig')['als'].setup {
      capabilities = capabilities,
      on_attach = on_attach,
    }
    require('lspconfig')['pyright'].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = {
        python = {
          analysis = {
            typeCheckingMode = "off",
          }
        }
      }
    }
    require('lspconfig')['rust_analyzer'].setup{
      capabilities = capabilities,
      on_attach = on_attach,
      settings = {
        ["rust-analyzer"] = {}
      },
    }

    require('hop').setup()
    local hop = require('hop')
    local directions = require('hop.hint').HintDirection
    vim.keymap.set('', 'f', function()
      hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = false })
    end, {remap=true})
    vim.keymap.set('', 'F', function()
      hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = false })
    end, {remap=true})

    -- Filter out specific diagnostic messages
    -- https://github.com/neovim/nvim-lspconfig/issues/726
    function filter(arr, func)
      -- Filter in place
      -- https://stackoverflow.com/questions/49709998/how-to-filter-a-lua-array-inplace
      local new_index = 1
      local size_orig = #arr
      for old_index, v in ipairs(arr) do
        if func(v, old_index) then
          arr[new_index] = v
          new_index = new_index + 1
        end
      end
      for i = new_index, size_orig do arr[i] = nil end
    end

    function filter_diagnostics(diagnostic)
      if diagnostic.source == "Pyright" and diagnostic.severity == vim.diagnostic.severity.HINT and string.match(diagnostic.message, '".+" is not accessed') then
        return false
      end
      return true
    end

    function custom_on_publish_diagnostics(a, params, client_id, c, config)
      filter(params.diagnostics, filter_diagnostics)
      vim.lsp.diagnostic.on_publish_diagnostics(a, params, client_id, c, config)
    end

    vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(custom_on_publish_diagnostics, {})

    -- Configure diagnostics
    vim.diagnostic.config({
      float = {
        border = 'rounded',
        source = 'always',
      },
    })
EOF
endif

au BufRead,BufNewFile *.anod             setfiletype python
au BufRead,BufNewFile *.rflx             setfiletype ada
