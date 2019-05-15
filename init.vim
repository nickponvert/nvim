set nocompatible            " Disable compatibility to old-time vi
set showmatch               " Show matching brackets.
set ignorecase              " Do case insensitive matching
set mouse=v                 " middle-click paste with mouse
set hlsearch                " highlight search results
set tabstop=4               " number of columns occupied by a tab character
set softtabstop=4           " see multiple spaces as tabstops so <BS> does the right thing
set expandtab               " converts tabs to white space
set shiftwidth=4            " width for autoindents
set autoindent              " indent a new line the same amount as the line just typed
set number                  " add line numbers
set wildmode=longest,list   " get bash-like tab completions
" set cc=80                   " set an 80 column border for good coding style

" Key bindings
map <Space> <Leader>

" Window management
nnoremap <Leader>w <C-w>

""""" WORD PROCESSING """"""
" Function to set text-editing-specific commands
func! WordProcessor()
  " movement changes
  map j gj
  map k gk
  " formatting text
  setlocal formatoptions=1
  setlocal noexpandtab
  setlocal wrap
  setlocal linebreak
  " spelling and thesaurus
  setlocal spell spelllang=en_us
  set thesaurus+=/home/test/.vim/thesaurus/mthesaur.txt
  " complete+=s makes autocompletion search the thesaurus
  set complete+=s
endfu
com! WP call WordProcessor()

" Easy replace misspelled word from insert mode
inoremap <C-h> <c-g>u<Esc>[s1z=`]a<c-g>u

""""" QUICKFIX GREPPING """"""
" Tell Vim what external program to use for grepping.
  " I use the silver searcher, but you can use ripgrep or whatever works for you.
set grepprg=ag\ --vimgrep

" Open the location/quickfix window automatically if there are valid entries in the list.
  " I actually use a more generic and more useful version of this snippet that works for
  " every quickfix command, not just these ones.
augroup quickfix
	autocmd!
	autocmd QuickFixCmdPost cgetexpr cwindow
	autocmd QuickFixCmdPost lgetexpr lwindow
augroup END

" Use :Grep instead of :grep! and :LGrep instead of :lgrep!.
  " :cgetexpr and :lgetexpr are much faster than :grep and :lgrep
  " and they don't mess with your terminal emulator.
command! -nargs=+ -complete=file_in_path -bar Grep  cgetexpr system(&grepprg . ' ' . shellescape(<q-args>))
command! -nargs=+ -complete=file_in_path -bar LGrep lgetexpr system(&grepprg . ' ' . shellescape(<q-args>))

filetype off
let g:python3_host_prog = '/home/nick.ponvert/anaconda3/bin/python'
" set the runtime path to include Vundle and initialize
set rtp+=~/.config/nvim/bundle/Vundle.vim
set rtp+=~/.fzf
call vundle#begin('~/.config/nvim/bundle')
Plugin 'VundleVim/Vundle.vim'

" Git wrapper
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-rhubarb'

" Should be default
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-unimpaired'

Plugin 'junegunn/fzf.vim'

"Plugin 'vim-airline/vim-airline'

call vundle#end()
filetype plugin indent on
" let Vundle manage Vundle, required
