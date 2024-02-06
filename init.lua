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
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({"git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath})
end
vim.opt.rtp:prepend(lazypath)

local c = require('cfg')

local plugins = {
  ---- Search
  {
    'junegunn/fzf.vim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'gfanto/fzf-lsp.nvim',
      {name = 'fzf', 'junegunn/fzf', build = './install --all' },
    },
    config = c.fzf,
  },

  -- ident
  'tpope/vim-sleuth',

  -- Lsp
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'onsails/lspkind-nvim',
      'jose-elias-alvarez/null-ls.nvim',
      'nvim-lua/lsp-status.nvim',
    },
    config = c.lsp,
  },

  {
    'ray-x/lsp_signature.nvim',
    config = c.signature,
  },

  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'SirVer/ultisnips',
      'quangnguyen30192/cmp-nvim-ultisnips',
    },
    config = c.cmp,
  },

  -- status bar
  {
    'nvim-lualine/lualine.nvim',
    dependencies = {'kyazdani42/nvim-web-devicons', lazy=true},
    config = c.statusBar,
  },

  -- Go
  { 'rafaelsq/nvim-goc.lua', config = c.goC },

  -- theme
  {
    'nvim-treesitter/nvim-treesitter',

    dependencies = {
      'levouh/tint.nvim',
      'arcticicestudio/nord-vim',
      'gruvbox-community/gruvbox',
      'tomasr/molokai',
      'joshdick/onedark.vim',
      'ayu-theme/ayu-vim',
      { 'dracula/vim', name = 'dracula' },
      { 'rose-pine/neovim', name = 'rose-pine' },
      { "catppuccin/nvim", as = "catppuccin" },
    },
    config = c.theme,
  },

  -- Git
  {'rhysd/git-messenger.vim'},
  {
    'airblade/vim-gitgutter',
    config = c.git
  },

  'tpope/vim-surround',
  { 'rafaelsq/nvim-yanks.lua', config = c.yanks },

  -- using packer.nvim
  {
    'akinsho/bufferline.nvim',
    config = c.tabbar,
    dependencies = { 'kyazdani42/nvim-web-devicons' }
  },

  -- scrollbar
  { 'petertriho/nvim-scrollbar', config = c.scrollbar },

  -- search
  { 'kevinhwang91/nvim-hlslens', config = c.search },

  {
    'nvim-tree/nvim-tree.lua',
    config = c.tree,
    tag = 'nightly'
  },
}

if vim.env['TMUX'] then
  table.insert(plugins, { 'christoomey/vim-tmux-navigator', config = c.tmux })
elseif vim.env['KITTY_PID'] then
  table.insert(plugins, { 'knubie/vim-kitty-navigator', config = c.kitty, build = 'cp ./*.py ~/.config/kitty/' })
else
  vim.keymap.set('', '<A-h>', '<C-w>h', {})
  vim.keymap.set('', '<A-j>', '<C-w>j', {})
  vim.keymap.set('', '<A-k>', '<C-w>k', {})
  vim.keymap.set('', '<A-l>', '<C-w>l', {})
end

require("lazy").setup(plugins)


--------------------- opts
vim.opt.list = true
vim.opt.listchars = { tab = '┆ ', trail = ' ' }
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.scrolloff = 5
vim.opt.mouse = 'a'
vim.opt.ignorecase = true
vim.opt.updatetime = 200
vim.opt.hidden = true
vim.opt.colorcolumn = '120'
vim.opt.swapfile = false

vim.opt.clipboard = { 'unnamed', 'unnamedplus' }

-- prevent p/P to yank
vim.keymap.set('x', 'p', '\'pgv"\'.v:register."y"', { expr = true })
vim.keymap.set('x', 'P', '\'Pgv"\'.v:register."y"', { expr = true })

-- prevent x to yank
vim.keymap.set('x', 'x', '\'"_x\'', { expr = true })
vim.keymap.set('n', 'x', '\'"_x\'', { expr = true })

-- close scratch window, quickfix & Remove search highlight
vim.keymap.set('n', '<space><space>', ':cclose<CR> :lclose<CR> :nohlsearch<CR> :pclose<CR>', {})

-- up and down on splitted lines
vim.keymap.set('', '<Up>', 'gk', {})
vim.keymap.set('', '<Down>', 'gj', {})
vim.keymap.set('', 'k', 'gk', {})
vim.keymap.set('', 'j', 'gj', {})

-- fix watch for parcel
vim.opt.backupcopy='no'

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

--------------------- Plug
vim.keymap.set('n', '<space>pu', ':Lazy<CR>', {})

--------------------- utils
function _G.dump(...)
  local objects = vim.tbl_map(vim.inspect, { ... })
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

--------------------- Debug
-- vim.g.lsp_log_verbose = 1
-- vim.g.lsp_log_file = expand('~/vim-lsp.log')
-- vim.g.asyncomplete_log_file = expand('~/asyncomplete.log')
