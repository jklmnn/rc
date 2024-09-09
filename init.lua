vim.cmd('filetype plugin indent on')
vim.cmd('syntax enable')

vim.opt.path:append('**')
vim.opt.wildmenu = true
vim.opt.wildmode = 'longest:full'
vim.opt.showcmd = true
vim.opt.encoding = 'utf-8'
vim.opt.autoindent = true
vim.opt.number = true
vim.opt.showmatch = true
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.backspace = 'indent,eol,start'
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.cindent = true
vim.opt.splitright = true
vim.opt.listchars = 'eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:␣'
vim.opt.tabpagemax = 100
vim.opt.hidden = true
vim.opt.mouse = ''
vim.opt.termguicolors = true
vim.opt.showtabline = 2

require 'paq' {
    -- paq plugin manager
    'savq/paq-nvim',
    -- color theme
    'gruvbox-community/gruvbox',
    -- multi cursor support
    'mg979/vim-visual-multi',
    -- git commit message editing
    'rhysd/committia.vim',
    -- automatic closing of quotes and parenthesis etc.
    'Raimondi/delimitMate',
    -- git commands
    'tpope/vim-fugitive',
    -- comment stuff out
    'tpope/vim-commentary',
    -- automatic end tags in html, xml, etc
    'vim-scripts/sgmlendtag',
    -- absolute and relative line numbers
    'jeffkreeftmeijer/vim-numbertoggle',
    -- disable search highlighting after search
    'romainl/vim-cool',
    -- highlight trailing whitespace
    'ntpeters/vim-better-whitespace',
    -- operator alignment
    'junegunn/vim-easy-align',
    -- diff visual blocks
    'AndrewRadev/linediff.vim',
    -- switch between source and header files
    'thindil/a.vim',
    -- rust support
    'rust-lang/rust.vim',
    -- display vertical lines in indentations
    'Yggdroot/indentLine',
    -- tab and status bar
    'nvim-tree/nvim-web-devicons',
    'nvim-lualine/lualine.nvim',
    'akinsho/bufferline.nvim',
    -- fuzzy search
    'junegunn/fzf',
    -- black formatting for python
    'psf/black',
    -- gdb support
    'sakhnik/nvim-gdb',
    -- nvim-cmp source for buffer words
    'hrsh7th/cmp-buffer',
    -- nvim-cmp source for vim's cmdline
    'hrsh7th/cmp-cmdline',
    -- nvim-cmp source for built-in LSP client
    'hrsh7th/cmp-nvim-lsp',
    -- nvim-cmp source for filesystem paths
    'hrsh7th/cmp-path',
    -- auto completion
    'hrsh7th/nvim-cmp',
    -- asynchronous linting
    'mfussenegger/nvim-lint',
    -- collection of configurations for built-in LSP client
    'neovim/nvim-lspconfig',
    -- LSP signature hint as you type
    'ray-x/lsp_signature.nvim',
    -- quick jump to locations
    'ggandor/leap.nvim',
    -- yank buffer
    'gbprod/yanky.nvim',
    -- LSP project local settings
    'tamago324/nlsp-settings.nvim',
    -- ALS LSP config
    'TamaMcGlinn/nvim-lspconfig-ada',
}

if (vim.g.install_mode == 1) then
    return
end

vim.api.nvim_create_autocmd('FileType', {
    pattern = 'ada',
    command = 'setlocal expandtab shiftwidth=3 softtabstop=3 colorcolumn=80'
})

vim.api.nvim_create_autocmd('FileType', {
    pattern = 'python',
    command = 'setlocal colorcolumn=100'
})

vim.api.nvim_create_autocmd({'BufRead', 'BufNewFile'}, {
    pattern = '*.anod',
    command = 'setfiletype python'
})

vim.g['black_linelength'] = 100

vim.opt.background = 'dark'
vim.cmd('colorscheme gruvbox')

--  map Y y$
--
--  func! Multiple_cursors_before()
--  endfunc
--  func! Multiple_cursors_after()
--  endfunc

-- nvim-cmp
vim.opt.completeopt = 'menu,menuone,noselect'

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

require('lualine').setup()
require("bufferline").setup{}

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
    { name = 'path' },
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
    require("lint").try_lint(nil, { ignore_errors = true })
  end,
})

-- Set up lsp_signature
require('lsp_signature').setup()

require('nlspsettings').setup({})

-- Set up lspconfig
local capabilities = require('cmp_nvim_lsp').default_capabilities()
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

--  Set up language server for RecordFlux

vim.filetype.add({
  extension = {
    rflx = 'recordflux',
  }
})

local lspconfig = require 'lspconfig'
local configs = require 'lspconfig.configs'
local util = require 'lspconfig.util'

if not configs.rflx_ls then
  configs.rflx_ls = {
    default_config = {
      name = 'RecordFlux LS',
      cmd = { 'rflx', 'run_ls' },
      filetypes = { 'recordflux' },
      root_dir = util.root_pattern('*.rflx')
    };
  }
end

lspconfig.rflx_ls.setup {
  capabilities = capabilities,
  on_attach = on_attach,
}

require('leap').create_default_mappings()

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

-- Configure yanky
require("yanky").setup({})
vim.keymap.set({"n","x"}, "p", "<Plug>(YankyPutAfter)")
vim.keymap.set({"n","x"}, "P", "<Plug>(YankyPutBefore)")
vim.keymap.set({"n","x"}, "gp", "<Plug>(YankyGPutAfter)")
vim.keymap.set({"n","x"}, "gP", "<Plug>(YankyGPutBefore)")

-- Use the same keybindings as vim-yankstack
vim.keymap.set("n", "ð", "<Plug>(YankyPreviousEntry)")
vim.keymap.set("n", "Ð", "<Plug>(YankyNextEntry)")
