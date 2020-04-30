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

 " native lsp
 Plug 'neovim/nvim-lsp'

  " deoplete integration
  Plug 'Shougo/deoplete-lsp'

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

 " auto set paste
 Plug 'ConradIrwin/vim-bracketed-paste'

 " auto close things
 "Plug 'Raimondi/delimitMate'

call plug#end()

" disable match parans
let g:loaded_matchparen=1

set shellcmdflag=-ic            " :!
set encoding=utf-8              " set default encoding to UTF-8
"set wildmode=list:longest      " no tab cicly
set list listchars=tab:»\ ,trail:·
set tabstop=4 shiftwidth=4
set so=5                        " padding on j/k
set autoread                    " automatically reread changed files without asking me anything
set autoindent
set backspace=indent,eol,start  " makes backspace key more powerful.
set incsearch                   " shows the match while typing
set hlsearch                    " highlight found searches
set mouse=a                     " enable mouse mode
set noerrorbells                " no beeps
set nonumber                    " no line numbers
set showcmd                     " show me what I'm typing
set noswapfile                  " don't use swapfile
set nobackup                    " don't create annoying backup files
set splitright                  " split vertical windows right to the current windows
" set splitbelow                  " split horizontal windows below to the current windows
set hidden
set fileformats=unix,dos,mac    " prefer Unix over Windows over OS 9 formats
set noshowmatch                 " do not show matching brackets by flickering
set noshowmode                  " we show the mode with airline or lightline
set ignorecase                  " search case insensitive...
set smartcase                   " ... but not it begins with upper case
"set completeopt=menu,menuone
set nocursorcolumn              " speed up syntax highlighting
set nocursorline
set updatetime=200              " gutter, go auto type uses it
set pumheight=10                " completion window max size
set conceallevel=2              " concealed text is completely hidden
set shortmess+=c                " Shut off completion messages
set lazyredraw

"http://stackoverflow.com/questions/20186975/vim-mac-how-to-copy-to-clipboard-without-pbcopy
set clipboard^=unnamed
set clipboard^=unnamedplus

" increase max memory to show syntax highlighting for large files
set maxmempattern=20000

" ~/.viminfo needs to be writable and readable. Set oldfiles to 1000 last
" recently opened files, :FzfHistory uses it
set viminfo='1000

if has('persistent_undo')
  set undofile
  set undodir=~/.cache/vim
endif

" Do not show q: window
map q: :q

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

" color
syntax enable
set t_Co=256
set background=dark
let g:molokai_original = 1
let g:rehash256 = 1
colorscheme molokai

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
let g:airline#extensions#ale#enabled = 1

"let g:ale_completion_enabled = 1 " enable LSP autocomplete
"set omnifunc=ale#completion#OmniFunc
"set completeopt=noinsert,menuone,noselect

" deoplete with ale
" call deoplete#custom#source('_', 'ale') " use ale LSP

" map
" nmap gd :ALEGoToDefinition<CR>
" nmap <Leader>dh :ALEGoToDefinitionInSplit<CR>
" nmap <Leader>dv :ALEGoToDefinitionInVSplit<CR>
" nmap <Leader>dt :ALEGoToDefinitionInTab<CR>
" nmap <Leader>gr :ALEFindReferences<CR>
" nmap <Leader>i :ALEHover<CR>

" next err
nmap <silent> <C-j> <Plug>(ale_next_wrap)

 let g:ale_fixers = {
 \   'vue': ['prettier', 'eslint', 'prettier-eslint'],
 \   'javascript': ['prettier', 'eslint', 'prettier-eslint'],
 \   'typescript': ['prettier', 'tslint'],
 \   'typescriptreact': ['prettier', 'tslint'],
 \   'python': ['autopep8', 'yapf'],
 \   'graphql': ['prettier'],
 \   'json': ['prettier'],
 \   'sass': ['prettier'],
 \   'html': ['prettier-eslint'],
 \}

 let g:ale_linters = {
 \   'go': ['golangci-lint'],
 \   'py': ['flake8', 'pylint'],
 \   'typescript': ['tsserver'],
 \   'typescriptreact': ['tsserver'],
 \   'javascript': ['eslint'],
 \   'html': ['prettier-eslint'],
 \}

 let g:ale_fix_on_save = 1
 let g:ale_lint_on_text_changed = "normal"

 " navigate between errors
 "nmap <silent> <C-k> <Plug>(ale_previous_wrap)
 "nmap <silent> <C-j> <Plug>(ale_next_wrap)

" Deoplete autocomplete
let g:deoplete#enable_at_startup = 1

"set completeopt+=noinsert

" nvim-lsp
lua require'nvim_lsp'.gopls.setup{}
lua require'nvim_lsp'.tsserver.setup{}
lua require'nvim_lsp'.pyls.setup{}
lua require'nvim_lsp'.html.setup{}
lua require'nvim_lsp'.vuels.setup{}
lua require'nvim_lsp'.yamlls.setup{}
lua require'nvim_lsp'.dockerls.setup{}
lua require'nvim_lsp'.jsonls.setup{}
lua require'nvim_lsp'.vimls.setup{}

autocmd Filetype go,javascript,typescript,python,html,vue,yaml,dockerfile,json,vim setlocal omnifunc=v:lua.vim.lsp.omnifunc

" FZF
 let $FZF_DEFAULT_COMMAND = 'ag -l -g "" --hidden --ignore-dir=vendor --ignore-dir=node_modules --ignore-dir=.git'
 command! -nargs=* CodeRef call fzf#vim#ag(<q-args>)

" vim-go
 " deoplete with vim-go
 "call deoplete#custom#option('omni_patterns', { 'go': '[^. *\t]\.\w*' })
 "
 " add --ignore-dir=vendor on https://github.com/junegunn/fzf.vim/blob/master/autoload/fzf/vim.vim#L695
 let g:go_fmt_command = "goimports"
 let g:go_metalinter_command = "golangci-lint"

 " let g:go_auto_sameids = 1
 " let g:go_auto_type_info = 1

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
 let g:go_code_completion_enabled = 0

nnoremap <silent> <Leader>dv <C-w>v <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> <Leader>dh <C-w>s <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> gd                <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> <c-]>             <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> K                 <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gD                <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <c-k>             <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> 1gD               <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gr                <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> g0                <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> gf                <cmd>lua vim.lsp.buf.formatting()<CR>
nnoremap <silent> rn                <cmd>lua vim.lsp.buf.rename()<CR>

" Lsp Colors
hi LspDiagnosticsError                 ctermfg=red
hi LspDiagnosticsWarning               ctermfg=yellow
hi LspDiagnosticsInformation           ctermfg=blue
hi LspDiagnosticsHint                  ctermfg=blue
hi LspDiagnosticsUnderline               guisp=white  gui=undercurl
hi LspDiagnosticsUnderlineError          guisp=red    gui=undercurl
hi LspDiagnosticsUnderlineWarning        guisp=yellow gui=undercurl
hi LspDiagnosticsUnderlineInformation    guisp=blue   gui=undercurl
hi LspDiagnosticsUnderlineHint           guisp=blue   gui=undercurl
hi LspReferenceText                     ctermbg=gray  gui=bold,italic
hi LspReferenceRead                     ctermbg=gray  gui=bold,italic
hi LspReferenceWrite                    ctermbg=gray  gui=bold,italic


" Dim inactive windows using 'colorcolumn' setting
" This tends to slow down redrawing, but is very useful.
" Based on https://groups.google.com/d/msg/vim_use/IJU-Vk-QLJE/xz4hjPjCRBUJ
" this will only work with lines containing text (i.e. not '~')
if exists('+colorcolumn')
  function! s:DimInactiveWindows()
    for i in range(1, tabpagewinnr(tabpagenr(), '$'))
      let l:range = ""
      if i != winnr()
        if &wrap
         " HACK: when wrapping lines is enabled, we use the maximum number
         " of columns getting highlighted. This might get calculated by
         " looking for the longest visible line and using a multiple of
         " winwidth().
         let l:width=256 " max
        else
         let l:width=winwidth(i)
        endif
        let l:range = join(range(1, l:width), ',')
      endif
      call setwinvar(i, '&colorcolumn', l:range)
    endfor
  endfunction
  augroup DimInactiveWindows
    au!
    au WinEnter * call s:DimInactiveWindows()
    "au WinEnter * set cursorline
    "au WinLeave * set nocursorline
  augroup END
endif
