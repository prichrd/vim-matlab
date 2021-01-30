function! matlab#config#BinaryPath() abort
  return get(g:, 'matlab_binary_path', 'matlab')
endfunction

function! matlab#config#BinaryFlags() abort
  return get(g:, 'matlab_binary_flags', '-nodesktop -nosplash')
endfunction

function! matlab#config#AutoStart() abort
  return get(g:, 'matlab_auto_start', 1)
endfunction

function! matlab#config#SplitVert() abort
  return get(g:, 'matlab_split_vert', 0)
endfunction
