function s:GetVisualSelection() abort
  if exists('*getregion')
    let l:type = visualmode()
    let l:region = getregion(getpos("'<"), getpos("'>"), {'type': l:type})
    let l:text = join(l:region, "\n")
    " Ensure line-wise selections or blocks have a trailing newline
    "if l:type ==# 'V' || (l:type ==# 'v' && l:text !~# '\n$')
    "  let l:text .= "\n"
    "endif
  else
    " Fallback: Use register 'z' to capture complex selection shapes.
    let l:reg = 'z'
    let l:save_reg = #{contents: getreg(l:reg), type: getregtype(l:reg)}
    let l:save_winview = winsaveview()

    execute 'silent noautocmd normal! gv"' . l:reg. 'y'
    let l:text = getreg(l:reg)

    call setreg(l:reg, l:save_reg['contents'], l:save_reg['type'])
    call winrestview(l:save_winview)
  endif

  return l:text
endfunction

function! s:TermClip(line1, line2, count, reg) abort
  if a:count > 0
    " A range was provided.
    " Does it align with the last visual selection?
    if a:line1 == line("'<") && a:line2 == line("'>") && !empty(visualmode())
      let l:text = s:GetVisualSelection()
    else
      " Handle line ranges (e.g., :.,+3 TermClip).
      let l:text = join(getline(a:line1, a:line2), "\n") . "\n"
    endif
  else
    " Use the register specified e.g. `"a:TermClip`.
    " If unspecified it defaults to unnamed register `""`.
    let l:reg = empty(a:reg) ? '"' : a:reg
    let l:text = getreg(l:reg)
  endif

  if empty(l:text)
    echohl WarningMsg | echo "TermClip: nothing to send"
    return v:false
  endif

  echoconsole system("$SHELL -ic termclip", l:text)
  redraw!
endfunction

" Define the command with -range=0 to detect if a selection was made,
" and -register to allow passing register prefixes like "a.
command! -range=0 -register TermClip call <SID>TermClip(<line1>, <line2>, <count>, '<reg>')
nnoremap <silent> <leader>y :TermClip<cr>
vnoremap <silent> <leader>y :TermClip<cr>
