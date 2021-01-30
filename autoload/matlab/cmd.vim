let s:job_id = -1
let s:job_buf_id = -1

function! s:matlab_dispatch(cmd)
  if matlab#config#AutoStart() ==# 1
    call matlab#cmd#Start()
  endif
  if s:job_id !=# -1
    if has('nvim')
      call chansend(s:job_id, a:cmd . "\r")
    elseif has('terminal')
      call term_sendkeys(s:job_buf_id, a:cmd . "\r")
    endif
  else
    echo "MATLAB is not running."
  endif
endfunction

function! matlab#cmd#Start() abort
  if s:job_id !=# -1
    return
  endif

  if has('nvim')
    function! OnExit(job_id, data, event)
      silent! exec "bdelete! " . s:job_buf_id
      let s:job_id = -1
      let s:job_buf_id = -1
    endfunction

    if matlab#config#SplitVert()
      execute "vsplit __matlab_term__"
    else
      execute "split __matlab_term__"
    end
    set nonumber
    setlocal nobuflisted
    setlocal nocursorline
    setlocal nocursorcolumn
    let s:job_id = termopen(
          \matlab#config#BinaryPath() . " " . matlab#config#BinaryFlags(),
          \{'pty': 1,
          \'on_exit': 'OnExit'})
    let s:job_buf_id = bufnr()

  elseif has('terminal')
    function! OnExit(job_id, event)
      let s:job_id = -1
      let s:job_buf_id = -1
    endfunction

    let s:job_buf_id = term_start(
          \matlab#config#BinaryPath() . " " . matlab#config#BinaryFlags(),
          \{'exit_cb': 'OnExit', 
          \'term_finish': 'close',
          \'vertical': matlab#config#SplitVert()})
    let s:job_id = 1
  endif
  normal! G 
  exe "wincmd p"
endfunction

function! matlab#cmd#Stop() abort
  if s:job_id !=# -1
    if has('nvim')
      call jobstop(s:job_id)
    elseif has('terminal')
      silent! exec "bdelete! " . s:job_buf_id
    endif
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
