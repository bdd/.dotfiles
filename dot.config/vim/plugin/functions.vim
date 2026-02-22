" Utility Functions

function! PreferCmd(...) abort
  " Return the first argument which is a valid command.
  for l:cmd in a:000
    if exists(':' . l:cmd) == 2
      return l:cmd
    endif
  endfor
  return printf('echoerr "None in %s is a valid command."', string(a:000))
endfunction

function! s:KeepWinView(...) abort
  " Window view keeper akin to 'keeppatterns'.
  " Execute passed command and restore pre-execution window view.
  let l:saved_winview = winsaveview()
  execute join(a:000, ' ')
  call winrestview(l:saved_winview)
endfunction

command! -nargs=+ -complete=command KeepWinView call s:KeepWinView(<f-args>)
