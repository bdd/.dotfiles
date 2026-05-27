vim9script

g:lsp_options = {
  incrementalSync: true,
  showDiagWithVirtualText: true,
  diagVirtualTextAlign: 'below',
  showDiagOnStatusLine: true,
  popupBorder: true,
  popupBorderHighlight: 'Title',
  popupHighlight: 'Normal',
}

g:my_lsp_servers = [
  { filetype: ['sh'], name: 'bashls', path: 'bash-language-server', args: ['start'], },
  { filetype: ['go'], name: 'gopls', path: 'gopls', args: ['serve'], },
  { filetype: ['vim'], name: 'vimls', path: 'vim-language-server', args: ['--stdio'], },
  { filetype: ['nix'], name: 'nixd', path: 'nixd', },
  { filetype: ['python'], name: 'ruff', path: 'ruff', args: ['server'], },
  { filetype: ['python'], name: 'ty', path: 'ty', args: ['server'] },
]

# Add Servers {{{
def g:AddLspServersForFiletype(ft: string)
  var servers: dict<number> = { defined: 0, added: 0 }
  for s in g:my_lsp_servers
    # TODO: s.filetype can also be a string.
    if index(s.filetype, ft) != -1
      servers.defined += 1
      if !executable(s.path)
        echomsg $"LSP {s.name} is defined for this filetype " ..
                $"but {s.path} is not in PATH."
        continue
      endif
      g:LspAddServer([s])
      servers.added += 1
    endif
  endfor

  if servers.defined > 0 && servers.added == 0
    b:lsp_server_defined_but_not_found = true
  endif
enddef

augroup LspAutoSetup
  autocmd!
  autocmd FileType * g:AddLspServersForFiletype(expand('<amatch>'))
augroup END
# }}}

# Status Line {{{
def g:LspStatusline(): string
  var s = null_string
  if lsp#lsp#ServerRunning(&filetype)
    s = $"LSP({lsp#lsp#Server().name})"

    var diags = lsp#lsp#ErrorCount()
    for [cat, cnt] in diags->items()
      if cnt > 0
        s = s .. $" {cnt} {cat[0 : 2]}"
      endif
    endfor
  endif

  if get(b:, 'lsp_server_defined_but_not_found')
    s = $"LSP ⚠ "
  endif

  return s
enddef

autocmd User LspSetup call AddToStatusLine()
def AddToStatusLine()
  &statusline = substitute(
    &statusline,
    '%=',
    '%= %#StatusLineTerm#%{LspStatusline()}%*',
    '')
enddef
# }}}

# Key Maps {{{
autocmd User LspAttached {
  nnoremap <buffer> <silent> gd <cmd>LspGotoDefinition<cr>
  nnoremap <buffer> <silent> K  <cmd>LspHover<cr>
  nnoremap <buffer> <silent> [d <cmd>LspDiag prev<cr>
  nnoremap <buffer> <silent> ]d <cmd>LspDiag next<cr>
  nnoremap <buffer> <silent> <leader>rn <cmd>LspRename<cr>
  nnoremap <buffer> <silent> <leader>ca <cmd>LspCodeAction<cr>
  nnoremap <buffer> <silent> <leader>rr <cmd>LspShowReferences<cr>
}

autocmd User LspDetached {
  silent! unmap <buffer> gd
  silent! unmap <buffer> K
  silent! unmap <buffer> [d
  silent! unmap <buffer> ]d
  silent! unmap <buffer> <leader>rn
  silent! unmap <buffer> <leader>ca
  silent! unmap <buffer> <leader>rr
}
# }}}

# vim: undofile foldmethod=marker
