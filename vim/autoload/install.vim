if exists('g:loaded_install') | finish | endif
let g:loaded_install = 1

let s:this_script_dir = expand('<sfile>:p:h')
let s:post_install_cmds = []

function install#all()
  " Register the function to run post installation commands.
  " 'VimEnter' is after vimrc, '-c' args, creating windows and loading buffers.
  augroup postinstall
    autocmd!
    autocmd VimEnter * call s:post_install()
  augroup END

  " Installation tasks:
  call s:install_vim_plug()
endfunction

function s:post_install()
  while len(s:post_install_cmds) > 0
    execute remove(s:post_install_cmds, 0)
  endwhile
endfunction

function s:install_vim_plug()
  let l:vim_plug_url = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  let l:curl = [
        \ 'curl',
        \ '--silent',
        \ '--show-error',
        \ '--fail',
        \ '--location',
        \ '--remote-name',
        \ '"' . l:vim_plug_url . '"']
  let l:cmd = join(l:curl, ' ')

  " Download to same directory with this script.
  execute 'cd' s:this_script_dir
  let l:output = system(l:cmd . ' 2>&1')
  execute 'cd -'

  if v:shell_error
    throw 'Error downloading vim-plug: ' . l:output
  endif

  call add(s:post_install_cmds, 'if exists("g:loaded_plug") | PlugInstall | endif')

  return 1
endfunction
