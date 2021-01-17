function! matlab#config#BinaryPath() abort
  return get(g:, 'matlab_binary_path', 'matlab')
endfunction

function! matlab#config#BinaryFlags() abort
  return get(g:, 'matlab_binary_flags', '-nodisplay -nosplash')
endfunction

function! matlab#config#DocMaxHeight() abort
  return get(g:, 'matlab_doc_max_height', 20)
endfunction
