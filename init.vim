" =================== Plugins
" https://github.com/junegunn/vim-plug
call plug#begin('~/.config/nvim/plugged')
 " Plug 'ctrlpvim/ctrlp.vim'
 Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
 Plug 'junegunn/fzf.vim'

 " ident
 Plug 'tpope/vim-sleuth'

 " LSP
 Plug 'prabirshrestha/vim-lsp'
 Plug 'prabirshrestha/asyncomplete.vim'
 Plug 'prabirshrestha/asyncomplete-lsp.vim'
 Plug 'mattn/vim-lsp-settings'

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
 "Plug 'honza/vim-snippets' " https://github.com/honza/vim-snippets/tree/master/snippets
  " vim-lsp
  Plug 'prabirshrestha/async.vim'
  Plug 'thomasfaingnaert/vim-lsp-snippets'
  Plug 'thomasfaingnaert/vim-lsp-ultisnips'

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
  ensure_installed = { "go", "javascript", "tsx", "json", "yaml", "html", "css", "vue", "typescript" },

  highlight = { enable = true },
  incremental_selection = { enable = true },
}
EOF


" =================== Airline
let g:airline_powerline_fonts = 1


" =================== settings

" disable match parans
let g:loaded_matchparen=1

"set list listchars=tab:»\ ,trail:·
set list listchars=tab:\ \ ,trail:·
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

autocmd FileType go command! -bang -nargs=* Ag call fzf#vim#ag(<q-args>, '--ignore vendor --ignore \*_test.go --ignore \*generated\*', <bang>0 ? fzf#vim#with_preview('up:60%') : fzf#vim#with_preview('right:50%:hidden', '?'), <bang>0)

" =================== Open on GitHub
nnoremap <leader>og <ESC>:!xdg-open `git url`/blob/`git rev-parse --abbrev-ref HEAD`/%\#L<C-R>=line(".")<CR><CR><CR>
vnoremap <leader>og <ESC>:!xdg-open `git url`/blob/`git rev-parse --abbrev-ref HEAD`/%\#L<C-R>=line("'<")<CR>-L<C-R>=line("'>")<CR><CR><CR>


" =================== Git Messenger
nmap <Leader>m <Plug>(git-messenger)
nmap <Leader>rg :!go run %<CR>


" =================== Plug
nnoremap <leader>pu :PlugUpdate<CR>


" =================== Snippet
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"


" =================== Go Coverage
nmap <Leader>gc :!export ROOT_DIR=${PWD}; go test `ls vendor 2>/dev/null >&2 && echo -mod=vendor` -coverprofile=../.cover %:p:h && go tool cover -html=../.cover -o ../coverage.html<CR>
nmap <Leader>ogc :!xdg-open ../coverage.html<CR><CR>


" =================== LSP
" ========== map
nnoremap <silent> <Leader>dv <C-w>v :LspDefinition<CR>
nnoremap <silent> <Leader>dh <C-w>s :LspDefinition<CR>
nnoremap <silent> gd :LspDefinition<CR>
nnoremap <silent> gr :LspReferences<CR>
nnoremap <silent> gi :LspImplementation<CR>
nnoremap <silent> gD :LspTypeDefinition<CR>
nnoremap <silent> <leader>rn :LspRename<CR>
nnoremap <silent> [g :LspPreviousDiagnostic<CR>
nnoremap <silent> ]g :LspNextDiagnostic<CR>
nnoremap <silent> K :LspHover<CR>

nnoremap <silent> <leader>gs :<C-u>LspDocumentSymbol<CR>
nnoremap <silent> <leader>gS :<C-u>LspWorkspaceSymbol<CR>
nnoremap <silent> <leader>gf :<C-u>LspDocumentFormat<CR>
vnoremap <silent> <leader>gf :LspDocumentRangeFormat<CR>
nnoremap <silent> <leader>ca :LspCodeAction<CR>
xnoremap <silent> <leader>ca :LspCodeAction<CR>
nnoremap <silent> <leader>cl :LspCodeLens<CR>

" ========== settings
let g:lsp_settings = {
\  'gopls': {
\    'codeLenses': {
\      'test': 1,
\     }
\   }
\}

" ========== hi
let g:lsp_signs_enabled = 0
let g:lsp_diagnostics_echo_cursor = 1

hi link LspHintText    SpecialComment
hi LspInformationText  guifg=#414E68
hi link LspWarningText Todo
hi LspErrorText        guifg=#D8DEE9 guibg=#BF616A
hi LspWarningHighlight guifg=none guibg=#414E68
hi LspErrorHighlight   gui=underline


" ========== completion
set completeopt=menuone,noinsert,noselect,preview
imap <c-space> <Plug>(asyncomplete_force_refresh)


" ========== on.save
autocmd BufWritePre *.go :LspDocumentFormatSync
autocmd BufWritePre *.go call execute('LspCodeActionSync source.organizeImports')


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
