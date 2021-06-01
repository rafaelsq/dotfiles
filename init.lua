-- Basic
-- :map j gg
-- :map Q j      (will be mapped to gg)
-- :noremap W j  (will be mapped to j)(re ~ recursive_mapping)
--
-- :lua dump(obj)


--------------------- Plugins
-- https://github.com/junegunn/vim-plug
vim.cmd('call plug#begin()')

-- Search
vim.cmd("Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }")
vim.cmd("Plug 'junegunn/fzf.vim'")

-- ident
vim.cmd("Plug 'tpope/vim-sleuth'")

-- Lsp
vim.cmd("Plug 'neovim/nvim-lspconfig'")
vim.cmd("Plug 'nvim-lua/completion-nvim'")
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


--------------------- Go

function _G.alternateGo(split)
  local path, file, ext = string.match(vim.api.nvim_buf_get_name(0), "(.+/)([^.]+)%.(.+)$")
  if ext == "go" then
    local aux = '_test.'
    if string.find(file, '_test') then
      aux = '.'
      path, file, ext = string.match(vim.api.nvim_buf_get_name(0), "(.+/)([^.]+)_test%.(.+)$")
    end

    local cmd = split == 1 and ':sp ' or ':e '
    print(cmd .. path .. file .. aux .. ext)
    vim.cmd(cmd .. path .. file .. aux .. ext)
  end
end

----------- alternate
vim.cmd('autocmd FileType go nnoremap <silent> ]a :lua alternateGo(0)<CR>')
vim.cmd('autocmd FileType go nnoremap <silent> [a :lua alternateGo(1)<CR>')

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

----------- coverage
vim.cmd([[nmap <Leader>gc :!export ROOT_DIR=${PWD}; go test `ls vendor 2>/dev/null >&2 && echo -mod=vendor` -coverprofile=../.cover %:p:h && go tool cover -html=../.cover -o ../coverage.html<CR>]])
vim.cmd([[nmap <Leader>ogc :!xdg-open ../coverage.html<CR><CR>]])


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
vim.api.nvim_set_keymap('n', '<leader>q', ':copen<CR>', {})


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

-- https://go.googlesource.com/tools/+/refs/heads/master/gopls/doc/settings.md
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

-- https://github.com/neovim/nvim-lspconfig/issues/115
function lsp_organize_imports()
  local context = { source = { organizeImports = true } }
  vim.validate { context = { context, "table", true } }

  local params = vim.lsp.util.make_range_params()
  params.context = context

  local method = "textDocument/codeAction"
  local timeout = 700 -- ms

  local resp = vim.lsp.buf_request_sync(0, method, params, timeout)
  if not resp then return end

  for _, client in ipairs(vim.lsp.get_active_clients()) do
    if resp[client.id] then
      local result = resp[client.id].result
      if not result or not result[1] then return end

      local edit = result[1].edit
      vim.lsp.util.apply_workspace_edit(edit)
    end
  end
end

-- Use an on_attach function to only map the following keys 
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  --Enable completion triggered by <c-x><c-o>
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
  buf_set_keymap('n', '<leader>sh', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<leader>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '<leader>g', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap('n', '[g', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']g', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)

  if client.resolved_capabilities.document_formatting then
    vim.api.nvim_exec([[
      augroup lsp_format
        autocmd!
        autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()
      augroup END
    ]], false)
  end
end

local function on_attach_gopls(client, bufnr)
  on_attach(client, bufnr)

  if client.resolved_capabilities.code_action then
    vim.api.nvim_exec([[
      augroup lsp_organize_imports
        autocmd!
        autocmd BufWritePre <buffer> lua lsp_organize_imports()
      augroup END
    ]], false)
  end
end

local servers = { 'tsserver', 'pyls', 'html', 'vuels', 'yamlls', 'dockerls', 'jsonls', 'vimls' }
for _, l in ipairs(servers) do
  lsp[l].setup { on_attach = on_attach }
end

lsp.gopls.setup{
  on_attach = on_attach,
  capabilities = capabilities,
  flags = {
    allow_incremental_sync = true
  },
  init_options = {
    staticcheck = false,
    allExperiments = false,
    usePlaceholders = false,
    analyses = {
      unusedparams = true
    },
    codelenses = {
      gc_details = true,
      test = true,
      generate = true,
      regenerate_cgo = true,
      tidy = true,
      upgrade_dependency = true,
      vendor = true,
    },
  },
}

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
vim.g.completion_enable_snippet = 'UltiSnips'
vim.g.completion_confirm_key = "<C-y>"
vim.g.completion_sorting = "none"


vim.api.nvim_set_keymap('i', '<c-space>', '<Plug>(completion_trigger)', {silent=true})
