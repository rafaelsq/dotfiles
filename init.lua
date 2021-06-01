-- Basic
-- :map j gg
-- :map Q j      (will be mapped to gg)
-- :noremap W j  (will be mapped to j)(re ~ recursive_mapping)
--
-- :lua dumps(obj)


--------------------- Plugins
require('packer').startup(function()
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- Plug 'ctrlpvim/ctrlp.vim'
  use {'junegunn/fzf', dir = '~/.fzf', run = './install --all'}
  use {'junegunn/fzf.vim'}

  -- ident
  use {'tpope/vim-sleuth'}

  -- Lsp
  use {'prabirshrestha/vim-lsp'}
  use {'prabirshrestha/asyncomplete.vim'}
  use {'prabirshrestha/asyncomplete-lsp.vim'}
  use {'mattn/vim-lsp-settings'}

  -- status bar
  use {'vim-airline/vim-airline'}
  use {'vim-airline/vim-airline-themes'}

  -- theme
  use {'nvim-treesitter/nvim-treesitter'}
  use {'arcticicestudio/nord-vim'}
  use {'gruvbox-community/gruvbox'}
  use {'dracula/vim', name = 'dracula'}
  use {'tomasr/molokai'}
  use {'joshdick/onedark.vim'}

  -- Git
  use {'airblade/vim-gitgutter'}   -- \hp, \hs, \hu [c, ]c
  use {'rhysd/git-messenger.vim'}  -- \m\m; ?, o, O, d, D

  -- snippets
  use {'SirVer/ultisnips'}
  -- use {'honza/vim-snippets'}
  use {'prabirshrestha/async.vim'}
  use {'thomasfaingnaert/vim-lsp-snippets'}
  use {'thomasfaingnaert/vim-lsp-ultisnips'}

  use {'tpope/vim-surround'}

  -- tmux integration
  if vim.env['TMUX'] then
    use {'christoomey/vim-tmux-navigator'}
  end
end)


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

vim.opt.clipboard = { 'unnamed', 'unnamedplus' }

-- prevent p/P to yank
vim.api.nvim_set_keymap('x', 'p', '\'pgv"\'.v:register."y"', {expr = true})
vim.api.nvim_set_keymap('x', 'P', '\'Pgv"\'.v:register."y"', {expr = true})
vim.api.nvim_set_keymap('x', '<leader>y', '"+y', {})
vim.api.nvim_set_keymap('n', '<leader>p', '"+pa', {})

-- close scratch window, quickfix & Remove search highlight
vim.api.nvim_set_keymap('n', '<leader><space>', ':cclose<CR> :lclose<CR> :nohlsearch<CR> :pclose<CR>', {})
vim.api.nvim_set_keymap('n', '<leader>b', ':Buffers<CR>', {})

-- up and down on splitted lines
vim.api.nvim_set_keymap('', '<Up>', 'gk', {})
vim.api.nvim_set_keymap('', '<Down>', 'gj', {})
vim.api.nvim_set_keymap('', 'k', 'gk', {})
vim.api.nvim_set_keymap('', 'j', 'gj', {})

-- fix watch for vue
vim.cmd('autocmd BufEnter *.vue set backupcopy=yes')


--------------------- FZF search
vim.api.nvim_set_keymap('n', '<C-p>', ':FZF<CR>', {silent=true})

-- select word under cursor
vim.api.nvim_set_keymap('x', '<leader>a', '"yy:Ag <c-r>y<cr>', {})

-- search selection
vim.api.nvim_set_keymap('n', '<leader>a', ':Ag <c-r><c-w><cr>', {})

-- ignore vendor and test files for :Ag
vim.cmd("command! -bang -nargs=* Aga call fzf#vim#ag(<q-args>, '--ignore vendor', <bang>0 ? fzf#vim#with_preview('up:60%') : fzf#vim#with_preview('right:50%:hidden', '?'), <bang>0)")
vim.cmd("command! -bang -nargs=* Ag Aga <args>")


--------------------- Open on GitHub
--vim.api.nvim_set_keymap('n', '<leader>og', "<ESC>:!xdg-open `git url`/blob/`git rev-parse --abbrev-ref HEAD`/%\#L<C-R>=line(".")<CR><CR><CR>", {})
--vim.api.nvim_set_keymap('v', '<leader>og', "<ESC>:!xdg-open `git url`/blob/`git rev-parse --abbrev-ref HEAD`/%\#L<C-R>=line(\"'<\")<CR>-L<C-R>=line(\"'>\")<CR><CR><CR>", {})


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
vim.cmd("autocmd FileType go command! -bang -nargs=* Ag call fzf#vim#ag(<q-args>, '--ignore vendor --ignore *_test.go --ignore *generated*', <bang>0 ? fzf#vim#with_preview('up:60%') : fzf#vim#with_preview('right:50%:hidden', '?'), <bang>0)")

----------- run
vim.cmd('autocmd FileType go nmap <Leader>rg :!go run %<CR>')

-- " ========= coverage
-- nmap <Leader>gc :!export ROOT_DIR=${PWD}; go test `ls vendor 2>/dev/null >&2 && echo -mod=vendor` -coverprofile=../.cover %:p:h && go tool cover -html=../.cover -o ../coverage.html<CR>
-- nmap <Leader>ogc :!xdg-open ../coverage.html<CR><CR>
-- 
-- 
-- " =================== Quickfix
-- 
-- " This is only availale in the quickfix window, owing to the filetype
-- " restriction on the autocmd (see below).
-- function! <SID>OpenQuickfix(new_split_cmd)
--   " 1. the current line is the result idx as we are in the quickfix
--   let l:qf_idx = line('.')
--   " 2. jump to the previous window
--   wincmd p
--   if len(a:new_split_cmd) > 0
--     " 3. switch to a new split (the new_split_cmd will be 'vnew' or 'split')
--     execute a:new_split_cmd
--   endif
--   " 4. open the 'current' item of the quickfix list in the newly created buffer
--   "    (the current means, the one focused before switching to the new buffer)
--   execute l:qf_idx . 'cc'
-- endfunction

--vim.cmd('autocmd FileType qf nnoremap <buffer> <C-v> :call <SID>OpenQuickfix("vnew")<CR>')
--vim.cmd('autocmd FileType qf nnoremap <buffer> <C-x> :call <SID>OpenQuickfix("split")<CR>')
--vim.cmd('autocmd FileType qf nnoremap <buffer> <CR> :call <SID>OpenQuickfix("")<CR>')

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
vim.api.nvim_set_keymap('n', '<leader>cl', ':LspCodeLens<CR>', {silent=true})

------------ settings
vim.g.lsp_settings = {
  gopls = {
    codeLenses = {
      test = 1
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
