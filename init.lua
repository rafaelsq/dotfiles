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
vim.cmd("Plug 'prabirshrestha/vim-lsp'")
vim.cmd("Plug 'prabirshrestha/asyncomplete.vim'")
vim.cmd("Plug 'prabirshrestha/asyncomplete-lsp.vim'")
vim.cmd("Plug 'mattn/vim-lsp-settings'")

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
-- vim.cmd("Plug 'honza/vim-snippets'")
vim.cmd("Plug 'prabirshrestha/async.vim'")
vim.cmd("Plug 'thomasfaingnaert/vim-lsp-snippets'")
vim.cmd("Plug 'thomasfaingnaert/vim-lsp-ultisnips'")

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
------------ map
vim.api.nvim_set_keymap('n', '<Leader>dv', '<C-w>v :LspDefinition<CR>', {silent=true})
vim.api.nvim_set_keymap('n', '<Leader>dh', '<C-w>s :LspDefinition<CR>', {silent=true})
vim.api.nvim_set_keymap('n', 'gd', ':LspDefinition<CR>', {silent=true})
vim.api.nvim_set_keymap('n', 'gr', ':LspReferences<CR>', {silent=true})
vim.api.nvim_set_keymap('n', 'gi', ':LspImplementation<CR>', {silent=true})
vim.api.nvim_set_keymap('n', 'gD', ':LspTypeDefinition<CR>', {silent=true})
vim.api.nvim_set_keymap('n', '<leader>rn', ':LspRename<CR>', {silent=true})
vim.api.nvim_set_keymap('n', '[g', ':LspPreviousDiagnostic<CR>', {silent=true})
vim.api.nvim_set_keymap('n', ']g', ':LspNextDiagnostic<CR>', {silent=true})
vim.api.nvim_set_keymap('n', 'K', ':LspHover<CR>', {silent=true})

vim.api.nvim_set_keymap('n', '<leader>gs', ':<C-u>LspDocumentSymbol<CR>', {silent=true})
vim.api.nvim_set_keymap('n', '<leader>gS', ':<C-u>LspWorkspaceSymbol<CR>', {silent=true})
vim.api.nvim_set_keymap('n', '<leader>gf', ':<C-u>LspDocumentFormat<CR>', {silent=true})
vim.api.nvim_set_keymap('v', '<leader>gf', ':LspDocumentRangeFormat<CR>', {silent=true})
vim.api.nvim_set_keymap('n', '<leader>ca', ':LspCodeAction<CR>', {silent=true})
vim.api.nvim_set_keymap('x', '<leader>ca', ':LspCodeAction<CR>', {silent=true})
vim.api.nvim_set_keymap('i', '<C-c>',      '<ESC>:LspCodeAction<CR>', {silent=true})
vim.api.nvim_set_keymap('n', '<leader>cl', ':LspCodeLens<CR>', {silent=true})

------------ settings
vim.g.lsp_settings = {
  gopls = {
    initialization_options = {
      analyses = {
        unusedparams = true,
      },
      codelenses = {
        gc_details = true,
        test = true,
      }
    }
   }
}

------------ hi
vim.g.lsp_signs_enabled = 0
vim.g.lsp_diagnostics_echo_cursor = 1

vim.highlight.link('LspHintText', 'SpecialComment')
vim.highlight.create('LspInformationText', {guifg='#414E68'})
vim.highlight.link('LspWarningText', 'Todo')
vim.highlight.create('LspErrorText', {guifg='#D8DEE9', guibg='#BF616A'})
vim.highlight.create('LspWarningHighlight', {guifg='none', guibg='#414E68'})
vim.highlight.create('LspErrorHighlight', {gui='underline'})


------------ completion
vim.opt.completeopt = {'menuone', 'noinsert', 'noselect', 'preview'}
vim.api.nvim_set_keymap('i', '<c-space>', '<Plug>(asyncomplete_force_refresh)', {})


------------ on.save
vim.cmd("autocmd BufWritePre *.go :LspDocumentFormatSync")
vim.cmd("autocmd BufWritePre *.go call execute('LspCodeActionSync source.organizeImports')")
