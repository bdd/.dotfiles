function! s:PlistConvert(...)
  let l:fmt = a:0 == 0 ? 'xml1' : a:1

  if executable('plutil')
    execute '%!plutil -convert ' . l:fmt . ' -o - %'
  else
    echoerr 'plutil not found'
  endif
endfunction

function! s:CompletePlutilFmts(ArgLead, L, P)
  let l:fmts = ['xml1', 'json', 'binary1']
  return filter(l:fmts, 'v:val =~ "^' . a:ArgLead . '"')
endfunction

command! -buffer
      \ -nargs=?
      \ -complete=customlist,s:CompletePlutilFmts
      \ Convert call s:PlistConvert(<f-args>)
