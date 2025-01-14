" Don't try to be vi compatible
set nocompatible

" Helps force plugins to load correctly when it is turned back on below
filetype off

" Install plug from https://github.com/junegunn/vim-plug and run :PluginInstall
call plug#begin()

" Git commands for vim
Plug 'tpope/vim-fugitive'

" Changes to what/how Vim show us things
Plug 'vim-syntastic/syntastic'
Plug 'osamuaoki/vim-spell-under'
Plug 'airblade/vim-gitgutter'
Plug 'itchyny/lightline.vim'
Plug 'pedrohdz/vim-yaml-folds'
Plug 'Yggdroot/indentLine'

" Extra IDE like functionality
Plug 'preservim/nerdtree'
Plug 'majutsushi/tagbar'
Plug 'jiangmiao/auto-pairs'

" Completion and linting
if has ('nvim')
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
else
  Plug 'ycm-core/YouCompleteMe', {'frozen': 'true', 'do': './install.py'}
endif
Plug 'dense-analysis/ale'

" Go debugging with delve
Plug 'sebdah/vim-delve'

" Better Go language support
Plug 'fatih/vim-go', {'do': ':GoUpdateBinaries'}

" Terraform language support
Plug 'hashivim/vim-terraform'

" Helm syntax highlighting
Plug 'towolf/vim-helm'

" Cue syntax highlighting
Plug 'jjo/vim-cue'

" Catppuccin colorscheme
Plug 'catppuccin/nvim', { 'as': 'catppuccin' }

" Better sorting
Plug 'inkarkat/vim-ingo-library'
Plug 'inkarkat/vim-AdvancedSorters'

" Fuzzy finder
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }

call plug#end()

" Turn on syntax highlighting
syntax on

" For plugins to load correctly
filetype plugin indent on

" Language
set langmenu=en_US
let $LANG = 'en_US'

" TODO: Pick a leader key
" let mapleader = ","

" Security
set modelines=0

" Show line numbers
set number

" Show file stats
set ruler

" Blink cursor on error instead of beeping (grr)
" set visualbell

" Encoding
set fileencodings=utf-8
set encoding=utf-8

" Whitespace
set wrap
set textwidth=79
set formatoptions=tcqrn1
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set noshiftround

" Cursor motion
set scrolloff=3
set backspace=indent,eol,start
set matchpairs+=<:> " use % to jump between pairs
runtime! macros/matchit.vim

" Move up/down editor lines
nnoremap j gj
nnoremap k gk

" Allow hidden buffers
set hidden

" Rendering
set ttyfast

" Status bar
set laststatus=2

" Last line
set showmode
set showcmd

" Searching
nnoremap / /\v
vnoremap / /\v
set hlsearch
set incsearch
set ignorecase
set smartcase
set showmatch
map <leader><space> :let @/=''<cr> " clear search

" Display all matching files when we tab complete
set wildmenu

" Remap help key.
inoremap <F1> <ESC>:set invfullscreen<CR>a
nnoremap <F1> :set invfullscreen<CR>
vnoremap <F1> :set invfullscreen<CR>

" Textmate holdouts

" Formatting
map <leader>q gqip

" Visualize tabs and newlines
set listchars=tab:▸\ ,eol:¬
" Uncomment this to enable by default:
" set list " To enable by default
" Or use your leader key + l to toggle on/off
map <leader>l :set list!<CR> " Toggle tabs and EOL

" Color scheme (terminal)
set t_Co=256
set background=dark
let g:solarized_termcolors=256
let g:solarized_termtrans=1
" put https://raw.github.com/altercation/vim-colors-solarized/master/colors/solarized.vim
" in ~/.vim/colors/ and uncomment:
" colorscheme solarized
colorscheme catppuccin

" Leader commands for go applications
autocmd FileType go nmap <leader>b <Plug>(go-build)
autocmd FileType go nmap <leader>r <Plug>(go-run)
autocmd FileType go nmap <leader>t <Plug>(go-test)
autocmd FileType go nmap <leader>c <Plug>(go-coverage-toggle)

" Run goimports on save to go file
let g:go_fmt_command = "goimports"

" Run golangci-lint on save
let g:go_metalinter_command='golangci-lint'
let g:go_metalinter_enabled = []
let g:go_metalinter_autosave=1
let g:go_metalinter_autosave_enabled=[]

nnoremap <C-t> :NERDTreeToggle<CR>
if has('nvim')
  " Use tab for trigger completion with characters ahead and navigate
  " NOTE: There's always complete item selected by default, you may want to enable
  " no select by `"suggest.noselect": true` in your configuration file
  " NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
  " other plugin before putting this into your config
  inoremap <silent><expr> <TAB>
        \ coc#pum#visible() ? coc#pum#next(1) :
        \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>)" :
        \ CheckBackspace() ? "\<Tab>" :
        \ coc#refresh()
  inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

  let g:coc_snippet_next = '<tab>'

  " Make <CR> to accept selected completion item or notify coc.nvim to format
  " <C-g>u breaks current undo, please make your own choice
  inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                                \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

  function! CheckBackspace() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
  endfunction

  " Use <c-space> to trigger completion
  inoremap <silent><expr> <c-space> coc#refresh()

  " GoTo code navigation
  nmap <silent> gd <Plug>(coc-definition)
  nmap <silent> gy <Plug>(coc-type-definition)
  nmap <silent> gi <Plug>(coc-implementation)
  nmap <silent> gr <Plug>(coc-references)

  let g:coc_global_extensions = ['coc-go', 'coc-git', 'coc-snippets', 'coc-json', 'coc-yaml']

  " Use K to show documentation in preview window
  nnoremap <silent> <SPACE> :call ShowDocumentation()<CR>

  function! ShowDocumentation()
    if CocAction('hasProvider', 'hover')
      call CocActionAsync('doHover')
    else
      call feedkeys('K', 'in')
    endif
  endfunction
  "
  " Highlight the symbol and its references when holding the cursor
  autocmd CursorHold * silent call CocActionAsync('highlight')
endif
if !has('nvim')
  nnoremap <SPACE> :YcmCompleter GetType<CR>
endif

if has('nvim')
  let g:delve_backend = "native"
endif

nmap <F8> :TagbarToggle<CR>

let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'readonly', 'relativepath', 'modified', 'cocstatus' ] ]
      \ },
      \ 'component_function': {
      \   'cocstatus': 'coc#status'
      \ },
      \ }

autocmd User CocStatusChange,CocDiagnisticChange call lightline#update()

let g:ycm_autoclose_preview_window_after_insertion=1

" Custom options for yamllint are stored in ~/.config/yamllint/config
" let g:ale_yaml_yamllint_options='-d relaxed'
"
" Disable ale linting for go files, we use vim-go and golangci-lint instead
let g:ale_linters = {
\   'go': [],
\   'markdown': ['markdownlint'],
\}
let g:ale_markdown_markdownlint_options="--config /Users/kristinn/.markdownlintrc"

" Ale linter navigation
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

let g:rainbow_active = 1

set foldlevelstart=20

" Don't use indentLine for markdown files (indentLine sets conceallevel=2)
let g:indentLine_fileTypeExclude = ['markdown']

"" Autocmd for filetypes
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

" Terraform options
let g:terraform_align=1
let g:terraform_fmt_on_save=1

" quickfix list navigation
map <C-n> :cnext<CR>
map <C-m> :cprevious<CR>
nnoremap <leader>a :cclose<CR>
