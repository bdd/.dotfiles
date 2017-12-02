set encoding=utf-8
scriptencoding utf-8

" Terminal {{{
set ttyfast       " assume fast terminal and send more chars for smooth redraw
set lazyredraw    " don't redraw while executing macros, register and cmds
set mouse=a       " enable mouse in all modes (=a)
set ttymouse=sgr  " like xterm2 but supporting beyond 223 columns
" }}}

" Look & Feel {{{
syntax on
silent! colorscheme noclown

let &statusline = '[%n] %<%F %m%r%w%y %= (%l,%c) %P of %L'
set laststatus=2           " every window gets a statusline, always(=2)
set number relativenumber  " line number for the current, relative for others
set scrolloff=5            " scroll edge offset (to keep some context)
set shortmess=a            " abbreviate all(=a) messages when possible
set showcmd                " show last command

" command line completion similar to zsh default
" complete up to longest match and display the list of possible matches
set wildmode=list:longest

set list listchars=tab:»‧,trail:░,precedes:◄,extends:►,nbsp:‧
augroup listchars
  autocmd!
  " Hide trailing space markers in insert mode with a blank override.
  autocmd InsertEnter * if &list | set listchars+=trail:\  | endif
  autocmd InsertLeave * if &list | set listchars-=trail:\  | endif
  " Don't show tab markers if 'expandtab' isn't set.
  autocmd BufEnter * if &expandtab == 0 | setlocal listchars+=tab:\ \  | endif
augroup END
" }}}

" Behavior {{{
set hidden                      " don't unload but hide buffers when dismissed
set splitbelow splitright       " new window split to below, vsplit to right
set autochdir                   " change cwd to file's in selected buffer
set autoread                    " pickup file changes under unmodified buffer
set autowrite                   " write to before :next, :make, :suspend, ...
set autoindent                  " always-be-indenting
set copyindent                  " copy the existing indenting behavior of file
set expandtab                   " spaces over tabs for indentation
set shiftwidth=2                " without wasting too much screen estate
set softtabstop=-1              " equal to 'shiftwidth'
set ignorecase smartcase        " case insensitive search if all lowercase
set incsearch                   " incrementally move to match and highlight
set hlsearch                    " highlight previous search pattern
set history=1000                " command and search pattern history size
set visualbell                  " use visual bell instead of beeping
set backspace=indent,eol,start  " backspace over everything
"}}}

" Plugins {{{
"" Distributed with Vim
""" matchit: Extend '%' to matching groups like 'if', 'else', 'endif'.
if has('patch-7.4.1649')  " released 2016/03/25
  packadd! matchit
else
  runtime macros/matchit.vim
endif

""" ftplugin/man.vim: Render man pages in buffers with ':Man' command.
runtime ftplugin/man.vim
if exists(':Man')
  " Make 'K' in normal mode also use ':Man' instead of shelling out.
  set keywordprg=:Man
endif

"" Third-party: managed with vim-plug
silent! call plug#begin()
if exists('g:loaded_plug')
  Plug 'fatih/vim-go'
  Plug 'godlygeek/tabular'
  Plug 'junegunn/fzf', {'dir': g:plug_home . '/fzf', 'do': './install --bin'}
  Plug 'junegunn/fzf.vim'

  Plug 'mileszs/ack.vim'
  if executable('rg')
    let g:ackprg = 'rg --smart-case --vimgrep'
  elseif executable('ag')
    let g:ackprg = 'ag --smart-case --vimgrep'
  endif

  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-eunuch'
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-rsi'
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-unimpaired'

  Plug 'w0rp/ale'
  let &statusline = substitute(&statusline,'%=',
        \ '%= %#WarningMsg#%{LinterStatus()}%*', '')
  function! LinterStatus() abort
    if exists('g:loaded_ale')
      let l:c = ale#statusline#Count(bufnr(''))
      let l:e = l:c.error + l:c.style_error
      let l:w = l:c.warning + l:c.style_warning
      return l:e + l:w > 0 ? printf('<Lint: %d Err, %d Warn>', l:e, l:w) : ''
    endif
  endfunction

  call plug#end()
endif
" }}}

" Key Mappings {{{
let g:mapleader = "\<Space>"

" Use ';' instead of ':' for single finger key go into command mode from
" normal and visual modes.
nnoremap ; :
xnoremap ; :
" ...but don't lose the function of ';' to repeat f, F, t, T
nnoremap \ ;

" Use <CR> to select completion suggestion instead of <C-y>
inoremap <expr> <CR> pumvisible() ? '<C-y>' : '<CR>'

nmap <Leader><Leader> :execute PreferCmd('Buffers', 'buffers')<CR>
nmap <Leader>/ :execute ToggleOpt('hlsearch')<CR>
nmap <Leader>h <Plug>(noclown-echo-highlight-group-chain)
" }}}

" Commands
command! StripTrailingSpaces KeepWinView KeepPatterns %s/\v\s+$//e
" Tmux supports BCE since 2.4 (released 2017/04/20). May still need this.
command! NoBCE set t_ut= <Bar> redraw!

" Detect file types. Load '&rtp/{ftplugin, indent}/<ft>.vim'.
filetype plugin indent on

" 'undofile' is off by default but when enabled keep them together under
" a well-known location instead of same directory with edited files.
set undodir=~/.vim/.undo/

" Keep viminfo file under ~/.vim instead of home.
set viminfo+=n~/.vim/.viminfo

" Local additions and overrides
let $LOCALVIMRC = expand('~/.vimrc.local')
if filereadable($LOCALVIMRC) | source $LOCALVIMRC | endif

" vim: undofile foldmethod=marker foldlevel=1
