if exists('g:loaded_install')
  finish
endif
let g:loaded_install = 1

function! install#(...) abort
  silent! packadd minpac
  if exists('g:loaded_minpac')
    echo "minpac is already installed"
  else
    let l:repo = 'https://github.com/k-takata/minpac.git'
    let l:local = split(&packpath, ',')[0] . '/pack/minpac/opt/minpac'
    let l:cmdline = printf("git clone --depth 1 \"%s\" \"%s\" 2>&1", l:repo, l:local)

    let l:output = system(l:cmdline)
    if v:shell_error
      echoerr 'Error cloning minpac repository: ' . l:output
      return v:false
    endif
  endif


  let s:finish_hook = a:0 > 0 ? a:1 : 'packloadall!'
  augroup install#post_install
    autocmd!
    autocmd VimEnter * call minpac#update('', {'do': s:finish_hook})
  augroup END

  return v:true
endfunction
