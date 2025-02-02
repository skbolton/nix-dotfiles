function! MyFoldText()
    let line = getline(v:foldstart)
    if strpart(line, 0, 4) == "    "
      return '   ' . strpart(line, 4)
    else
      return '   ' . line
    endif
endfunction

set foldtext=MyFoldText()
