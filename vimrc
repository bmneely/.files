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
set tabstop=2
set softtabstop=2
set shiftwidth=2
set smarttab
set backspace=indent,eol,start " backspace over everything in insert mode

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

NeoBundle 'Shougo/vimproc.vim'
NeoBundle 'itchyny/lightline.vim'
NeoBundle 'kien/ctrlp.vim'
NeoBundle 'scrooloose/syntastic'
NeoBundle 'scrooloose/nerdtree'
NeoBundle 'airblade/vim-gitgutter'

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


"==============================================================================
" Syntastic Settings
"==============================================================================

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
"let g:syntastic_check_on_open = 1
"let g:syntastic_check_on_wq = 0
let g:syntastic_error_symbol = '✗'
let g:syntastic_warning_symbol = '!'
let g:syntastic_quiet_messages = { "type": "style" }
