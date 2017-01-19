" no tab cicly
set wildmode=list:longest

" Plugins
"  PluginManager
"   https://github.com/junegunn/vim-plug
call plug#begin('~/.config/nvim/plugged')

" Plug 'ctrlpvim/ctrlp.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" GO
Plug 'fatih/vim-go'
Plug 'Shougo/deoplete.nvim'
Plug 'zchee/deoplete-go', { 'do': 'make'}

" JS
 Plug 'pangloss/vim-javascript'

 " TypeScript
 Plug 'Quramy/tsuquyomi', { 'for': 'typescript', 'do': 'npm install' } " extended typescript support - works as a client for TSServer
 Plug 'clausreinke/typescript-tools.vim', { 'for': 'typescript' } " typescript tools
 Plug 'leafgarland/typescript-vim', { 'for': 'typescript' } " typescript support
 Plug 'Shougo/vimproc.vim', { 'do': 'make' } " interactive command execution in vim

 " React
 Plug 'mxw/vim-jsx'

 " Vue
 Plug 'posva/vim-vue'

" Others
Plug 'neomake/neomake'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'scrooloose/nerdtree', { 'on': ['NERDTreeToggle', 'NERDTreeFind'] }
Plug 'vim-airline/vim-airline'
Plug 'flazz/vim-colorschemes'

" Git
Plug 'airblade/vim-gitgutter'

call plug#end()

" make quickfix windows take all the lower section of the screen
" when there are multiple windows open
autocmd FileType qf wincmd J

" default tab to 4 spaces
set sts=4 ts=4 sw=4 expandtab smarttab ai smartindent

" padding on j/k
set so=5

" deoplete-go
 let g:deoplete#enable_at_startup = 1
 " no func preview on autocomplete
 "set completeopt-=preview

 " autoselect first
 "set completeopt+=noinsert

 " fix conflict with tab below
 let g:UltiSnipsExpandTrigger = "<leader>j"

 " default C-n next, C-p prev; now tab & shift+tab; enter to close
 inoremap <silent><expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
 inoremap <silent><expr><S-TAB> pumvisible() ? "\<C-p>" : "\<S-TAB>"
 inoremap <silent><expr><ENTER> pumvisible() ? deoplete#mappings#close_popup() : "\<ENTER>"

" Git vim-gitgutter
 set updatetime=250

" FZF
 let $FZF_DEFAULT_COMMAND = 'ag -l -g "" --ignore-dir=vendor'
 nnoremap <silent> <C-p> :FZF<CR>

" Neomake
 autocmd! BufWritePost * Neomake

 " Typescript
 let g:neomake_typescript_tsc_maker = {
     \ 'args': ['-m', 'commonjs', '--noEmit' ],
     \ 'append_file': 0,
     \ 'errorformat':
         \ '%E%f %#(%l\,%c): error %m,' .
         \ '%E%f %#(%l\,%c): %m,' .
         \ '%Eerror %m,' .
         \ '%C%\s%\+%m'
         \ }
 "let g:tsuquyomi_disable_default_mappings = 1
 "let g:tsuquyomi_completion_detail = 1

 " eslint
  "let g:neomake_open_list = 2

  let g:neomake_javascript_enabled_makers = ['eslint']
  let g:neomake_javascript_eslint_exe = system('PATH=$(npm bin):$PATH && which eslint | tr -d "\n"')

" colorscheme
 colorscheme molokai_dark

" FileType
 autocmd BufRead,BufNewFile *.qtpl set filetype=html

" vim-go
 let g:go_fmt_command = "goimports"
 let g:go_def_mode = 'godef'

 let g:go_highlight_functions = 1
 let g:go_highlight_methods = 1
 let g:go_highlight_fields = 1
 let g:go_highlight_types = 1
 let g:go_highlight_operators = 1
 let g:go_highlight_build_constraints = 1
 let g:go_highlight_extra_types = 1
 let g:go_highlight_generate_tags = 1

 au FileType go nmap <Leader>dh <Plug>(go-def-split)
 au FileType go nmap <Leader>dv <Plug>(go-def-vertical)
 au FileType go nmap <Leader>dt <Plug>(go-def-tab)
 au FileType go nmap <Leader>gr <Plug>(go-referrers)
