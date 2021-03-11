" =================== Plugins
" https://github.com/junegunn/vim-plug
call plug#begin()
 " Plug 'ctrlpvim/ctrlp.vim'
 Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
 Plug 'junegunn/fzf.vim'

 " ident
 Plug 'tpope/vim-sleuth'

 " Lsp
 Plug 'neovim/nvim-lspconfig'
 Plug 'nvim-lua/completion-nvim'
  " improve completion
  Plug 'hrsh7th/vim-vsnip'
  Plug 'hrsh7th/vim-vsnip-integ'

 " status bar
 Plug 'vim-airline/vim-airline'
 Plug 'vim-airline/vim-airline-themes'

 " theme
 Plug 'nvim-treesitter/nvim-treesitter'
 Plug 'arcticicestudio/nord-vim'
 Plug 'gruvbox-community/gruvbox'
 Plug 'dracula/vim', { 'name': 'dracula' }
 Plug 'tomasr/molokai'
 Plug 'joshdick/onedark.vim'

 " Git
 Plug 'airblade/vim-gitgutter'   " \hp, \hs, \hu [c, ]c
 Plug 'rhysd/git-messenger.vim'  " \m\m; ?, o, O, d, D

 " snippets
 Plug 'SirVer/ultisnips'
 Plug 'honza/vim-snippets'

 Plug 'tpope/vim-surround'

 " tmux integration
 if exists('$TMUX')
   Plug 'christoomey/vim-tmux-navigator'
 endif

call plug#end()


" =================== Theme
set termguicolors
colorscheme $THEME

" set cursorline

set number
set signcolumn=yes
" set relativenumber

" transparent
hi Normal     guibg=None
hi SignColumn guibg=None
hi LineNr     guibg=None

if g:colors_name == 'molokai'
 let g:molokai_original = 1
 hi MatchParen guibg=#3C3535 guifg=None gui=bold
endif

if g:colors_name == 'onedark'
 let g:airline_theme='onedark'
endif


" ========== higlight
autocmd BufEnter *.graphql setf graphql

" =================== TreeSitter
lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "go", "javascript", "tsx", "json", "yaml", "html", "css", "vue", "typescript", "python" },

  highlight = { enable = true },
  incremental_selection = { enable = true },
}
EOF


" =================== Airline
let g:airline_powerline_fonts = 1


" =================== settings

" show trailing space and tabs
set list listchars=tab:»\ ,trail:·
set tabstop=4 shiftwidth=4
set so=5                        " padding on j/k
set mouse=a                     " enable mouse mode
set noswapfile                  " don't use swapfile
set ignorecase                  " search case insensitive...
set updatetime=200              " gutter, go auto type uses it
set hidden
set colorcolumn=120

" copy/pasts to clipboard
set clipboard^=unnamed
set clipboard^=unnamedplus

" prevent p/P to yank
xnoremap <expr> p 'pgv"'.v:register.'y'
xnoremap <expr> P 'Pgv"'.v:register.'y'
xnoremap <leader>y "+y
nnoremap <leader>p "+pa

" close scratch window, quickfix & Remove search highlight
nnoremap <leader><space> :cclose<CR> :lclose<CR> :nohlsearch<CR> :pclose<CR>
nnoremap <leader>b :Buffers<CR>

" up and down on splitted lines
map <Up> gk
map <Down> gj
map k gk
map j gj

" fix watch
autocmd BufEnter *.vue set backupcopy=yes


" =================== FZF search
nnoremap <silent> <C-p> :FZF<CR>

" select word under cursor
xmap <leader>a "yy:Ag <c-r>y<cr>

" search selection
nmap <leader>a :Ag <c-r><c-w><cr>

" ignore vendor and test files for :Ag
command! -bang -nargs=* Aga call fzf#vim#ag(<q-args>, '--ignore vendor', <bang>0 ? fzf#vim#with_preview('up:60%') : fzf#vim#with_preview('right:50%:hidden', '?'), <bang>0)
command! -bang -nargs=* Ag Aga <args>

" =================== Open on GitHub
nnoremap <leader>og <ESC>:!xdg-open `git url`/blob/`git rev-parse --abbrev-ref HEAD`/%\#L<C-R>=line(".")<CR><CR><CR>
vnoremap <leader>og <ESC>:!xdg-open `git url`/blob/`git rev-parse --abbrev-ref HEAD`/%\#L<C-R>=line("'<")<CR>-L<C-R>=line("'>")<CR><CR><CR>


" =================== Git Messenger
nmap <Leader>m <Plug>(git-messenger)

" ========= custom
nmap <leader>co :!git checkout %<CR><CR>


" =================== Plug
nnoremap <leader>pu :PlugUpdate<CR>


" =================== Snippet
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"


" =================== Go
function! GoAlternate(split)
  let p = expand('%')
  let l:e = ':e '
  if a:split
    let l:e = ':sp '
  endif
  if p =~# '^\f\+_test\.go$'
    let l:f = split(p, '_test.go$')[0] . '.go'
  else
    let l:f = expand('%:r') . '_test.go'
  endif
  execute e . f
endfunction

" ========= ag ignore paths
autocmd FileType go command! -bang -nargs=* Ag call fzf#vim#ag(<q-args>, '--ignore vendor --ignore \*_test.go --ignore \*generated\*', <bang>0 ? fzf#vim#with_preview('up:60%') : fzf#vim#with_preview('right:50%:hidden', '?'), <bang>0)

" ========= run
autocmd FileType go nmap <Leader>rg :!go run %<CR>

" ========= alternate
autocmd FileType go nnoremap <silent> ]a <cmd>call GoAlternate(0)<CR>
autocmd FileType go nnoremap <silent> [a <cmd>call GoAlternate(1)<CR>

" ========= coverage
nmap <Leader>gc :!export ROOT_DIR=${PWD}; go test `ls vendor 2>/dev/null >&2 && echo -mod=vendor` -coverprofile=../.cover %:p:h && go tool cover -html=../.cover -o ../coverage.html<CR>
nmap <Leader>ogc :!xdg-open ../coverage.html<CR><CR>


" =================== Custom
"
" This is only availale in the quickfix window, owing to the filetype
" restriction on the autocmd (see below).
function! <SID>OpenQuickfix(new_split_cmd)
  " 1. the current line is the result idx as we are in the quickfix
  let l:qf_idx = line('.')
  " 2. jump to the previous window
  wincmd p
  if len(a:new_split_cmd) > 0
    " 3. switch to a new split (the new_split_cmd will be 'vnew' or 'split')
    execute a:new_split_cmd
  endif
  " 4. open the 'current' item of the quickfix list in the newly created buffer
  "    (the current means, the one focused before switching to the new buffer)
  execute l:qf_idx . 'cc'
endfunction

autocmd FileType qf nnoremap <buffer> <C-v> :call <SID>OpenQuickfix("vnew")<CR>
autocmd FileType qf nnoremap <buffer> <C-x> :call <SID>OpenQuickfix("split")<CR>
autocmd FileType qf nnoremap <buffer> <CR> :call <SID>OpenQuickfix("")<CR>


" =================== LSP
" highlight lua
let g:vimsyn_embed = 'lPr'

lua <<EOF
local lsp = require'lspconfig'

-- https://go.googlesource.com/tools/+/refs/heads/master/gopls/doc/settings.md
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

lsp.gopls.setup{
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
lsp.tsserver.setup{}
lsp.pyls.setup{}
lsp.html.setup{}
lsp.vuels.setup{}
lsp.yamlls.setup{}
lsp.dockerls.setup{}
lsp.jsonls.setup{}
lsp.vimls.setup{}

-- autocmd
vim.api.nvim_command [[au InsertLeave *.go,*.vue,*.js,*.py,*.html :lua vim.lsp.codelens.refresh()]]
EOF

" ========== hi
hi LspDiagnosticsDefaultError       guifg=#D8DEE9 guibg=#BF616A
hi LspDiagnosticsDefaultWarning     guifg=#EBCB8B
hi LspDiagnosticsDefaultInformation guifg=#88C0D0
hi LspCodeLens                      guifg=#88C0D0 gui=underline


" ========== map
nnoremap <silent> dv <C-w>v  <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> dh <C-w>s  <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> <c-]>      <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> gd         <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> K          <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gi         <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <c-k>      <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> gD         <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gr         <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> <leader>gs <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> <leader>gf <cmd>lua vim.lsp.buf.formatting()<CR>
nnoremap <silent> <leader>rn <cmd>lua vim.lsp.buf.rename()<CR>
nnoremap <silent> <leader>gW <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
nnoremap <silent> <leader>ca <cmd>lua vim.lsp.buf.code_action()<CR>
xnoremap <silent> <leader>ca <cmd>lua vim.lsp.buf.code_action()<CR>
nnoremap <silent> [g         <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>
nnoremap <silent> ]g         <cmd>lua vim.lsp.diagnostic.goto_next()<CR>
nnoremap <silent> <leader>ll <cmd>lua print(vim.inspect(vim.lsp.codelens.get(vim.api.nvim_get_current_buf())))<CR>
nnoremap <silent> <leader>cr <cmd>lua vim.lsp.codelens.refresh()<CR>
nnoremap <silent> <leader>cl <cmd>lua print(vim.lsp.codelens.run())<CR>
nnoremap <silent> gcli <cmd>lua print(vim.inspect(vim.lsp.buf_get_clients()))<CR>


" ========== completion
autocmd BufEnter * lua require'completion'.on_attach()

" Set completeopt to have a better completion experience
set completeopt=menuone,noinsert,noselect

" Avoid showing message extra message when using completion
set shortmess+=c
let g:completion_enable_snippet = 'UltiSnips'
let g:completion_confirm_key = "\<C-y>"
let g:completion_sorting = "none"

imap <silent> <c-space> <Plug>(completion_trigger)


" ====== omnifunc(ctrl+x ctrl+o)
"autocmd Filetype go,javascript,typescript,python,html,vue,yaml,dockerfile,json,vim setlocal omnifunc=v:lua.vim.lsp.omnifunc
"let g:deoplete#enable_at_startup = 1
"inoremap <C-Space> <C-x><C-o>


" ========== on.save
autocmd BufWritePre *.go lua vim.lsp.buf.formatting_sync(nil, 1000)
"autocmd BufWritePre <buffer> call execute('LspCodeActionSync source.organizeImports')
"autocmd BufWritePre *.go lua vim.lsp.buf.code_action({ source = { organizeImports = true } })


" =================== Tmux integration
" use alt+<dir> to navigate between windows
if exists('$TMUX')
  let g:tmux_navigator_no_mappings = 1

  nnoremap <silent> <A-h> :TmuxNavigateLeft<cr>
  nnoremap <silent> <A-j> :TmuxNavigateDown<cr>
  nnoremap <silent> <A-k> :TmuxNavigateUp<cr>
  nnoremap <silent> <A-l> :TmuxNavigateRight<cr>
else
  map <A-h> <C-w>h
  map <A-j> <C-w>j
  map <A-k> <C-w>k
  map <A-l> <C-w>l
endif

"let g:lsp_log_verbose = 1
"let g:lsp_log_file = expand('~/vim-lsp.log')
"let g:asyncomplete_log_file = expand('~/asyncomplete.log')
