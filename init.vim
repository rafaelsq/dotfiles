syntax on
set sts=4 ts=4 sw=4 expandtab smarttab ai smartindent
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

" close quickfix & Remove search highlight
nnoremap <leader><space> :cclose<CR> :lclose<CR> :nohlsearch<CR>
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

" autocomplete
Plug 'Shougo/deoplete.nvim'
Plug 'zchee/deoplete-go', { 'do': 'make'}

" TypeScript
 Plug 'runoshun/tscompletejob' " go to definition, etc

" Autocompletion
 Plug 'w0rp/ale'

" Others
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'scrooloose/nerdtree', { 'on': ['NERDTreeToggle', 'NERDTreeFind'] }
Plug 'vim-airline/vim-airline'
Plug 'flazz/vim-colorschemes'

" Git
Plug 'airblade/vim-gitgutter'

call plug#end()

colorscheme molokai_dark   " colorscheme

" ale
 let g:ale_lint_on_text_changed = 'never'
 let g:ale_lint_on_enter = 0

 " navigate between errors
 nmap <silent> <C-k> <Plug>(ale_previous_wrap)
 nmap <silent> <C-j> <Plug>(ale_next_wrap)

nmap <F6> :TagbarToggle<CR>

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
