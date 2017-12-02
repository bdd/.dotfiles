" Utility Functions

function! PreferCmd(...)
  " Return the first argument which is a valid command.
  for l:cmd in a:000
    if exists(':' . l:cmd) == 2
      return l:cmd
    endif
  endfor
  return 'echoerr "None in ' . string(a:000) . ' is a valid command."'
endfunction

function! ToggleOpt(opt)
  " Returns *string* 'set {opt}' or 'set no{opt}' to be executed for toggling.
  let l:toggle = eval('&' . a:opt) ? 'no' . a:opt : a:opt
  return 'set ' . l:toggle
endfunction

function! s:KeepPatterns(...)
  " 'keeppatterns' polyfill
  let l:cmd = join(a:000, ' ')

  if has('patch-7.4.155')  " released 2014/01/14
    execute 'keeppatterns ' . l:cmd
  else
    execute l:cmd
    call histdel('search', -1)
  endif
endfunction

command! -nargs=+ -complete=command KeepPatterns call s:KeepPatterns(<f-args>)

function! s:KeepWinView(...)
  " Window view keeper akin to 'keeppatterns'.
  " Execute passed command and restore pre-execution window view.
  let l:saved_winview = winsaveview()
  execute join(a:000, ' ')
  call winrestview(l:saved_winview)
endfunction

command! -nargs=+ -complete=command KeepWinView call s:KeepWinView(<f-args>)
