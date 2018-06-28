" Basic settings
set number                    " Enable line numbers
"set ruler                     " Turn on the ruler
set autoindent
syntax on                     " Syntax highlighting
set title
set mouse=a
set tw=0
set hls
set ai!
set hidden
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set backspace=indent,eol,start " backspace over everything in insert mode
set shortmess+=A

map <C-Return> <CR><CR><C-o>k<Tab>

"==============================================================================
"                              NeoBundle Setup
"==============================================================================
if has('vim_starting')
  set nocompatible               " Be iMproved

  " Required:
  set runtimepath^=~/.vim/bundle/neobundle.vim/
endif

" Required:
call neobundle#begin(expand('~/.vim/bundle/'))

" Let NeoBundle manage NeoBundle
" Required:
NeoBundleFetch 'Shougo/neobundle.vim'

" NeoBundle 'Shougo/vimproc.vim'
NeoBundle 'itchyny/lightline.vim'
NeoBundle 'kien/ctrlp.vim'
NeoBundle 'scrooloose/syntastic'
NeoBundle 'scrooloose/nerdtree'
NeoBundle 'airblade/vim-gitgutter'
NeoBundle 'jlanzarotta/bufexplorer'
NeoBundle 'kchmck/vim-coffee-script'
NeoBundle 'kris89/vim-multiple-cursors'
NeoBundle 'valloric/MatchTagAlways'
NeoBundle 'ntpeters/vim-better-whitespace'
NeoBundle 'L9'
NeoBundle 'FuzzyFinder'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'fatih/vim-go'

call neobundle#end()

" Required:
filetype plugin indent on

" If there are uninstalled bundles found on startup,
" this will conveniently prompt you to install them.
NeoBundleCheck

"==============================================================================
"                          Lightline configuration
"==============================================================================

let g:lightline = {
    \ 'colorscheme' : 'solarized',
    \ }
set laststatus=2
set guifont=Inconsolata-dz\ for\ Powerline
set noshowmode
if !has('gui_running')
  set t_Co=256
endif

set colorcolumn=240

"==============================================================================
" Syntastic Settings
"==============================================================================

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
set statusline+=%{fugitive#statusline()}

"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
"let g:syntastic_check_on_open = 1
"let g:syntastic_check_on_wq = 0
let g:syntastic_error_symbol = '✗'
let g:syntastic_warning_symbol = '!'
let g:syntastic_quiet_messages = { "type": "style" }

"FuzzyFinder
nmap ,f :FufFileWithCurrentBufferDir<CR>
nmap ,b :FufBuffer<CR>
nmap ,t :FufTaggedFile<CR>

syntax enable
filetype plugin indent on

set backupdir=~/.vim/backup
set directory=~/.vim/tmp

"Go specific
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_fields = 1
let g:go_highlight_types = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
let g:go_fmt_command = "goimports"
let g:go_term_enabled = 1

au FileType go nmap gi <Plug>(go-install)
au FileType go nmap <leader>b <Plug>(go-build)
au FileType go nmap <leader>c <Plug>(go-coverage)
au FileType go nmap <leader>e <Plug>(go-rename)
au FileType go nmap <leader>i <Plug>(go-info)
au FileType go nmap <leader>l :GoLint<CR>
au FileType go nmap <leader>q :GoImport<space>
au FileType go nmap <Leader>f <Plug>:GoImpl<space>
au FileType go nmap <leader>ff <Plug>(go-implements)
au FileType go vmap <leader>r :GoAddTags<space>
au FileType go vmap <leader>p :GoPlay<CR>
au FileType go nmap <leader>r <Plug>(go-run)
au FileType go nmap <leader>s <Plug>(go-install)
au FileType go nmap <leader>t <Plug>(go-test)
au FileType go nmap <leader>v <Plug>(go-vet)
au FileType go nmap <leader>a :GoAlternate<CR>
au FileType go nmap <leader>ds <Plug>(go-def-split)
au FileType go nmap <leader>dv <Plug>(go-def-vertical)
au FileType go nmap <leader>dt <Plug>(go-def-tab)
au FileType go nmap <leader>gb <Plug>(go-doc-browser)
au FileType go nmap <leader>gs <Plug>(go-doc-split)
au FileType go nmap <leader>gv <Plug>(go-doc-vertical)
au FileType go nmap <leader>tc <Plug>(go-coverage-toggle)

