set encoding=utf-8
scriptencoding utf-8

" vim-plug {{{
silent! call plug#begin()
if exists('g:loaded_plug')
  " Order by GitHub user/project

  Plug 'fatih/vim-go'
  Plug 'godlygeek/tabular'

  Plug 'junegunn/fzf.vim'
  let g:homebrew_fzf = '/usr/local/opt/fzf'
  if !empty(glob(g:homebrew_fzf))
    Plug g:homebrew_fzf
  else
    Plug 'junegunn/fzf', {'dir': '~/.fzf', 'do': './install --bin'}
  endif

  Plug 'mileszs/ack.vim'
  if executable('rg')
    let g:ackprg = 'rg --smart-case --vimgrep'
  elseif executable('ag')
    let g:ackprg = 'ag --vimgrep'
  endif

  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-eunuch'
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-rsi'
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-unimpaired'

  Plug 'w0rp/ale'
  function! LinterStatus() abort
    let l:c = ale#statusline#Count(bufnr(''))
    let l:e = l:c.error + l:c.style_error
    let l:w = l:c.warning + l:c.style_warning
    return l:e + l:w > 0 ? printf('<Lint: %d Err, %d Warn>', l:e, l:w) : ''
  endfunction

  call plug#end()
endif
" }}}

" Terminal {{{
set ttyfast  " send more chars instead of ins/del line cmds for smooth redraw
set lazyredraw  " don't redraw while executing macros, register and cmds

if has('mouse')
  set mouse=a
endif

if exists('$TMUX')
  " Disable Background Control Erase (BCE)
  set t_ut=

  " 'xterm2' type supports dragging events, used when resizing windows.
  " Although Tmux supports it, Vim sets the value to 'xterm'.
  set ttymouse=xterm2
endif
" }}}

" Look & Feel {{{
set number relativenumber  " line number for the current, relative for others
set showcmd  " show last command
set shortmess=a  " a=all, use all abbrv possible in messages
set laststatus=2  " 2=always
set scrolloff=5  " scroll edge offset (to keep some context)
set wildmenu wildmode=list:longest
set list listchars=tab:»‧,trail:░,precedes:◄,extends:►,nbsp:‧

if has('syntax')
  syntax on
  set background=dark
  silent! colorscheme noclown  " silently continue if not found
endif

" Status Line
let &statusline = '[%n] %<%F %m%r%w%y%='
if exists('g:loaded_ale')
  let &statusline .= '%#WarningMsg#%{LinterStatus()}%*'
endif
let &statusline .= ' (%l,%c) %P of %L'
" }}}

" Behavior {{{
set autochdir  " change current directory to file in viewed buffer's
set hidden  " don't close but hide the buffer when dismissed
set splitbelow  " new window below when `split`
set splitright  " new window right when `vsplit`
set visualbell  " use visual bell instead of beeping
set autoread  " automatically re-read unmodified buffer on file change
set autowrite  " automatically save before :next, :make, :suspend, ...
set backspace=indent,eol,start  " backspace over everything

" Indentation
set expandtab  " spaces over tabs for indentation
set softtabstop=2  " without wasting too much screen estate
set shiftwidth=2  " shift equally to indentation
set tabstop=8  " tabs are 8 chars for a good reason, keep it that way
set autoindent  " always-be-indenting
set copyindent  " copy the existing indenting behavior of file
" }}}

" Searching
set ignorecase smartcase  " case insensitive search if there are no capital letters
set incsearch  " incrementally move to match and highlight
set hlsearch  " highlight previous search pattern
set history=1000  " command and search pattern history

" Key Mappings {{{
let g:mapleader = "\<Space>"

" Normal Mode
nnoremap ; :
nnoremap <Tab> %
nmap <Leader><Leader> :call PreferCmd('Buffers', 'buffers')<CR>
nmap <Leader>rc :split $MYVIMRC<CR>
nmap <silent> <Leader>/ :nohlsearch<CR>
nmap <C-V>s :echo SyntaxItem()<CR>

" Window Navigation
nnoremap <C-H> <C-W>h
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-L> <C-W>l

" Insert Mode
" Use <CR> to select completion suggestion instead of <C-y>
inoremap <expr> <CR> pumvisible() ? '<C-y>' : '<CR>'
" }}}

" Utility Functions {{{
function! Preserve(command)
  let l:saved_search = @/
  let l:line = line('.')
  let l:col = col('.')

  execute a:command

  let @/ = l:saved_search
  call cursor(l:line, l:col)
endfunction

function! SyntaxItem()
  " Return the names in syntax identifier chain for the symbol under cursor.
  " Chain is a '->' delimited string of linked syntax identifier names from
  " leaf to root.
  let l:cur_sid = synID(line('.'), col('.'), 1)
  let l:prev_sid = 0
  let l:chain = []

  while l:cur_sid != l:prev_sid
    call add(l:chain, l:cur_sid)
    let l:prev_sid = l:cur_sid
    let l:cur_sid = synIDtrans(l:cur_sid)
  endwhile

  return join(
        \ map(l:chain, "synIDattr(v:val, 'name')"),
        \ '->')
endfunction

function! PreferCmd(...)
  " Execute the first argument that exists as a command.
  for l:cmd in a:000
    if exists(':' . l:cmd) == 2
      return execute(l:cmd)
    endif
  endfor
endfunction
" }}}

" Commands
command! -nargs=0 StripTrailingSpaces call Preserve('%s/\s\+$//e')

" Enable file type detection with loading plugins & indent by file type.
filetype plugin indent on

" By default do not persist undo history but move storage under ~/.vim for the
" cases undo persistence might have been enabled for a particular filetype, etc.
set noundofile undodir=~/.vim/.undo/

" Keep viminfo file under ~/.vim instead of home.
set viminfo+=n~/.vim/.viminfo

" autocmd {{{
if has('autocmd')
  augroup filetype
    autocmd!
    " Indentation
    autocmd FileType python setlocal sts=4 sw=4
    autocmd FileType make setlocal noet ts=4 sts=0 sw=0
    autocmd FileType go setlocal nolist noet sts=0 sw=0
    autocmd FileType gitconfig setlocal nolist noet sts=0 sw=0
    autocmd FileType gitcommit setlocal spell
    autocmd FileType vim setlocal keywordprg=:help
    " Maps
    autocmd FileType help nnoremap <silent><buffer> q :q<CR>
  augroup END

  " Do not show trailing space markers in insert mode.
  augroup listchars
    autocmd!
    autocmd InsertEnter * if &list | set listchars-=trail:░ | endif
    autocmd InsertLeave * if &list | set listchars+=trail:░ | endif
  augroup END
endif
" }}}

let $LOCALVIMRC = expand('~/.vimrc.local')
if filereadable($LOCALVIMRC) | source $LOCALVIMRC | endif

" modeline:
" vim: undofile foldmethod=marker foldlevel=1
