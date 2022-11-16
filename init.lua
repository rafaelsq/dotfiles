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

local c = require('cfg')

-- DON'T FORGET TO SYNC AFTER EACH CHANGE
require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  ---- Search
  use {
    'junegunn/fzf.vim',
    requires = {
      'nvim-lua/plenary.nvim',
      'gfanto/fzf-lsp.nvim',
      { 'junegunn/fzf', dir = '~/.fzf', run = './install --all' },
    },
    config = c.fzf,
  }

  -- ident
  use 'tpope/vim-sleuth'

  -- Lsp
  use {
    'neovim/nvim-lspconfig',
    requires = {
      'onsails/lspkind-nvim',
      'jose-elias-alvarez/null-ls.nvim',
      'nvim-lua/lsp-status.nvim',
    },
    config = c.lsp,
  }

  use {
    'ray-x/lsp_signature.nvim',
    config = c.signature,
  }

  use {
    'hrsh7th/nvim-cmp',
    requires = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
      'rafamadriz/friendly-snippets'
    },
    config = c.cmp,
  }

  -- status bar
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons' },
    config = c.statusBar,
  }

  -- Go
  use { 'rafaelsq/nvim-goc.lua', config = c.goC }

  -- theme
  use {
    'nvim-treesitter/nvim-treesitter',

    requires = {
      'levouh/tint.nvim',
      'arcticicestudio/nord-vim',
      'gruvbox-community/gruvbox',
      'tomasr/molokai',
      'joshdick/onedark.vim',
      'ayu-theme/ayu-vim',
      { 'dracula/vim', as = 'dracula' },
    },
    config = c.theme,
  }

  -- Git
  use { 'rhysd/git-messenger.vim' }
  use {
    'airblade/vim-gitgutter',
    config = c.git
  }

  use 'tpope/vim-surround'
  use { 'rafaelsq/nvim-yanks.lua', config = c.yanks }

  -- using packer.nvim
  use {
    'akinsho/bufferline.nvim',
    config = c.tabbar,
    requires = { 'kyazdani42/nvim-web-devicons' }
  }

  -- scrollbar
  use { 'petertriho/nvim-scrollbar', config = c.scrollbar }

  -- search
  use { 'kevinhwang91/nvim-hlslens', config = c.search }

  -- tmux integration
  if vim.env['TMUX'] then
    use { 'christoomey/vim-tmux-navigator', config = c.tmux }
  else
    vim.keymap.set('', '<A-h>', '<C-w>h', {})
    vim.keymap.set('', '<A-j>', '<C-w>j', {})
    vim.keymap.set('', '<A-k>', '<C-w>k', {})
    vim.keymap.set('', '<A-l>', '<C-w>l', {})
  end
end)

------------- highlight lua
vim.g.vimsyn_embed = 'lPr'

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

--------------------- Plug
vim.keymap.set('n', '<space>pu', ':PackerSync<CR>', {})

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
