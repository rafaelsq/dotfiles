" Plugins
"  PluginManager
"   https://github.com/junegunn/vim-plug
call plug#begin('~/.config/nvim/plugged')
 " Plug 'ctrlpvim/ctrlp.vim'
 Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
 Plug 'junegunn/fzf.vim'

 " ident
 " https://github.com/sheerun/vim-polyglot/issues/290#issuecomment-379810574
 "Plug 'tpope/vim-sleuth'

 " LSP
 Plug 'prabirshrestha/vim-lsp'
 Plug 'prabirshrestha/asyncomplete.vim'
 Plug 'prabirshrestha/asyncomplete-lsp.vim'
 Plug 'mattn/vim-lsp-settings'

 " status bar
 Plug 'vim-airline/vim-airline'
 Plug 'vim-airline/vim-airline-themes'

 " styles
 Plug 'flazz/vim-colorschemes'
 Plug 'sheerun/vim-polyglot'

 " Git
 Plug 'airblade/vim-gitgutter'   " \hp, \hs, \hu [c, ]c
 Plug 'rhysd/git-messenger.vim'  " \m\m; ?, o, O, d, D

 " Others
 Plug 'SirVer/ultisnips'
 Plug 'honza/vim-snippets'
  " vim-lsp
  Plug 'prabirshrestha/async.vim'
  Plug 'thomasfaingnaert/vim-lsp-snippets'
  Plug 'thomasfaingnaert/vim-lsp-ultisnips'

 Plug 'tpope/vim-surround'

 " auto set paste
 Plug 'ConradIrwin/vim-bracketed-paste'

call plug#end()

" disable match parans
let g:loaded_matchparen=1

set shellcmdflag=-ic            " :!
set list listchars=tab:»\ ,trail:·
set tabstop=4 shiftwidth=4
set so=5                        " padding on j/k
set mouse=a                     " enable mouse mode
set noswapfile                  " don't use swapfile
set ignorecase                  " search case insensitive...
set updatetime=200              " gutter, go auto type uses it

"http://stackoverflow.com/questions/20186975/vim-mac-how-to-copy-to-clipboard-without-pbcopy
set clipboard^=unnamed
set clipboard^=unnamedplus

" ~/.viminfo needs to be writable and readable. Set oldfiles to 1000 last
" recently opened files, :FzfHistory uses it
set viminfo='1000

if has('persistent_undo')
  set undofile
  set undodir=~/.cache/vim
endif

" Do not show q: window
map q: :q

" git
nmap <Leader>m <Plug>(git-messenger)
nmap <Leader>rg :!go run %<CR>

" close scratch window, quickfix & Remove search highlight
nnoremap <leader><space> :cclose<CR> :lclose<CR> :nohlsearch<CR> :pclose<CR>
"nnoremap <leader><space> :cclose<CR> :lclose<CR> :nohlsearch<CR> :pclose<CR> :GoCoverageClear<CR>

" Center the screen
nnoremap <space> zz

" prevent p/P to yank
xnoremap <expr> p 'pgv"'.v:register.'y'
xnoremap <expr> P 'Pgv"'.v:register.'y'
xnoremap <leader>y "+y
nnoremap <leader>p "+pa

" FZF search term
 " search on ctrl+p
 nnoremap <silent> <C-p> :FZF<CR>
 " select word under cursor
 xmap <leader>a "yy:Ag <c-r>y<cr>
 " search selection
 nmap <leader>a :Ag <c-r><c-w><cr>

" up and down on splitted lines
map <Up> gk
map <Down> gj
map k gk
map j gj

" annoying :W
cab W w

" keep block selection
"vmap < <gv
"vmap > >gv

" move line up & down
nnoremap <leader>j :m .+1<CR>==
nnoremap <leader>k :m .-2<CR>==
vnoremap <leader>j :m '>+1<CR>gv=gv
vnoremap <leader>k :m '<-2<CR>gv=gv

" Open current file on github
nnoremap <leader>og <ESC>:!o `git url`/blob/`git rev-parse --abbrev-ref HEAD`/%\#L<C-R>=line(".")<CR><CR><CR>
vnoremap <leader>og <ESC>:!o `git url`/blob/`git rev-parse --abbrev-ref HEAD`/%\#L<C-R>=line("'<")<CR>-L<C-R>=line("'>")<CR><CR><CR>

" c-j c-k for moving in snippet
 "let g:UltiSnipsExpandTrigger		= "<Plug>(ultisnips_expand)"
let g:UltiSnipsJumpForwardTrigger	= "<c-j>"
let g:UltiSnipsJumpBackwardTrigger	= "<c-k>"
let g:UltiSnipsRemoveSelectModeMappings = 0

" color
syntax on
set t_Co=256
set background=dark
let g:molokai_original = 1
let g:rehash256 = 1
colorscheme molokai

" line number with highlight
set number
set cursorline
set signcolumn=yes
hi clear CursorLine
hi CursorLineNR ctermfg=gray ctermbg=None ctermbg=None guibg=None

" bg and signColumn transparent
hi clear SignColumn
hi Normal guibg=None ctermbg=None
hi LineNr ctermbg=None

" airline
 let g:airline_powerline_fonts = 1

" FZF
 let $FZF_DEFAULT_COMMAND = 'ag -l -g "" --hidden --ignore-dir=vendor --ignore-dir=node_modules --ignore-dir=.git'
 command! -nargs=* CodeRef call fzf#vim#ag(<q-args>)

" polyglot golang
let g:go_highlight_debug = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_parameters = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_format_strings = 1
let g:go_highlight_methods = 1
let g:go_highlight_fields = 1
let g:go_highlight_types = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_generate_tags = 1
let g:go_highlight_space_tab_error = 1
let g:go_highlight_trailing_whitespace_error = 1

" map vim-lsp
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

nnoremap <silent> gs :<C-u>LspDocumentSymbol<CR>
nnoremap <silent> gS :<C-u>LspWorkspaceSymbol<CR>
nnoremap <silent> gQ :<C-u>LspDocumentFormat<CR>
vnoremap <silent> gQ :LspDocumentRangeFormat<CR>
nnoremap <silent> <leader>ca :LspCodeAction<CR>
xnoremap <silent> <leader>ca :LspCodeAction<CR>

imap <c-space> <Plug>(asyncomplete_force_refresh)

set completeopt=menuone,noinsert,noselect,preview

autocmd BufWritePre *.go :LspDocumentFormatSync
autocmd BufWritePre *.go call execute('LspCodeActionSync source.organizeImports')

let g:lsp_signs_enabled = 0
let g:lsp_diagnostics_echo_cursor = 1

hi LspHintText         ctermfg=darkblue
hi LspInformationText  ctermfg=blue
hi LspWarningText      ctermfg=darkyellow
hi LspErrorText        ctermfg=darkred
hi LspWarningHighlight ctermfg=none ctermbg=none
hi LspErrorHighlight   cterm=underline
