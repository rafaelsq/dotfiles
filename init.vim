let g:go_version_warning = 0

set list listchars=tab:»\ ,trail:·,nbsp:·
set tabstop=4 shiftwidth=4
set so=5                   " padding on j/k
set noswapfile             " Don't use swapfile
set nobackup               " Don't create annoying backup files
set nowritebackup
set wildmode=list:longest  " no tab cicly
set inccommand=split
set incsearch
set mouse=a

" au FileType qf wincmd J                             " quickfix at bottom
au FileType go nmap <Leader>rn <Plug>(go-rename)
au FileType go nmap <Leader>dh <Plug>(go-def-split)
au FileType go nmap <Leader>dv <Plug>(go-def-vertical)
au FileType go nmap <Leader>dt <Plug>(go-def-tab)
au FileType go nmap <Leader>gr <Plug>(go-referrers)
au FileType javascript nmap <C-]> :TernDef<CR>

" close scratch window, quickfix & Remove search highlight
nnoremap <leader><space> :cclose<CR> :lclose<CR> :nohlsearch<CR> :pclose<CR>
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
" Just go out in insert mode
imap jj <ESC>l

" move line up & down
nnoremap <C-j> :m +1<CR>=
nnoremap <C-k> :m -2<CR>=

" Plugins
"  PluginManager
"   https://github.com/junegunn/vim-plug
call plug#begin('~/.config/nvim/plugged')

" Plug 'ctrlpvim/ctrlp.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

"" Gist
"Plug 'mattn/webapi-vim'
"Plug 'mattn/gist-vim'
Plug 'sheerun/vim-polyglot'

"Plug 'majutsushi/tagbar'

" GO
Plug 'fatih/vim-go'

" autocomplete
Plug 'Shougo/deoplete.nvim'
Plug 'zchee/deoplete-go', { 'do': 'make'}

" ident
Plug 'ldx/vim-indentfinder'

" TypeScript
 " go to definition, etc
  "Plug 'runoshun/tscompletejob'
  "Plug 'ternjs/tern_for_vim', { 'do': 'npm install && npm install -g tern' }
 " async lib
  Plug 'Shougo/vimproc.vim', { 'do': 'make' }
 " client for TSServer
  Plug 'Quramy/tsuquyomi', { 'do': 'npm install -g typescript' }
 " native language; know things; super slow
  "Plug 'mhartington/nvim-typescript', { 'do': './install.sh' }

" Autocompletion
Plug 'w0rp/ale'

" Others
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
"Plug 'scrooloose/nerdtree', { 'on': ['NERDTreeToggle', 'NERDTreeFind'] }
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'flazz/vim-colorschemes'
Plug 'tpope/vim-surround'
" Plug 'jiangmiao/auto-pairs'

" Git
Plug 'airblade/vim-gitgutter'

call plug#end()

colorscheme molokai_dark   " colorscheme

" bg transparent
hi Normal guibg=NONE ctermbg=None

" airline
 "let g:airline_section_a=''
 let g:airline_theme='bubblegum'

" ale
 let g:ale_fixers = {
 \   'javascript': ['prettier', 'eslint', 'prettier-eslint'],
 \   'typescript': ['prettier', 'tslint'],
 \}

 " Set this setting in vimrc if you want to fix files automatically on save.
 " This is off by default.
 let g:ale_fix_on_save = 1
 "let g:ale_javascript_prettier_eslint_options = '--single-quote --trailing-comma es6 --no-semi'
 let g:ale_lint_on_text_changed = "normal"
 " navigate between errors
 "nmap <silent> <C-k> <Plug>(ale_previous_wrap)
 "nmap <silent> <C-j> <Plug>(ale_next_wrap)

nmap <F6> :TagbarToggle<CR>
nmap <F5> :NERDTreeToggle<CR>

" deoplete-go
 let g:deoplete#enable_at_startup = 1

 " fix conflict with tab below
 let g:UltiSnipsExpandTrigger = "<tab>"
 let g:UltiSnipsJumpForwardTrigger = "<tab>"
 let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"

" Git vim-gitgutter
 set updatetime=250

" FZF
 let $FZF_DEFAULT_COMMAND = 'ag -l -g "" --ignore-dir=vendor'

 command! -nargs=* CodeRef call fzf#vim#ag(<q-args>)

" vim-go
 let g:go_fmt_command = "goimports"
 let g:go_def_mode = 'godef'
 let g:go_list_type = 'quickfixe'

 let g:go_highlight_functions = 1
 let g:go_highlight_methods = 1
 let g:go_highlight_fields = 1
 let g:go_highlight_types = 1
 let g:go_highlight_operators = 1
 let g:go_highlight_build_constraints = 1
 let g:go_highlight_extra_types = 1
 let g:go_highlight_generate_tags = 1

 " https://stackoverflow.com/questions/290465/how-to-paste-over-without-overwriting-register
 " I haven't found how to hide this function (yet)
"function! RestoreRegister()
"  let @" = s:restore_reg
"  return ''
"endfunction
"
"function! s:Repl()
"    let s:restore_reg = @"
"    return "p@=RestoreRegister()\<cr>"
"endfunction
"
"" NB: this supports "rp that replaces the selection by the contents of @r
"vnoremap <silent> <expr> p <sid>Repl()
