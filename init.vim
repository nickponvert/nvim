set nocompatible            " Disable compatibility to old-time vi
set showmatch               " Show matching brackets.
set ignorecase              " Do case insensitive matching
set mouse=v                 " middle-click paste with mouse
set hlsearch                " highlight search results
set tabstop=4               " number of columns occupied by a tab character
set softtabstop=4           " see multiple spaces as tabstops so <BS> does the right thing
set expandtab               " converts tabs to white space
set shiftwidth=4            " width for autoindents set autoindent              " indent a new line the same amount as the line just typed
set number                  " add line numbers
set wildmenu
set wildmode=longest,list   " get bash-like tab completions
set scrolloff=10
imap fd <Esc>
" set cc=80                   " set an 80 column border for good coding style
"

" Key bindings
map <Space> <Leader>

" Window management
" nnoremap <Leader>w <C-w>
" nnoremap <C-J> <C-W><C-J>
" nnoremap <C-K> <C-W><C-K>
" nnoremap <C-L> <C-W><C-L>
" nnoremap <C-H> <C-W><C-H>
nnoremap Q @@

" FZF bindings
nmap <Leader>b :Buffers<CR>
nmap <Leader>f :Files<CR>
nmap <Leader>t :Tags<CR>
nmap <Leader>s :Ag<CR>
nmap <Leader>m :Marks<CR>
nmap <Leader><space> :Commands<CR>

" Unimpaired-style bindings for moving between hunks
nmap ]g :GitGutterNextHunk<CR>
nmap [g :GitGutterPrevHunk<CR>

""""" WORD PROCESSING """"""
" Function to set text-editing-specific commands
func! WordProcessor()
  call goyo#execute(0, [])
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


" set the runtime path to include Vundle and initialize
set rtp+=~/.config/nvim/bundle/Vundle.vim
set rtp+=~/.fzf
call vundle#begin('~/.config/nvim/bundle')
Plugin 'VundleVim/Vundle.vim'

" Git wrapper
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-rhubarb'
Plugin 'junegunn/goyo.vim'

" Should be default
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-unimpaired'
Plugin 'chriskempson/base16-vim'
Plugin 'scrooloose/nerdcommenter'

Plugin 'itchyny/lightline.vim'
Plugin 'junegunn/fzf.vim'
Plugin 'airblade/vim-gitgutter'

Plugin 'w0rp/ale'
Plugin 'maximbaz/lightline-ale'
Plugin 'mileszs/ack.vim'
Plugin 'christoomey/vim-tmux-navigator'

Plugin 'vim-python/python-syntax'

" TODO: I want to get this working. 
" Plugin 'neoclide/coc.nvim'

call vundle#end()
filetype plugin indent on
" let Vundle manage Vundle, required
"
"
set rtp+=/home/nick/.fzf/bin/fzf
let g:ackprg = 'ag --vimgrep'

" GitGutter
let g:gitgutter_sign_added = '●'
let g:gitgutter_sign_modified = '●'
let g:gitgutter_sign_removed = '●'
let g:gitgutter_sign_modified_removed = '●'

let g:NERDSpaceDelims = 1
let g:NERDDefaultAlign = 'left'
let g:NERDCommentEmptyLines = 1
let g:NERDToggleCheckAllLines = 1

let g:python3_host_prog = '/home/nick.ponvert/anaconda3/bin/python'
let base16colorspace=256  " Access colors present in 256 colorspace
colorscheme base16-harmonic-light
set noshowmode

" ALE
highlight clear LineNr
highlight clear SignColumn
" highlight link ALEErrorSign Error
" highlight link ALEWarningSign Error
" let g:ale_sign_warning = '▲'
let g:ale_sign_warning = '▲'
let g:ale_sign_error = '✗'
let g:ale_set_highlights = 0
" highlight link ALEWarningSign String
" highlight link ALEErrorSign Title

function! LightlineLinterWarnings() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors
  return l:counts.total == 0 ? '' : printf('%d ▲', all_non_errors)
  " return l:counts.total == 0 ? '' : printf('%d ◆', all_non_errors)
endfunction

function! LightlineLinterErrors() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors
  return l:counts.total == 0 ? '' : printf('%d ✗', all_errors)
endfunction

function! LightlineLinterOK() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors
  return l:counts.total == 0 ? '✓ ' : ''
endfunction

autocmd User ALELint call s:MaybeUpdateLightline()

" Update and show lightline but only if it's visible (e.g., not in Goyo)
function! s:MaybeUpdateLightline()
  if exists('#lightline')
    call lightline#update()
  end
endfunction

" Lightline
let g:lightline = {
\ 'colorscheme': 'seoul256',
\ 'active': {
\   'left': [['mode', 'paste'], ['filename', 'modified']],
\   'right': [['lineinfo'], ['percent'], ['readonly', 'linter_warnings', 'linter_errors', 'linter_ok']]
\ },
\ 'component_expand': {
\   'linter_warnings': 'LightlineLinterWarnings',
\   'linter_errors': 'LightlineLinterErrors',
\   'linter_ok': 'LightlineLinterOK'
\ },
\ 'component_type': {
\   'readonly': 'error',
\   'linter_warnings': 'warning',
\   'linter_errors': 'error'
\ },
\ }
