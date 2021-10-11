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



function! VimGlobalSession#info( name )

    let s:file = g:VimGlobalSession . '/default_viminfo.vim'
    if a:name != ''
        let s:file = g:VimGlobalSession . '/' . a:name
    endif

    if filereadable(s:file)
        execute("rviminfo! " . s:file )
    endif

endfunction





