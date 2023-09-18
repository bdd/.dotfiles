function! s:cclose_or_lclose()
  let l:wininfo = getwininfo(win_getid())[0]
  if l:wininfo['quickfix'] != 1
    echom 'not a quickfix kind of window. this was not supposed happen.'
    return
  endif

  let l:wintype = l:wininfo['loclist']
  execute ['cclose', 'lclose'][l:wintype]
endfunction

nmap <buffer><silent> q :call <SID>cclose_or_lclose()<CR>
