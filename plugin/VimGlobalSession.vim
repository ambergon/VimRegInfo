" VimGlobalSession
" Version: 0.0.1
" Author: 
" License: 

"if exists('g:loaded_VimGlobalSession')
"  finish
"endif
"let g:loaded_VimGlobalSession = 1

let g:VimGlobalSession=expand("~/.cache/viminfo")
let g:VimGlobalSessionBuffer='RegInfoWindow://'
"let g:VimGlobalSessionBuffer='VimGlobalSession://Buffer'

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

function! VimGlobalSession#anko()
    echo "anko"
endfunction




function! VimGlobalSession#window()
    
    "g:の変数が聞かない。。
    "25vs g:VimGlobalSessionBuffer
    if !bufexists(g:VimGlobalSessionBuffer)
        25vs RegInfoWindow://
    endif

    autocmd! BufLeave <buffer> vert resize 25
    autocmd! VimResized <buffer> vert resize 25
    "autocmd! BufWinLeave <buffer> vert resize 25

    "call setreg("key","value)
    "getreg("a")
    "getreginfo("a")
    "getregtype("a")

    "listに載せない
    setl nobuflisted
    "折り返さない
    setl nowrap
    setl bufhidden=delete
    setl buftype=nowrite

    "書き換え
    call setbufline(g:VimGlobalSessionBuffer,  1, '====================' )
    call setbufline(g:VimGlobalSessionBuffer,  2, '*:' . VimGlobalSession#line('*'))
    call setbufline(g:VimGlobalSessionBuffer,  3, '====================' )

    call setbufline(g:VimGlobalSessionBuffer,  4, 'Y:' . VimGlobalSession#line('y'))
    call setbufline(g:VimGlobalSessionBuffer,  5, 'U:' . VimGlobalSession#line('u'))
    call setbufline(g:VimGlobalSessionBuffer,  6, 'I:' . VimGlobalSession#line('i'))
    call setbufline(g:VimGlobalSessionBuffer,  7, 'O:' . VimGlobalSession#line('o'))
    call setbufline(g:VimGlobalSessionBuffer,  8, 'P:' . VimGlobalSession#line('p'))

    call setbufline(g:VimGlobalSessionBuffer,  9, '====================' )

    call setbufline(g:VimGlobalSessionBuffer, 10, 'H:' . VimGlobalSession#line('h')) 
    call setbufline(g:VimGlobalSessionBuffer, 11, 'J:' . VimGlobalSession#line('j')) 
    call setbufline(g:VimGlobalSessionBuffer, 12, 'K:' . VimGlobalSession#line('k'))
    call setbufline(g:VimGlobalSessionBuffer, 13, 'L:' . VimGlobalSession#line('l'))

    call setbufline(g:VimGlobalSessionBuffer, 14, '====================' )

    call setbufline(g:VimGlobalSessionBuffer, 15, 'N:' . VimGlobalSession#line('n'))
    call setbufline(g:VimGlobalSessionBuffer, 16, 'M:' . VimGlobalSession#line('m'))

    call setbufline(g:VimGlobalSessionBuffer, 17, '====================' )
    call setbufline(g:VimGlobalSessionBuffer, 18, '====================' )
    "call appendbufline('Test://', 0, s:word)
    "call setbufline('Test://', 0, 'anko')
endfunction


function! VimGlobalSession#line(reg_name)
    let s:str = substitute(getreg(a:reg_name),"^ *","",'g')
    return s:str
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


""nomal
""困ったことに、autocmd TextYankPostではsetbuflistが動かせない。。。
""nnoremap <expr> q<space> VimGlobalSession#anko()
"autocmd! TextYankPost * let g:VimGlobalSessionEvent = deepcopy(v:event) | call VimGlobalSession#do(g:VimGlobalSessionEvent)
"
"function! VimGlobalSession#do(list)
"    echo a:list
"    call setbufline(g:VimGlobalSessionBuffer, 17, '====================' )
"    if a:list["regname"] == ''
"       call setbufline(g:VimGlobalSessionBuffer,  2, '*:' . VimGlobalSession#line('*'))
"    elseif a:list["regname"] == 'y'
"        call setbufline(g:VimGlobalSessionBuffer,  4, 'Y:' . VimGlobalSession#line('y'))
"    elseif a:list["regname"] == 'u'
"        call setbufline(g:VimGlobalSessionBuffer,  5, 'U:' . VimGlobalSession#line('u'))
"    elseif a:list["regname"] == 'i'
"        call setbufline(g:VimGlobalSessionBuffer,  6, 'I:' . VimGlobalSession#line('i'))
"    elseif a:list["regname"] == 'o'
"        call setbufline(g:VimGlobalSessionBuffer,  7, 'O:' . VimGlobalSession#line('o'))
"    elseif a:list["regname"] == 'p'
"        call setbufline(g:VimGlobalSessionBuffer,  8, 'P:' . VimGlobalSession#line('p'))
"
"
"    elseif a:list["regname"] == 'h'
"        call setbufline(g:VimGlobalSessionBuffer, 10, 'H:' . VimGlobalSession#line('h')) 
"    elseif a:list["regname"] == 'j'
"        call setbufline(g:VimGlobalSessionBuffer, 11, 'J:' . VimGlobalSession#line('j')) 
"    elseif a:list["regname"] == 'k'
"        call setbufline(g:VimGlobalSessionBuffer, 12, 'K:' . VimGlobalSession#line('k'))
"    elseif a:list["regname"] == 'l'
"        call setbufline(g:VimGlobalSessionBuffer, 13, 'L:' . VimGlobalSession#line('l'))
"
"
"    elseif a:list["regname"] == 'n'
"        call setbufline(g:VimGlobalSessionBuffer, 15, 'N:' . VimGlobalSession#line('n'))
"    elseif a:list["regname"] == 'm'
"        call setbufline(g:VimGlobalSessionBuffer, 16, 'M:' . VimGlobalSession#line('m'))
"    else
"        echo a:list
"    endif
"endfunction


