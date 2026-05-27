function! PackAddBuiltin(pack, patch, ...) abort
  let l:bang = v:true
  if a:0 > 0
    let l:bang = v:false
  endif

  if has(a:patch)
    execute 'packadd' .. (l:bang ? '! ' : ' ') .. a:pack
    return v:true
  endif

  if !exists('g:missing_builtin_plugins')
    let g:missing_builtin_plugins = []
    autocmd VimEnter * ++once echohl WarningMsg
        \ | echomsg 'Missing builtin pack(s): ' .. join(g:missing_builtin_plugins, ', ')
        \ | echohl None
  endif

  call add(g:missing_builtin_plugins, a:pack)
  return v:false
endfunction
