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
-- https://github.com/junegunn/vim-plug
vim.cmd('call plug#begin()')

-- Search
vim.cmd("Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }")
vim.cmd("Plug 'junegunn/fzf.vim'")
vim.cmd("Plug 'gfanto/fzf-lsp.nvim'")

-- ident
vim.cmd("Plug 'tpope/vim-sleuth'")

-- Lsp
vim.cmd("Plug 'neovim/nvim-lspconfig'")
vim.cmd("Plug 'rafaelsq/completion-nvim'")
vim.cmd("Plug 'hrsh7th/vim-vsnip'")
vim.cmd("Plug 'hrsh7th/vim-vsnip-integ'")

-- status bar
vim.cmd("Plug 'vim-airline/vim-airline'")
vim.cmd("Plug 'vim-airline/vim-airline-themes'")

-- theme
vim.cmd("Plug 'nvim-treesitter/nvim-treesitter'")
vim.cmd("Plug 'arcticicestudio/nord-vim'")
vim.cmd("Plug 'gruvbox-community/gruvbox'")
vim.cmd("Plug 'dracula/vim', { 'name': 'dracula' }")
vim.cmd("Plug 'tomasr/molokai'")
vim.cmd("Plug 'joshdick/onedark.vim'")

-- Git
vim.cmd("Plug 'airblade/vim-gitgutter'")   -- \hp, \hs, \hu [c, ]c
vim.cmd("Plug 'rhysd/git-messenger.vim'")  -- \m\m; ?, o, O, d, D

-- snippets
vim.cmd("Plug 'SirVer/ultisnips'")
vim.cmd("Plug 'honza/vim-snippets'")

vim.cmd("Plug 'tpope/vim-surround'")
vim.cmd("Plug 'rafaelsq/nvim-yanks.lua'")
vim.cmd("Plug 'rafaelsq/nvim-goc.lua'")

-- tmux integration
if vim.env['TMUX'] then
  vim.cmd("Plug 'christoomey/vim-tmux-navigator'")
end

vim.cmd("call plug#end()")


--------------------- Theme
vim.opt.termguicolors=true
vim.opt.number=true
vim.opt.signcolumn='yes'
vim.opt.relativenumber=false

vim.cmd('colorscheme ' .. vim.env['THEME'])

-- transparent
vim.highlight.create('Normal', {guibg='None'})
vim.highlight.create('SignColumn', {guibg='None'})
vim.highlight.create('LineNr', {guibg='None'})

if vim.g.colors_name == 'molokai' then
  vim.g.molokai_original = 1
  vim.highlight.create('MatchParen', {guibg='#3C3535', guifg='None', gui='bold'})
elseif vim.g.colors_name == 'molokai' then
  vim.g.airline_theme = 'onedark'
end


------------- highlight lua
vim.g.vimsyn_embed = 'lPr'


------------- higlight graphql
vim.cmd('autocmd BufEnter *.graphql setf graphql')


--------------------- TreeSitter
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "go", "javascript", "tsx", "json", "yaml", "html", "css", "vue", "typescript", "python" },

  highlight = { enable = true },
  incremental_selection = { enable = true },
}


--------------------- Airline
vim.g.airline_powerline_fonts = 1


--------------------- Yanks
require'nvim-yanks'.setup()
vim.api.nvim_set_keymap('n', '<Leader>y', ':lua require("nvim-yanks").Show()<CR>', {silent=true})

--------------------- GoC
vim.opt.switchbuf = 'useopen'

local goc = require'nvim-goc'
goc.setup({verticalSplit = false})

vim.api.nvim_set_keymap('n', '<Leader>gcr', ':lua require("nvim-goc").Coverage()<CR>', {silent=true})
vim.api.nvim_set_keymap('n', '<Leader>gcc', ':lua require("nvim-goc").ClearCoverage()<CR>', {silent=true})
vim.api.nvim_set_keymap('n', '<Leader>gct', ':lua require("nvim-goc").CoverageFunc()<CR>', {silent=true})
vim.api.nvim_set_keymap('n', '<Leader>gca', ':lua cf()<CR><CR>', {silent=true})
vim.api.nvim_set_keymap('n', '<Leader>gcb', ':lua cf(true)<CR><CR>', {silent=true})
vim.api.nvim_set_keymap('n', ']a', ':lua require("nvim-goc").Alternate()<CR>', {silent=true})
vim.api.nvim_set_keymap('n', '[a', ':lua require("nvim-goc").Alternate(true)<CR>', {silent=true})

_G.cf = function(testCurrentFunction)
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

--------------------- opts
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·' }
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
vim.api.nvim_set_keymap('x', 'p', '\'pgv"\'.v:register."y"', {expr = true})
vim.api.nvim_set_keymap('x', 'P', '\'Pgv"\'.v:register."y"', {expr = true})
vim.api.nvim_set_keymap('x', '<leader>y', '"+y', {})
vim.api.nvim_set_keymap('n', '<leader>p', '"+pa', {})

-- close scratch window, quickfix & Remove search highlight
vim.api.nvim_set_keymap('n', '<leader><space>', ':cclose<CR> :lclose<CR> :nohlsearch<CR> :pclose<CR>', {})

-- up and down on splitted lines
vim.api.nvim_set_keymap('', '<Up>', 'gk', {})
vim.api.nvim_set_keymap('', '<Down>', 'gj', {})
vim.api.nvim_set_keymap('', 'k', 'gk', {})
vim.api.nvim_set_keymap('', 'j', 'gj', {})

-- fix watch for vue
vim.cmd('autocmd BufEnter *.vue set backupcopy=yes')


--------------------- FZF search
vim.env.FZF_DEFAULT_COMMAND = vim.env.FZF_DEFAULT_COMMAND .. ' --ignore "*_test.go" --ignore test/mock'

vim.api.nvim_set_keymap('n', '<C-p>', ':Files<CR>', {silent=true})
vim.api.nvim_set_keymap('n', '<leader>b', ':Buffers<CR>', {})
vim.api.nvim_set_keymap('n', '<leader>f', ':BLines<CR>', {})

-- select word under cursor
vim.api.nvim_set_keymap('x', '<leader>a', '"yy:Ag <c-r>y<cr>', {})

-- search selection
vim.api.nvim_set_keymap('n', '<leader>a', ':Ag <c-r><c-w><cr>', {})


--------------------- Git Messenger
vim.api.nvim_set_keymap('n', '<Leader>m', '<Plug>(git-messenger)', {})

----------- custom
vim.api.nvim_set_keymap('n', '<leader>co', ':!git checkout %<CR><CR>', {})


--------------------- Plug
vim.api.nvim_set_keymap('n', '<leader>pu', ':PlugUpdate<CR>', {})


--------------------- Snippet
vim.g.UltiSnipsExpandTrigger = "<tab>"
vim.g.UltiSnipsJumpForwardTrigger = "<tab>"
vim.g.UltiSnipsJumpBackwardTrigger = "<s-tab>"


--------------------- utils
function _G.dump(...)
    local objects = vim.tbl_map(vim.inspect, {...})
    print(unpack(objects))
end


----------- ag ignore paths
vim.cmd[[
  augroup go_search
    autocmd!

    " Ag
    autocmd FileType go command! -bang -nargs=* Ag call fzf#vim#ag(<q-args>, '--ignore vendor --ignore \*_test.go --ignore \*generated\*', <bang>0 ? fzf#vim#with_preview('up:60%') : fzf#vim#with_preview('right:50%:hidden', '?'), <bang>0)

    " Aga
    autocmd FileType go command! -bang -nargs=* Aga call fzf#vim#ag(<q-args>, '--ignore vendor --ignore \*generated\*', <bang>0 ? fzf#vim#with_preview('up:60%') : fzf#vim#with_preview('right:50%:hidden', '?'), <bang>0)
  augroup END
]]


----------- run
vim.cmd('autocmd FileType go nmap <Leader>rg :!go run %<CR>')


--------------------- Quickfix

function _G.openQuickfix(new_split_cmd)
  local line = vim.api.nvim_win_get_cursor(0)[1]
  vim.cmd('wincmd p')
  if string.len(new_split_cmd) > 0 then
    vim.cmd(new_split_cmd)
  end
  vim.cmd(line .. 'cc')
  vim.cmd('cclose')
end

vim.cmd('autocmd FileType qf nnoremap <buffer> <C-v> :lua openQuickfix("vnew")<CR>')
vim.cmd('autocmd FileType qf nnoremap <buffer> <C-x> :lua openQuickfix("split")<CR>')
vim.cmd('autocmd FileType qf nnoremap <buffer> <CR> :lua openQuickfix("")<CR>')

-- no j/k for quickfix
vim.cmd('autocmd FileType qf map <buffer> k k')
vim.cmd('autocmd FileType qf map <buffer> j j')

-- focus
-- vim.api.nvim_set_keymap('n', '<leader>q', ':copen<CR>', {})


--------------------- Tmux integration
-- use alt+<dir> to navigate between windows
if vim.env['TMUX'] then
  vim.g.tmux_navigator_no_mappings = 1

  vim.api.nvim_set_keymap('n', '<A-h>', ':TmuxNavigateLeft<cr>', {silent=true})
  vim.api.nvim_set_keymap('n', '<A-j>', ':TmuxNavigateDown<cr>', {silent=true})
  vim.api.nvim_set_keymap('n', '<A-k>', ':TmuxNavigateUp<cr>', {silent=true})
  vim.api.nvim_set_keymap('n', '<A-l>', ':TmuxNavigateRight<cr>', {silent=true})
else
  vim.api.nvim_set_keymap('', '<A-h>', '<C-w>h', {})
  vim.api.nvim_set_keymap('', '<A-j>', '<C-w>j', {})
  vim.api.nvim_set_keymap('', '<A-k>', '<C-w>k', {})
  vim.api.nvim_set_keymap('', '<A-l>', '<C-w>l', {})
end


--------------------- Debug
-- vim.g.lsp_log_verbose = 1
-- vim.g.lsp_log_file = expand('~/vim-lsp.log')
-- vim.g.asyncomplete_log_file = expand('~/asyncomplete.log')

--------------------- LSP

local lsp = require'lspconfig'

-- https://github.com/neovim/nvim-lspconfig/issues/115
function org_imports(wait_ms)
  local params = vim.lsp.util.make_range_params()
  params.context = {only = {"source.organizeImports"}}
  local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, wait_ms)
  for _, res in pairs(result or {}) do
    for _, r in pairs(res.result or {}) do
      if r.edit then
        vim.lsp.util.apply_workspace_edit(r.edit)
      else
        vim.lsp.buf.execute_command(r.command)
      end
    end
  end
end

-- Use an on_attach function to only map the following keys 
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- use project root_dir
  vim.api.nvim_set_current_dir(client.config.root_dir)

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local opts = { noremap=true, silent=true }
  buf_set_keymap('n', 'dv', '<C-w>v <cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'dh', '<C-w>s <cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', '<c-]>', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<c-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<leader>gs', '<cmd>lua vim.lsp.buf.document_symbol()<CR>', opts)
  buf_set_keymap('n', '<leader>gf', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
  buf_set_keymap('v', '<leader>gf', '<cmd>lua vim.lsp.buf.range_formatting()<CR>', opts)
  buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<leader>gW', '<cmd>lua vim.lsp.buf.workspace_symbol()<CR>', opts)
  buf_set_keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('x', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('i', '<C-c>', '<ESC><cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', '<leader>sh', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<leader>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '<leader>g', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap('n', '[g', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']g', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)

  if client.resolved_capabilities.code_lens then
    buf_set_keymap('n', '<leader>cl', '<cmd>lua vim.lsp.codelens.run()<CR>', opts)

    vim.api.nvim_exec([[
      augroup lsp_code_lens
        autocmd!
        autocmd CursorHold,CursorHoldI,InsertLeave <buffer> lua vim.lsp.codelens.refresh()
      augroup END
    ]], false)
  end
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = {
    'documentation',
    'detail',
    'additionalTextEdits',
  }
}

local servers = { 'tsserver', 'pyright', 'html', 'vuels', 'yamlls', 'dockerls', 'jsonls', 'vimls' }
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
  flags = {
    debounce_text_changes = 150,
  },
  init_options = {
    analyses = {
      unusedparams = true,
    },
    codelenses = {
      gc_details = true,
      test = true,
    },
  },
}

vim.cmd([[
  augroup lsp_format
    autocmd!
    autocmd BufWritePre *.go lua vim.lsp.buf.formatting_sync()
  augroup END
]])

vim.cmd([[
  augroup lsp_orgimports
    autocmd!
    autocmd BufWritePre *.go lua org_imports(1000)
  augroup END
]])

-- Fzf-lsp
local fzf_lsp = require'fzf_lsp'

local bk = {
  fn = function() end,
  p = {},
}

function _G.again()
  bk.fn(bk.p.err, bk.p.method, bk.p.result, bk.p.client_id, bk.p.bufnr)
end

vim.api.nvim_set_keymap('n', '<leader>q', ':lua again()<CR>', {})

local function filter(fn)
  return (function(...)
    return (function(err, method, result, client_id, bufnr)
      if vim.tbl_islist(result) then
        result = vim.tbl_filter(function(v) return string.find(v.uri, "_test.go") == nil and string.find(v.uri, "mock") == nil end, result)
      end

      -- backup last
      bk = {
        fn = fn,
        p = {
          err = err,
          method = method,
          result = result,
          client_id = client_id,
          bufnr = bufnr,
        }
      }

      fn(err, method, result, client_id, bufnr)
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


------------ hi
vim.highlight.create('LspDiagnosticsDefaultError', {guifg='#D8DEE9', guibg='#BF616A'})
vim.highlight.create('LspDiagnosticsDefaultWarning', {guifg='#EBCB8B'})
vim.highlight.create('LspDiagnosticsDefaultInformation', {guifg='#88C0D0'})
vim.highlight.create('LspCodeLens', {guifg='#88C0D0', gui='underline'})


------------ completion
vim.cmd("autocmd BufEnter * lua require'completion'.on_attach()")

vim.opt.completeopt = {'menuone', 'noinsert', 'noselect'}

-- avoid showing message extra message when using completion
vim.opt.shortmess = vim.opt.shortmess + 'c'
vim.g.completion_enable_auto_close_brace = 1
vim.g.completion_enable_auto_paren = 1
vim.g.completion_enable_snippet = 'UltiSnips'
vim.g.completion_confirm_key = "<C-y>"
vim.g.completion_sorting = "none"


vim.api.nvim_set_keymap('i', '<c-space>', '<Plug>(completion_trigger)', {silent=true})
