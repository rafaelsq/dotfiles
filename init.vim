" Plugins
"  PluginManager
"   https://github.com/junegunn/vim-plug
call plug#begin('~/.config/nvim/plugged')

 " Plug 'ctrlpvim/ctrlp.vim'
 Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
 Plug 'junegunn/fzf.vim'

 " Go
 Plug 'fatih/vim-go' ", { 'do': ':GoUpdateBinaries' }
  " fix gocode `$ go get -u github.com/stamblerre/gocode`

 " ident
 Plug 'tpope/vim-sleuth'

 " Autocomplete
 Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

 " lint/lsp
 Plug 'dense-analysis/ale'

 " status bar
 Plug 'vim-airline/vim-airline'
 Plug 'vim-airline/vim-airline-themes'
  Plug 'tpope/vim-fugitive' " git info

 " styles
 Plug 'flazz/vim-colorschemes'
 Plug 'sheerun/vim-polyglot'

 " Git
 Plug 'airblade/vim-gitgutter'
 Plug 'rhysd/git-messenger.vim'

 " Others
 Plug 'SirVer/ultisnips'
 Plug 'honza/vim-snippets'
 Plug 'tpope/vim-surround'

call plug#end()


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

au Filetype go command! -bang A call go#alternate#Switch(<bang>0, 'edit')
au Filetype go command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
au Filetype go command! -bang AS call go#alternate#Switch(<bang>0, 'split')
au Filetype go command! -bang AT call go#alternate#Switch(<bang>0, 'tabe')"

nmap <Leader>c :GoCoverage<CR>
cab GoCoverage GoCoverage -gcflags=all=-l

" git
nmap <Leader>m <Plug>(git-messenger)

" close scratch window, quickfix & Remove search highlight
nnoremap <leader><space> :cclose<CR> :lclose<CR> :nohlsearch<CR> :pclose<CR> :GoCoverageClear<CR>

" Center the screen
nnoremap <space> zz

"map ' ^

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
nnoremap <leader>g :!o `git url`/blob/`git rev-parse --abbrev-ref HEAD`/%<CR><CR><CR>
vnoremap <leader>o <ESC>:!o `git url`/blob/`git rev-parse --abbrev-ref HEAD`/%\#L<C-R>=line("'<")<CR>-L<C-R>=line("'>")<CR><CR><CR>

" c-j c-k for moving in snippet
" let g:UltiSnipsExpandTrigger		= "<Plug>(ultisnips_expand)"
let g:UltiSnipsJumpForwardTrigger	= "<c-j>"
let g:UltiSnipsJumpBackwardTrigger	= "<c-k>"
let g:UltiSnipsRemoveSelectModeMappings = 0

" colorscheme
colorscheme molokai_dark

" bg transparent
hi Normal guibg=NONE ctermbg=None

" airline
 "let g:airline_section_a=''
 let g:airline_theme='term'
 let g:airline_powerline_fonts = 1
 let g:airline#parts#ffenc#skip_expected_string='utf-8[unix]'
 let g:airline#extensions#wordcount#format = '%d words'
 let g:airline_section_z = '%3p%% %3l/%L:%3v'
 "let g:airline_section_b = ''
 let g:airline_skip_empty_sections = 1
 let g:airline_mode_map = {
    \ '__' : '-',
    \ 'n'  : 'N',
    \ 'i'  : 'I',
    \ 'R'  : 'R',
    \ 'c'  : 'C',
    \ 'v'  : 'V',
    \ 'V'  : 'V',
    \ '' : 'V',
    \ 's'  : 'S',
    \ }
"let g:airline#extensions#branch#enabled = 1

" Ale
let g:airline#extensions#ale#enabled = 1 " enable LSP

"let g:ale_completion_enabled = 1 " use ale autocomplete
 "set omnifunc=ale#completion#OmniFunc
 "set completeopt=noinsert,menuone,noselect

" map
nmap gd :ALEGoToDefinition<CR>
nmap <Leader>dh :ALEGoToDefinitionInSplit<CR>
nmap <Leader>dv :ALEGoToDefinitionInVSplit<CR>
nmap <Leader>dt :ALEGoToDefinitionInTab<CR>
nmap <Leader>gr :ALEFindReferences<CR>
nmap <Leader>i :ALEHover<CR>

" next err
nmap <silent> <C-j> <Plug>(ale_next_wrap)

 let g:ale_fixers = {
 \   'javascript': ['prettier', 'eslint', 'prettier-eslint'],
 \   'typescript': ['prettier', 'tslint'],
 \   'typescriptreact': ['prettier', 'tslint'],
 \   'python': ['autopep8', 'yapf'],
 \   'graphql': ['prettier'],
 \   'json': ['prettier'],
 \}

 let g:ale_linters = {
 \   'go': ['gopls', 'golangci-lint'],
 \   'py': ['flake8', 'pylint'],
 \   'typescript': ['tsserver'],
 \   'typescriptreact': ['tsserver'],
 \   'javascript': ['eslint'],
 \}

 let g:ale_fix_on_save = 1
 let g:ale_lint_on_text_changed = "normal"

 " navigate between errors
 "nmap <silent> <C-k> <Plug>(ale_previous_wrap)
 "nmap <silent> <C-j> <Plug>(ale_next_wrap)

" Deoplete autocomplete
let g:deoplete#enable_at_startup = 1
call deoplete#custom#source('_', 'ale') " use ale LSP

" Git vim-gitgutter
 set updatetime=250

" FZF
 let $FZF_DEFAULT_COMMAND = 'ag -l -g "" --hidden --ignore-dir=vendor --ignore-dir=node_modules --ignore-dir=.git'
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
