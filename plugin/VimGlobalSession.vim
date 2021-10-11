" VimGlobalSession
" Version: 0.0.1
" Author: 
" License: 

"if exists('g:loaded_VimGlobalSession')
"  finish
"endif
"let g:loaded_VimGlobalSession = 1

let g:VimGlobalSession=expand("~/.cache/viminfo")
command! -nargs=? -complete=customlist,CompInfo ReadInfo call VimGlobalSession#info('<args>')

command! -nargs=? RegInfoWindow call VimGlobalSession#window()


function! CompInfo(lead, line, pos )

    let s:matches = []
    let s:dir = g:VimGlobalSession
    let s:sep = fnamemodify(',' , ':p')[-1:]
    let s:Filter = { file -> !isdirectory( s:dir . s:sep . file ) }
    let s:files = readdir( s:dir , s:Filter )

    for file in s:files
        if file =~? '^' . strpart(a:lead,0)
            call add(s:matches,file)
        endif
    endfor
    return s:matches
endfunction


function! VimGlobalSession#window()
    25vs Test://
    "autocmd! WinLeave <buffer> vert resize 25
    autocmd! BufLeave <buffer> vert resize 25
    "listに載せない
    setl nobuflisted

    let s:line_num = 1
    let s:word = "anpontan"
    "書き換え
    call setbufline('Test://', s:line_num, s:word)
    "行+1に追加
    call appendbufline('Test://', s:line_num, s:word)





endfunction

function! VimGlobalSession#info( name )

    let s:file = g:VimGlobalSession . '/default_viminfo.vim'
    if a:name != ''
        let s:file = g:VimGlobalSession . '/' . a:name
    endif

    if filereadable(s:file)
        execute("rviminfo! " . s:file )
    endif

endfunction





