let s:job_id = -1
let s:job_buf_id = -1

function! s:matlab_dispatch(cmd)
  if matlab#config#AutoStart() ==# 1
    call matlab#cmd#Start()
  endif
  if s:job_id !=# -1
    call chansend(s:job_id, a:cmd . "\r")
  else
    echo "MATLAB is not running."
  endif
endfunction

function! matlab#cmd#Start() abort
  function! OnExit(job_id, data, event)
    silent! exec "bdelete! " . s:job_buf_id
    let s:job_id = -1
    let s:job_buf_id = -1
  endfunction

  if s:job_id ==# -1
    execute matlab#config#TermMode() . " __matlab_term__"
    set nonumber
    setlocal nobuflisted
    setlocal nocursorline
    setlocal nocursorcolumn
    let s:job_id = termopen(
          \matlab#config#BinaryPath() . " " . matlab#config#BinaryFlags(),
          \{'pty': 1,
          \'on_exit': 'OnExit'})
    let s:job_buf_id = bufnr()
    normal! G 
    exe "wincmd p"
  end
endfunction

function! matlab#cmd#Stop() abort
  if s:job_id !=# -1
    call jobstop(s:job_id)
  end
endfunction

function! matlab#cmd#Command(command) abort
  call s:matlab_dispatch(a:command)
endfunction

function! matlab#cmd#Run() abort
  call s:matlab_dispatch("run('" . expand('%') . "')")
endfunction

function! matlab#cmd#Describe() abort
  call s:matlab_dispatch("help '" . expand("<cword>") . "'")
endfunction
