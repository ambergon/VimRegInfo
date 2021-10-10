" VimGlobalSession
" Version: 0.0.1
" Author: 
" License: 

"if exists('g:loaded_VimGlobalSession')
"  finish
"endif
"let g:loaded_VimGlobalSession = 1


function! CompInfo(lead, line, pos )
    let s:dir = expand("~/.cache/viminfo")
    let s:sep = fnamemodify(',' , ':p')[-1:]
    let s:Filter = { file -> !isdirectory( s:dir . s:sep . file ) }
    let s:files = readdir( s:dir , s:Filter )
    echo s:files
    return s:files
    "return [ 'aaa' , 'bbb' ]
    "return "koko,anko"
endfunction


command! -nargs=1 -complete=file,CompInfo ReadInfo call VimGlobalSession#info('<f-args>')
"command! -nargs=1 -complete=customlist,CompInfo ReadInfo call VimGlobalSession#info('<f-args>')
function! VimGlobalSession#info( name )
    echo a:name

    "let s:anko = readdir(s:dir)
    "echo s:dir
    "call setline(1,files)

endfunction

