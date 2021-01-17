let s:buf_nr = -1

function! matlab#cmd#Run() abort
  silent !clear
  execute "!" . matlab#config#BinaryPath() . " " . matlab#config#BinaryFlags() . " -r \"run('" . expand('%') . "'); exit;\" | tail +11"
endfunction

function! matlab#cmd#Describe() abort
  silent !clear
  let content = system(matlab#config#BinaryPath() . " " . matlab#config#BinaryFlags() . " -r \"help '" . expand("<cword>") . "'; exit;\" | tail +11")

  let is_visible = bufexists(s:buf_nr) && bufwinnr(s:buf_nr) != -1
  if !bufexists(s:buf_nr)
    execute "new"
    sil file `="[matlabdoc]"`
    let s:buf_nr = bufnr('%')
  elseif bufwinnr(s:buf_nr) == -1
    execute "split"
    execute s:buf_nr . 'buffer'
  elseif bufwinnr(s:buf_nr) != bufwinnr('%')
    execute bufwinnr(s:buf_nr) . 'wincmd w'
  endif

  if !is_visible
    let max_height = matlab#config#DocMaxHeight()
    let content_height = len(split(content, "\n"))
    if content_height > max_height
      exe 'resize ' . max_height
    else
      exe 'resize ' . content_height
    endif
  endif

  setlocal filetype=matlabdoc
  setlocal bufhidden=delete
  setlocal buftype=nofile
  setlocal noswapfile
  setlocal nobuflisted
  setlocal nocursorline
  setlocal nocursorcolumn
  setlocal iskeyword+=:
  setlocal iskeyword-=-

  setlocal modifiable
  %delete _
  call append(0, split(content, "\n"))
  sil $delete _
  setlocal nomodifiable
  sil normal! gg

  noremap <buffer> <silent> <CR> :<C-U>close<CR>
  noremap <buffer> <silent> <Esc> :<C-U>close<CR>
  nnoremap <buffer> <silent> <Esc>[ <Esc>[
endfunction
