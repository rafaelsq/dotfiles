syntax on
set sts=4 ts=4 sw=4 expandtab smarttab ai smartindent
set so=5                   " padding on j/k
set noswapfile             " Don't use swapfile
set nobackup               " Don't create annoying backup files
set nowritebackup
set wildmode=list:longest  " no tab cicly
set inccommand=split
set incsearch

" au FileType qf wincmd J                             " quickfix at bottom
au FileType go nmap <Leader>rn <Plug>(go-rename)
au FileType go nmap <Leader>dh <Plug>(go-def-split)
au FileType go nmap <Leader>dv <Plug>(go-def-vertical)
au FileType go nmap <Leader>dt <Plug>(go-def-tab)
au FileType go nmap <Leader>gr <Plug>(go-referrers)
au FileType javascript nmap <C-]> :TernDef<CR>

" close quickfix
nnoremap <leader>a :cclose<CR>
" Remove search highlight
nnoremap <leader><space> :nohlsearch<CR>
" Center the screen
nnoremap <space> zz
" search on C-p
nnoremap <silent> <C-p> :FZF<CR>

" FZF search term
nnoremap <leader>a :CodeRef<space>
xmap <leader>a "yy:<C-u>CodeRef <c-r>y<CR>

" up and down on splitted lines
map <Up> gk
map <Down> gj
map k gk
map j gj
" Just go out in insert mode
imap jk <ESC>l
" prevent p to yank
vnoremap p "_dP

"inoremap <silent><expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
"inoremap <silent><expr><S-TAB> pumvisible() ? "\<C-p>" : "\<S-TAB>"
"inoremap <silent><expr><ENTER> pumvisible() ? deoplete#mappings#close_popup() : "\<ENTER>"


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
Plug 'majutsushi/tagbar'
" GO
Plug 'fatih/vim-go'

Plug 'Shougo/deoplete.nvim'
Plug 'zchee/deoplete-go', { 'do': 'make'}

" PY
Plug 'klen/python-mode'

" JS
" Plug 'pangloss/vim-javascript'
" Plug 'ternjs/tern_for_vim', { 'do': 'yarn' }
"
" " TypeScript
 Plug 'Quramy/tsuquyomi', { 'for': 'typescript', 'do': 'npm install' } " extended typescript support - works as a client for TSServer
 Plug 'leafgarland/typescript-vim', { 'for': 'typescript' } " typescript support
 Plug 'Shougo/vimproc.vim', { 'do': 'make' } " interactive command execution in vim
"
" " React
" Plug 'mxw/vim-jsx'
"
" " Vue
" Plug 'posva/vim-vue'
" Plug 'digitaltoad/vim-pug'
" Plug 'othree/html5.vim'

" Others
Plug 'w0rp/ale'
"Plug 'neomake/neomake'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
""Plug 'scrooloose/nerdtree', { 'on': ['NERDTreeToggle', 'NERDTreeFind'] }
Plug 'vim-airline/vim-airline'
Plug 'flazz/vim-colorschemes'

" Git
Plug 'airblade/vim-gitgutter'

call plug#end()

colorscheme molokai_dark   " colorscheme

"autocmd! BufWritePost *.js,*.jsx Neomake
"autocmd! BufWritePost *.ts,*.tsx Neomake
"autocmd! BufWritePost *.vue Neomake

"au BufRead,BufNewFile *.qtpl set filetype=html
"au BufRead,BufNewFile *.vue set filetype=vue

nmap <F6> :TagbarToggle<CR>

" deoplete-go
 let g:deoplete#enable_at_startup = 1
 " no func preview on autocomplete
 "set completeopt-=preview

 " autoselect first
 "set completeopt+=noinsert

 " fix conflict with tab below
 let g:UltiSnipsExpandTrigger = "<tab>"
 let g:UltiSnipsJumpForwardTrigger = "<tab>"
 let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"

" Git vim-gitgutter
 set updatetime=250

" FZF
 let $FZF_DEFAULT_COMMAND = 'ag -l -g "" --ignore-dir=vendor'

 command! -nargs=* CodeRef call fzf#vim#ag(<q-args>)

"" " Typescript
"" let g:neomake_typescript_tsc_maker = {
""     \ 'args': ['-m', 'commonjs', '--noEmit' ],
""     \ 'append_file': 0,
""     \ 'errorformat':
""         \ '%E%f %#(%l\,%c): error %m,' .
""         \ '%E%f %#(%l\,%c): %m,' .
""         \ '%Eerror %m,' .
""         \ '%C%\s%\+%m'
""         \ }
"" "let g:tsuquyomi_disable_default_mappings = 1
"" "let g:tsuquyomi_completion_detail = 1
""
"" " eslint
""  let g:neomake_open_list = 2
""
""  let g:neomake_vue_enabled_makers = ['eslint']
""  let g:neomake_vue_eslint_exe = system('PATH=$(npm bin):$PATH && which eslint | tr -d "\n"')
""
""  let g:neomake_javascript_enabled_makers = ['eslint']
""  let g:neomake_javascript_eslint_exe = system('PATH=$(npm bin):$PATH && which eslint | tr -d "\n"')
""
""  let g:neomake_typescript_enabled_makers = ['tslint']
""  let g:neomake_typescript_tslint_exe = system('PATH=$(npm bin):$PATH && which tslint | tr -d "\n"')

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

"" Macros
"let @a='mb/chan \*.*errors.RepositoryError)
f)%d/chan
i(/chan
dw/chan
vt)cerror'
"let @b='ma:g/response.* := make(chan/d
`a'
"let @c='/async.Go
ma$%V$%d`add'
"let @d='ma/cerr
mm^*NV:perldo s,c?([a-z0-9]+),$1,g
nT 3x`m/if err := <-cerr;
dt{d%`a'
"let @e='ma/response <- 
vf-lcreturn $a, err/return respo
dd`a'
"let @f='ma/close(responseErr)
dd`a'
"
"let @g='/errors\.ConvertToRepositoryError(err.*); e != nil
f{V%cif err != nil {
return nil, err
}'
"
"let @i='ma:g/ctx.Log()/d
`a'
"let @j='ma:g/log\.IfError/d
`a'
"
"let @x='@a@b@c@e'
"
"let @n='@f@ggg100@hgg20@y'
""let @a='@b@c@d@e'
""
"" let @k='nma$%kkk"+Pjjjjjjdd`add'
""
""
