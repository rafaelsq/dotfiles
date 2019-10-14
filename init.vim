set shellcmdflag=-ic " :!

set list listchars=tab:»\ ,trail:·
set tabstop=4 shiftwidth=4
set so=5                   " padding on j/k
set noswapfile             " Don't use swapfile
set nobackup               " Don't create annoying backup files
set nowritebackup
set wildmode=list:longest  " no tab cicly
set inccommand=split
set incsearch
set mouse=a
set completeopt=noinsert,menuone,noselect " n2mc
set shortmess+=c " n2mc

" au FileType qf wincmd J                             " quickfix at bottom
au FileType go nmap <Leader>rn <Plug>(go-rename)
au FileType go nmap <Leader>dh <Plug>(go-def-split)
au FileType go nmap <Leader>dv <Plug>(go-def-vertical)
au FileType go nmap <Leader>dt <Plug>(go-def-tab)
au FileType go nmap <Leader>gr <Plug>(go-referrers)
"au FileType javascript nmap <C-]> :TernDef<CR>
au Filetype go command! -bang A call go#alternate#Switch(<bang>0, 'edit')
au Filetype go command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
au Filetype go command! -bang AS call go#alternate#Switch(<bang>0, 'split')
au Filetype go command! -bang AT call go#alternate#Switch(<bang>0, 'tabe')"
"
nmap <Leader>m <Plug>(git-messenger)
nmap <Leader>c :GoCoverage<CR>
cab GoCoverage GoCoverage -gcflags=all=-l

" close scratch window, quickfix & Remove search highlight
nnoremap <leader><space> :cclose<CR> :lclose<CR> :nohlsearch<CR> :pclose<CR> :GoCoverageClear<CR>
" Center the screen
nnoremap <space> zz
" search on C-p
nnoremap <silent> <C-p> :FZF<CR>
map ' ^

" prevent p/P to yank
xnoremap <expr> p 'pgv"'.v:register.'y'
xnoremap <expr> P 'Pgv"'.v:register.'y'

" FZF search term
nnoremap <leader>a :CodeRef<space>
xmap <leader>a "yy:<C-u>CodeRef <c-r>y<CR>

" up and down on splitted lines
map <Up> gk
map <Down> gj
map k gk
map j gj

" annoying
cab W w

" move line up & down
nnoremap <leader>j :m +1<CR>=<CR>
nnoremap <leader>k :m -2<CR>=<CR>

inoremap <silent> <expr> <CR> ncm2_neosnippet#expand_or("\<CR>", 'n')
inoremap <silent> <expr> <CR> ncm2_ultisnips#expand_or("\<CR>", 'n')

" c-j c-k for moving in snippet
" let g:UltiSnipsExpandTrigger		= "<Plug>(ultisnips_expand)"
let g:UltiSnipsJumpForwardTrigger	= "<c-j>"
let g:UltiSnipsJumpBackwardTrigger	= "<c-k>"
let g:UltiSnipsRemoveSelectModeMappings = 0
" Plugins
"  PluginManager
"   https://github.com/junegunn/vim-plug
call plug#begin('~/.config/nvim/plugged')

" Plug 'ctrlpvim/ctrlp.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" Gist
Plug 'mattn/webapi-vim'
Plug 'mattn/gist-vim'

" GO
Plug 'fatih/vim-go' ", { 'do': ':GoUpdateBinaries' }
 " fix gocode `$ go get -u github.com/stamblerre/gocode`

" autocomplete
Plug 'ncm2/ncm2'
 " require
 Plug 'roxma/nvim-yarp'

 " plugins
 Plug 'ncm2/ncm2-bufword'
 Plug 'ncm2/ncm2-path'
 Plug 'ncm2/ncm2-syntax'
  Plug 'Shougo/neco-syntax'
 Plug 'ncm2/ncm2-neoinclude'
  Plug 'Shougo/neoinclude.vim'
 Plug 'ncm2/ncm2-go'
 Plug 'ncm2/ncm2-tern',  {'do': 'yarn'} " js
 "Plug 'ncm2/nvim-typescript', {'do': './install.sh'} " ts
  "Plug 'mhartington/nvim-typescript'
 " For async completion
  Plug 'Shougo/deoplete.nvim'
 " For Denite features
  Plug 'Shougo/denite.nvim'
 Plug 'ncm2/ncm2-neosnippet'
  Plug 'honza/vim-snippets'
  Plug 'Shougo/neosnippet.vim'
  Plug 'Shougo/neosnippet-snippets'
 Plug 'ncm2/ncm2-ultisnips'
  Plug 'SirVer/ultisnips'
 "Plug 'ncm2/float-preview.nvim'
 Plug 'ncm2/ncm2-jedi' " python
 Plug 'ncm2/ncm2-html-subscope' " html

" ident
Plug 'ldx/vim-indentfinder'

" TypeScript
 " go to definition, etc
  "Plug 'runoshun/tscompletejob'
  "Plug 'ternjs/tern_for_vim', { 'do': 'npm install && npm install -g tern' }
 " async lib
  " Plug 'Shougo/vimproc.vim', { 'do': 'make' }
 " client for TSServer
  " Plug 'Quramy/tsuquyomi', { 'do': 'npm install -g typescript' }
  " native language; know things; super slow
  "Plug 'mhartington/nvim-typescript', { 'do': './install.sh' }

" lint
Plug 'w0rp/ale'

" status bar
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" styles
Plug 'flazz/vim-colorschemes'
Plug 'sheerun/vim-polyglot'
Plug 'HerringtonDarkholme/yats.vim' " ts.syntax / ncm2

" Git
Plug 'airblade/vim-gitgutter'
Plug 'rhysd/git-messenger.vim'

" Others
"Plug 'SirVer/ultisnips'
"Plug 'scrooloose/nerdtree', { 'on': ['NERDTreeToggle', 'NERDTreeFind'] }
Plug 'tpope/vim-surround'
" Plug 'jiangmiao/auto-pairs'
"Plug 'majutsushi/tagbar'

call plug#end()

" enable ncm2 for all buffers
autocmd BufEnter * call ncm2#enable_for_buffer()

" colorscheme
colorscheme molokai_dark

" bg transparent
hi Normal guibg=NONE ctermbg=None

" airline
 "let g:airline_section_a=''
 let g:airline_theme='bubblegum'

" ale
 let g:ale_fixers = {
 \   'javascript': ['prettier', 'eslint', 'prettier-eslint'],
 \   'typescript': ['prettier', 'tslint'],
 \   'python': ['autopep8', 'yapf'],
 \}

 let g:ale_linters = {
 \   'go': ['gopls'],
 \   'py': ['flake8', 'pylint'],
 \}

 let g:ale_fix_on_save = 1
 let g:ale_lint_on_text_changed = "normal"

 " navigate between errors
 "nmap <silent> <C-k> <Plug>(ale_previous_wrap)
 "nmap <silent> <C-j> <Plug>(ale_next_wrap)

" Git vim-gitgutter
 set updatetime=250

" FZF
 let $FZF_DEFAULT_COMMAND = 'ag -l -g "" --ignore-dir=vendor --ignore-dir=node_modules'
 command! -nargs=* CodeRef call fzf#vim#ag(<q-args>)

" vim-go
 " add --ignore-dir=vendor on https://github.com/junegunn/fzf.vim/blob/master/autoload/fzf/vim.vim#L695
 let g:go_fmt_command = "goimports"
 let g:go_metalinter_command = "golangci-lint"

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
