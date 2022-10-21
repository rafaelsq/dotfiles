-- Basic
-- :map j gg
-- :map Q j      (will be mapped to gg)
-- :noremap W j  (will be mapped to j)(re ~ recursive_mapping)
--
-- :lua dump(obj)
--
-- Debug LSP
-- enable debug; vim.lsp.set_log_level("debug")
-- open file and; :lua vim.cmd('e'..vim.lsp.get_log_path())


--------------------- Plugins

setTheme = function(theme)
  if theme == vim.env['THEME'] then

    vim.opt.termguicolors=true
    vim.opt.number=true
    vim.opt.signcolumn='yes'
    vim.opt.relativenumber=false

    if theme == 'ayu' then
      vim.g.ayucolor = "mirage"
    end

    vim.cmd('silent! colorscheme ' .. theme)

    -- fix for https://github.com/nvim-treesitter/nvim-treesitter/pull/3656
    vim.cmd('hi! link @variable Normal')

    -- transparent
    vim.api.nvim_set_hl(0, 'Normal', {bg=''})
    vim.api.nvim_set_hl(0, 'SignColumn', {bg=''})
    vim.api.nvim_set_hl(0, 'Pmenu', {bg=''})
    if vim.g.colors_name == 'molokai' then
      vim.g.molokai_original = 1
      vim.api.nvim_set_hl(0, 'MatchParen', {bg='#3C3535', fg='', bold=true})
      vim.api.nvim_set_hl(0, 'LineNr', {bg='', fg='#3C3535'})
    end

    -- highlight EOL
    vim.api.nvim_set_hl(0, 'WhitespaceEOL', {link='LspErrorHighlight'})
    vim.cmd[[
      match WhitespaceEOL /\\\@<!\s\+\%#\@<!$/
      augroup winenter_whitespaceeol
          autocmd!
          autocmd WinEnter * match WhiteSpaceEOL /\\\@<!\s\+\%#\@<!$/
      augroup END
    ]]

    -- only one status bar
    -- vim.o.laststatus = 3

    -- LSP
    vim.api.nvim_set_hl(0, 'LspCodeLens', {fg='#88C0D0', underline=true})

    -- GoC
    require'nvim-goc'.setup({verticalSplit = false})
  end
end

require('packer').startup(function()
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  ---- Search
  use {
    { 'junegunn/fzf', dir = '~/.fzf', run = './install --all' },
    { 'junegunn/fzf.vim' },
    { 'gfanto/fzf-lsp.nvim' },
    { 'nvim-lua/plenary.nvim' },
  }

  -- ident
  use 'tpope/vim-sleuth'

  -- Lsp
  use {
    'neovim/nvim-lspconfig',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    'hrsh7th/nvim-cmp',
    'onsails/lspkind-nvim',
    'nvim-lua/lsp-status.nvim',
    'jose-elias-alvarez/null-ls.nvim',
  }

  use {
    'SirVer/ultisnips',
    'quangnguyen30192/cmp-nvim-ultisnips',
  }

  -- status bar
  use {
    'nvim-lualine/lualine.nvim',
    'kyazdani42/nvim-web-devicons',
  }

  -- Go
  use 'rafaelsq/nvim-goc.lua'

  -- theme
  use 'nvim-treesitter/nvim-treesitter'

  use {
    {'arcticicestudio/nord-vim',        config = setTheme("nord")},
    {'gruvbox-community/gruvbox',       config = setTheme("gruvbox")},
    {'tomasr/molokai',                  config = setTheme("molokai")},
    {'joshdick/onedark.vim',            config = setTheme("onedark")},
    {'dracula/vim', as  =  'dracula',   config = setTheme("dracula")},
    {'ayu-theme/ayu-vim',               config = setTheme("ayu")},
  }

  -- Git
  use 'airblade/vim-gitgutter'   -- \hp, \hs, \hu [c, ]c
  use 'rhysd/git-messenger.vim'  -- \m\m; ?, o, O, d, D

  use 'tpope/vim-surround'
  use 'rafaelsq/nvim-yanks.lua'

  -- scrollbar
  use 'petertriho/nvim-scrollbar'

  -- search
  use { 'kevinhwang91/nvim-hlslens' }

  -- tmux integration
  if vim.env['TMUX'] then
    use 'christoomey/vim-tmux-navigator'
  end
end)

------------- highlight lua
vim.g.vimsyn_embed = 'lPr'


------------- higlight graphql
vim.cmd('autocmd BufEnter *.graphql setf graphql')
vim.cmd('autocmd BufEnter go.mod setf gomod')


--------------------- TreeSitter
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "go", "gomod", "javascript", "tsx", "json", "yaml", "html", "css", "vue", "typescript", "python", "elixir", "graphql", "lua" },

  highlight = { enable = true },
  incremental_selection = { enable = true },
}


--------------------- StatusBar

local colors = {
  blue   = '#61afef',
  green  = '#98c379',
  purple = '#c678dd',
  cyan   = '#56b6c2',
  red1   = '#e06c75',
  red2   = '#be5046',
  yellow = '#e5c07b',
  fg     = '#abb2bf',
  bg     = '#282c34',
  gray1  = '#828997',
  gray2  = '#2c323c',
  gray3  = '#4e5462',
}

require('lualine').setup {
  options = {
    component_separators = {
      left = "",
      right = ""
    },
    theme  = {
      normal = {
        a = { fg = colors.gray1 },
        b = { fg = colors.yellow },
        c = { fg = colors.green },
        x = { fg = colors.gray3 },
      },
      inactive = {
        a = { fg = colors.gray3 },
        b = { fg = colors.gray3 },
        c = { fg = colors.gray3 },
      },
    }
  },
  sections = {
    lualine_a = {'filetype'},
    lualine_b = {"vim.trim(require'lsp-status'.status())"},
    lualine_c = {
      {
        'filename',
        file_status = true, -- displays file status (readonly status, modified status)
        path = 1 -- 0 = just filename, 1 = relative path, 2 = absolute path
      },
    },
    lualine_x = {'encoding'},
    lualine_y = {'location', 'diff'},
    lualine_z = {'diagnostics'},
  },
}

--------------------- Yanks
local yanks = require'nvim-yanks'
yanks.setup()
vim.keymap.set('n', '<space>y', yanks.Show, {silent=true})

--------------------- GoC
vim.opt.switchbuf = 'useopen'

if vim.env['THEME'] == 'nord' then
  vim.api.nvim_set_hl(0, 'GocUncovered', {fg='#BF616A'})
end

local goc = require'nvim-goc'

vim.keymap.set('n', '<space>gcf', goc.Coverage, {silent=true})
vim.keymap.set('n', '<space>gcc', goc.ClearCoverage, {silent=true})
vim.keymap.set('n', '<space>gct', goc.CoverageFunc, {silent=true})
vim.keymap.set('n', ']a', goc.Alternate, {silent=true})
vim.keymap.set('n', '[a', goc.AlternateSplit, {silent=true})

local cf = function(testCurrentFunction)

  local cb = function(path)
    if path then
      vim.cmd(":silent exec \"!xdg-open " .. path .. "\"")
    end
  end

  if testCurrentFunction then
    goc.CoverageFunc(nil, cb, 0)
  else
    goc.Coverage(nil, cb)
  end
end

vim.keymap.set('n', '<space>gca', cf, {silent=true})
vim.keymap.set('n', '<space>gcb', function() cf(true) end, {silent=true})

--------------------- opts
vim.opt.list = true
vim.opt.listchars = { tab = '┆ ', trail = ' ' }
vim.opt.tabstop = 4
vim.opt.shiftwidth=4
vim.opt.scrolloff=5
vim.opt.mouse='a'
vim.opt.ignorecase=true
vim.opt.updatetime=200
vim.opt.hidden=true
vim.opt.colorcolumn='120'
vim.opt.swapfile=false

vim.opt.clipboard = { 'unnamed', 'unnamedplus' }

-- prevent p/P to yank
vim.keymap.set('x', 'p', '\'pgv"\'.v:register."y"', {expr = true})
vim.keymap.set('x', 'P', '\'Pgv"\'.v:register."y"', {expr = true})

-- close scratch window, quickfix & Remove search highlight
vim.keymap.set('n', '<space><space>', ':cclose<CR> :lclose<CR> :nohlsearch<CR> :pclose<CR>', {})

-- up and down on splitted lines
vim.keymap.set('', '<Up>', 'gk', {})
vim.keymap.set('', '<Down>', 'gj', {})
vim.keymap.set('', 'k', 'gk', {})
vim.keymap.set('', 'j', 'gj', {})

-- fix watch for parcel
--vim.opt.backupcopy='no'

-- if vim.fn.has('macunix') then
--   vim.keymap.set('n', '"', '^', {noremap=true})
--   vim.keymap.set('v', '"', '^', {noremap=true})
--   vim.keymap.set('n', 'Ç', ':', {noremap=true})
--   vim.keymap.set('v', 'Ç', ":'<,'>", {noremap=true})
-- end

-- map tabs
vim.keymap.set('n', '<space>t', ':tabe<CR>')
vim.keymap.set('n', '<space>1', '1gt')
vim.keymap.set('n', '<space>2', '2gt')
vim.keymap.set('n', '<space>3', '3gt')
vim.keymap.set('n', '<space>4', '4gt')
vim.keymap.set('n', '<space>5', '5gt')

--------------------- FZF search
vim.env.FZF_DEFAULT_COMMAND = vim.env.FZF_DEFAULT_COMMAND .. ' --ignore "*generated*" --ignore test/mock'

vim.keymap.set('n', '<C-p>', ':Files<CR>', {silent=true})
vim.keymap.set('n', '<space>b', ':Buffers<CR>', {})
vim.keymap.set('n', '<space>f', ':BLines<CR>', {})

-- clear buffers
vim.keymap.set('n', '<space>cb', ':%bd|e#|bd#<CR>', {})


-- select word under cursor
vim.keymap.set('x', '<space>a', '"yy:Ag <c-r>y<cr>', {})

-- search selection
vim.keymap.set('n', '<space>a', ':Ag <c-r><c-w><cr>', {})


--------------------- Git Messenger
vim.keymap.set('n', '<space>m', '<Plug>(git-messenger)', {})

--------------------- GitGutter
vim.g.gitgutter_map_keys=0
vim.keymap.set('n', '<space>hu', ':GitGutterUndoHunk<CR>', { noremap=true })
vim.keymap.set('n', '<space>hp', ':GitGutterPreviewHunk<CR>', { noremap=true })
vim.keymap.set('n', '<space>hs', ':GitGutterStageHunk<CR>', { noremap=true })
vim.keymap.set('n', '<space>hd', ':GitGutterDiffOrig<CR>', { noremap=true })
vim.keymap.set('n', '[c', ':GitGutterPrevHunk<CR>', { noremap=true })
vim.keymap.set('n', ']c', ':GitGutterNextHunk<CR>', { noremap=true })

----------- custom
vim.keymap.set('n', '<space>co', ':!git checkout %<CR><CR>', {})


--------------------- Plug
vim.keymap.set('n', '<space>pu', ':PackerUpdate<CR>', {})


--------------------- Snippet
vim.g.UltiSnipsExpandTrigger = "<tab>"
vim.g.UltiSnipsJumpForwardTrigger = "<tab>"
vim.g.UltiSnipsJumpBackwardTrigger = "<s-tab>"


--------------------- utils
function _G.dump(...)
    local objects = vim.tbl_map(vim.inspect, {...})
    print(unpack(objects))
end


----------- run
vim.cmd('autocmd FileType go nmap <space>rg :!go run %<CR>')


--------------------- Quickfix

function _G.openQuickfix(new_split_cmd)
  local line = vim.api.nvim_win_get_cursor(0)[1]
  local loc = vim.fn.getloclist(0)[line]
  vim.cmd('wincmd p')
  if string.len(new_split_cmd) > 0 then
    vim.cmd(new_split_cmd)
  end
  vim.fn.cursor(loc.lnum, loc.col)
  vim.cmd('lclose')
end

vim.cmd('autocmd FileType qf nnoremap <buffer> <C-v> :lua openQuickfix("vsplit")<CR>')
vim.cmd('autocmd FileType qf nnoremap <buffer> <C-x> :lua openQuickfix("split")<CR>')
vim.cmd('autocmd FileType qf nnoremap <buffer> <CR> :lua openQuickfix("")<CR>')

-- no j/k for quickfix
vim.cmd('autocmd FileType qf map <buffer> k k')
vim.cmd('autocmd FileType qf map <buffer> j j')

-- focus
-- vim.keymap.set('n', '<space>q', ':copen<CR>', {})


--------------------- Tmux integration
-- use alt+<dir> to navigate between windows
if vim.env['TMUX'] then
  vim.g.tmux_navigator_no_mappings = 1

  vim.keymap.set('n', '<A-h>', ':TmuxNavigateLeft<cr>', {silent=true})
  vim.keymap.set('n', '<A-j>', ':TmuxNavigateDown<cr>', {silent=true})
  vim.keymap.set('n', '<A-k>', ':TmuxNavigateUp<cr>', {silent=true})
  vim.keymap.set('n', '<A-l>', ':TmuxNavigateRight<cr>', {silent=true})
else
  vim.keymap.set('', '<A-h>', '<C-w>h', {})
  vim.keymap.set('', '<A-j>', '<C-w>j', {})
  vim.keymap.set('', '<A-k>', '<C-w>k', {})
  vim.keymap.set('', '<A-l>', '<C-w>l', {})
end


--------------------- Debug
-- vim.g.lsp_log_verbose = 1
-- vim.g.lsp_log_file = expand('~/vim-lsp.log')
-- vim.g.asyncomplete_log_file = expand('~/asyncomplete.log')

--------------------- LSP

local lsp = require'lspconfig'

local lsp_status = require('lsp-status')

-- https://github.com/neovim/nvim-lspconfig/issues/115
function org_imports()
  local clients = vim.lsp.buf_get_clients()
  for _, client in pairs(clients) do

    local params = vim.lsp.util.make_range_params(nil, client.offset_encoding)
    params.context = {only = {"source.organizeImports"}}

    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 5000)
    for _, res in pairs(result or {}) do
      for _, r in pairs(res.result or {}) do
        if r.edit then
          vim.lsp.util.apply_workspace_edit(r.edit, client.offset_encoding)
        else
          vim.lsp.buf.execute_command(r.command)
        end
      end
    end
  end
end

local opts = { noremap=true, silent=true }

vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '<space>g', vim.diagnostic.setloclist, opts)
vim.keymap.set('n', '[g', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']g', vim.diagnostic.goto_next, opts)

-- Use an on_attach function to only map the following keys 
-- after the language server attaches to the current buffer
local setDir = false
local on_attach = function(client, bufnr)
  -- use project root_dir
  if not setDir and client.config.root_dir then
    vim.api.nvim_set_current_dir(client.config.root_dir)
    setDir = true
  end

  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local opts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', '<c-]>', vim.lsp.buf.declaration, opts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', '<space>gvd', '<C-w>v <cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.keymap.set('n', '<space>gd', '<C-w>s <cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.keymap.set('n', 'gD', vim.lsp.buf.type_definition, opts)
  vim.keymap.set('n', '<space>gvD', '<C-w>v <cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  vim.keymap.set('n', '<space>gD', '<C-w>s <cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  vim.keymap.set('i', '<c-s>', vim.lsp.buf.hover, opts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
  vim.keymap.set('n', '<c-k>', vim.lsp.buf.signature_help, opts)
  vim.keymap.set('i', '<c-k>', vim.lsp.buf.signature_help, opts)
  vim.keymap.set('n', '<space>gs', vim.lsp.buf.document_symbol, opts)
  vim.keymap.set('n', '<space>gf', function() vim.lsp.buf.format { async = true } end, opts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
  vim.keymap.set('n', '<space>gW', vim.lsp.buf.workspace_symbol, opts)
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, opts)
  vim.keymap.set('x', '<space>ca', vim.lsp.buf.code_action, opts)
  vim.keymap.set('i', '<C-c>', '<ESC><cmd>lua vim.lsp.buf.code_action()<CR>', opts)

  if type(client.server_capabilities.codeLensProvider) == 'table' then
    vim.keymap.set('n', '<space>cl', vim.lsp.codelens.run, opts)

    vim.api.nvim_create_autocmd("CursorHold,CursorHoldI,InsertLeave", {
      callback = vim.lsp.codelens.refresh, buffer=bufnr
    })
  end

  lsp_status.on_attach(client)
end

local capabilities = require('cmp_nvim_lsp').default_capabilities()
capabilities = vim.tbl_extend('keep', capabilities, lsp_status.capabilities)

local servers = { 'tsserver', 'pyright', 'html', 'cssls', 'jsonls', 'vuels', 'yamlls', 'dockerls', 'vimls', 'rust_analyzer', 'graphql' }
for _, l in ipairs(servers) do
  lsp[l].setup {
    on_attach = on_attach,
    capabilities = capabilities,
    flags = {
      debounce_text_changes = 150,
    }
  }
end

-- https://github.com/neovim/neovim/blob/master/runtime/doc/lsp.txt#L810
-- https://github.com/golang/tools/blob/master/gopls/doc/settings.md
lsp.gopls.setup{
  on_attach = on_attach,
  capabilities = capabilities,
  init_options = {
    ['local'] = string.gmatch(vim.fn.getcwd(), '/([^/]+)$')(),
    analyses = {
      unusedparams = true,
    },
    codelenses = {
      gc_details = true,
      test = true,
    },
  },
}

lsp.eslint.setup{
  on_attach = on_attach,
  capabilities = capabilities,
  flags = {
    debounce_text_changes = 150,
  },
  settings = {
    packageManager = 'yarn',
  },
}

lsp.elixirls.setup{
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = { vim.fn.expand("~/.elixirls/language_server.sh") },
}

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.go,*.rs" },
  callback = function(args)
    vim.lsp.buf.format({sync=true})
  end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.go" },
  callback = org_imports,
})


--------------------- NullLs

local null_ls = require("null-ls")
null_ls.setup({
  sources = { -- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md
    -- golang
    null_ls.builtins.diagnostics.golangci_lint.with {
      -- for fast operation add argument; "--fast",
      args = { "run", "--fix=false", "--out-format=json", "$DIRNAME", "--path-prefix", "$ROOT" },
    },

    -- python
    null_ls.builtins.diagnostics.flake8.with {
      args = { "--format", "default", "--ignore", "E501", "--stdin-display-name", "$FILENAME", "-" },
    },
    null_ls.builtins.formatting.autopep8,
    null_ls.builtins.formatting.isort,

    -- many
    null_ls.builtins.formatting.prettierd,
  },
  -- on_attach = function(client, bufnr)
  --   if client.supports_method("textDocument/formatting") then
  --     vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
  --     vim.api.nvim_create_autocmd("BufWritePre", {
  --       group = augroup,
  --       buffer = bufnr,
  --       callback = function()
  --         vim.lsp.buf.format({ bufnr = bufnr })
  --       end,
  --     })
  --   end
  -- end,
})

--------------------- Fzf-lsp
local fzf_lsp = require'fzf_lsp'

local bk = {
  fn = function() end,
  p = {},
}

vim.keymap.set('n', '<space>q', function() bk.fn(unpack(bk.p)) end, {})

local function filter(fn)
  return (function(...)
    return (function(...)
      result = select(2, ...)
      local fallback = type(result) == 'string'
      if fallback then
        result = select(3, ...)
      end
      if vim.tbl_islist(result) then
        result = vim.tbl_filter(function(v) return string.find(v.uri, "_test.go") == nil and string.find(v.uri, "mock") == nil end, result)
      end

      local p = {...}
      if fallback then
        p[3] = result
      else
        p[2] = result
      end

      -- backup last
      bk = {
        fn = fn,
        p = p,
      }

      fn(unpack(p))
    end)(...)
  end)
end

vim.lsp.handlers["textDocument/codeAction"] = fzf_lsp.code_action_handler
vim.lsp.handlers["textDocument/definition"] = fzf_lsp.definition_handler
vim.lsp.handlers["textDocument/declaration"] = fzf_lsp.declaration_handler
vim.lsp.handlers["textDocument/typeDefinition"] = fzf_lsp.type_definition_handler
vim.lsp.handlers["textDocument/implementation"] = filter(fzf_lsp.implementation_handler)
vim.lsp.handlers["textDocument/references"] = filter(fzf_lsp.references_handler)
vim.lsp.handlers["textDocument/documentSymbol"] = fzf_lsp.document_symbol_handler
vim.lsp.handlers["workspace/symbol"] = fzf_lsp.workspace_symbol_handler
vim.lsp.handlers["callHierarchy/incomingCalls"] = fzf_lsp.incoming_calls_handler
vim.lsp.handlers["callHierarchy/outgoingCalls"] = fzf_lsp.outgoing_calls_handler


------------ completion
local cmp = require('cmp')

vim.opt.completeopt = 'menu,menuone,noselect'

cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["UltiSnips#Anon"](args.body)
    end,
  },
  completion = {
    completeopt = 'menu,menuone,noinsert',
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    ['<C-e>'] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
  }),
  formatting = {
    format = function(entry, vim_item)
      -- fancy icons and a name of kind
      vim_item.kind = require("lspkind").presets.default[vim_item.kind] .. " " .. vim_item.kind

      -- set a name for each source
      vim_item.menu = ({
        buffer = "[Buffer]",
        nvim_lsp = "[LSP]",
        luasnip = "[LuaSnip]",
        nvim_lua = "[Lua]",
        latex_symbols = "[Latex]",
      })[entry.source.name]
      return vim_item
    end,
  },
  window = {
    -- completion = cmp.config.window.bordered(),
    -- documentation = cmp.config.window.bordered(),
  },
  sources = cmp.config.sources({
    { name = 'ultisnips' },
    { name = 'nvim_lsp' },
    -- { name = 'buffer' },
  }),
  experimental = {
    ghost_text = true
  }
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

-- add c-y to :
vim.keymap.set('c', '<C-y>', '', {
  callback = function()
    cmp.confirm({ select = false })
  end,
})

--------------------- LspStatusBar

lsp_status.register_progress()
lsp_status.config({status_symbol = '', diagnostics = false})

--------------------- Scrollbar

require("scrollbar").setup({
  handle = {
    color = '#171b21',
  },
  handlers = {
    search = true,
  },
})

vim.keymap.set('n', 'n', '<cmd>execute("normal! " . v:count1 . "n")<CR><Cmd>lua require("hlslens").start()<CR>', { noremap=true, silent=true })
vim.keymap.set('n', 'N', '<cmd>execute("normal! " . v:count1 . "N")<CR><Cmd>lua require("hlslens").start()<CR>', { noremap=true, silent=true })
vim.keymap.set('n', '*', '*<cmd>lua require("hlslens").start()<CR>', { noremap=true })
vim.keymap.set('n', '#', '#<cmd>lua require("hlslens").start()<CR>', { noremap=true })
vim.keymap.set('n', 'g*', 'g*<cmd>lua require("hlslens").start()<CR>', { noremap=true })
vim.keymap.set('n', 'g#', 'g#<cmd>lua require("hlslens").start()<CR>', { noremap=true })

vim.api.nvim_set_hl(0, 'HlSearchLens', {link='Comment'})
vim.api.nvim_set_hl(0, 'HlSearchNear', {link='Info'})
