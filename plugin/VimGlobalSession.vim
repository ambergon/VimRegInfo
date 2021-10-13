" Author: ambergon
" License: 
" Version: 0.0.1
" VimGlobalSession

"if exists('g:loaded_VimGlobalSession')
"  finish
"endif
"let g:loaded_VimGlobalSession = 1

"vs bufname...
let g:VimGlobalSessionBuffer='RegInfoWindow://'
"viminfoを管理するディレクトリ
let g:VimGlobalSession=expand("~/.cache/viminfo")

let g:VimGlobalSessionAutoStart = 1


autocmd! TextYankPost * call VimGlobalSession#setAutocmd()

command! -nargs=? -complete=customlist,CompInfo ReadInfo call VimGlobalSession#info('<args>')
command! -nargs=? RegInfoWindow call VimGlobalSession#setWindow()
command! -nargs=? RegInfoWindowClean call VimGlobalSession#regClean()

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
    call VimGlobalSession#setTemplate()
endfunction

function! VimGlobalSession#regClean()
    call setreg("*","")
    call setreg("a","")
    call setreg("b","")
    call setreg("c","")
    call setreg("d","")
    call setreg("e","")
    call setreg("f","")
    call setreg("g","")
    call setreg("h","")
    call setreg("i","")
    call setreg("j","")
    call setreg("k","")
    call setreg("l","")
    call setreg("m","")
    call setreg("n","")
    call setreg("o","")
    call setreg("p","")
    call setreg("q","")
    call setreg("r","")
    call setreg("s","")
    call setreg("t","")
    call setreg("u","")
    call setreg("v","")
    call setreg("w","")
    call setreg("x","")
    call setreg("y","")
    call setreg("z","")
    call VimGlobalSession#setTemplate()
endfunction

function! VimGlobalSession#setAutocmd()
    autocmd! SafeState * ++once call VimGlobalSession#setWindow()
endfunction

function! VimGlobalSession#setWindow()
    if !bufexists(g:VimGlobalSessionBuffer)
        let s:current_winID = win_getid()

        "25vs g:VimGlobalSessionBuffer
        25vs RegInfoWindow://
        "autocmd! BufWinLeave <buffer> vert resize 25
        autocmd! BufLeave <buffer> vert resize 25
        autocmd! VimResized <buffer> vert resize 25
        "qで終了
        nnoremap <buffer> q :q<CR>
        "listに載せない
        setl nobuflisted
        "折り返さない
        setl nowrap
        setl nonumber
        setl norelativenumber
        setl buftype=nowrite
        "    if !bufloaded(g:VimGlobalSessionBuffer)
        "    endif
        
        call win_gotoid(s:current_winID)
    endif
    call VimGlobalSession#setTemplate()
endfunction

function! VimGlobalSession#setReplace(reg_name)
    let s:str = substitute(getreg(a:reg_name),"^ *","",'g')
    return s:str
endfunction

function! VimGlobalSession#setTemplate()
    ""#レジスタ
    "以前いたbuffer
    ""%レジスタ
    "今いるbuffer
    "".レジスタ
    "さっき記入した文字群
    "":レジスタ
    "さっき実行したコマンド[:]は入力されない

    call setbufline(g:VimGlobalSessionBuffer,  1, '====================' )
    call setbufline(g:VimGlobalSessionBuffer,  2, '*:' . VimGlobalSession#setReplace('*'))
    call setbufline(g:VimGlobalSessionBuffer,  3, '====================' )
    call setbufline(g:VimGlobalSessionBuffer,  4, 'Y:' . VimGlobalSession#setReplace('y'))
    call setbufline(g:VimGlobalSessionBuffer,  5, 'U:' . VimGlobalSession#setReplace('u'))
    call setbufline(g:VimGlobalSessionBuffer,  6, 'I:' . VimGlobalSession#setReplace('i'))
    call setbufline(g:VimGlobalSessionBuffer,  7, 'O:' . VimGlobalSession#setReplace('o'))
    call setbufline(g:VimGlobalSessionBuffer,  8, 'P:' . VimGlobalSession#setReplace('p'))
    call setbufline(g:VimGlobalSessionBuffer,  9, ' ' )
    call setbufline(g:VimGlobalSessionBuffer,  10, 'H:' . VimGlobalSession#setReplace('h')) 
    call setbufline(g:VimGlobalSessionBuffer,  11, 'J:' . VimGlobalSession#setReplace('j')) 
    call setbufline(g:VimGlobalSessionBuffer,  12, 'K:' . VimGlobalSession#setReplace('k'))
    call setbufline(g:VimGlobalSessionBuffer,  13, 'L:' . VimGlobalSession#setReplace('l'))
    call setbufline(g:VimGlobalSessionBuffer,  14, ' ' )
    call setbufline(g:VimGlobalSessionBuffer,  15, 'N:' . VimGlobalSession#setReplace('n'))
    call setbufline(g:VimGlobalSessionBuffer,  16, 'M:' . VimGlobalSession#setReplace('m'))
    call setbufline(g:VimGlobalSessionBuffer,  17, '====================' )
    call setbufline(g:VimGlobalSessionBuffer,  18, '*                  *' )
    call setbufline(g:VimGlobalSessionBuffer,  19, '====================' )
    call setbufline(g:VimGlobalSessionBuffer,  20, 'Q:' . VimGlobalSession#setReplace('q'))
    call setbufline(g:VimGlobalSessionBuffer,  21, 'W:' . VimGlobalSession#setReplace('w'))
    call setbufline(g:VimGlobalSessionBuffer,  22, 'E:' . VimGlobalSession#setReplace('e'))
    call setbufline(g:VimGlobalSessionBuffer,  23, 'R:' . VimGlobalSession#setReplace('r'))
    call setbufline(g:VimGlobalSessionBuffer,  24, 'T:' . VimGlobalSession#setReplace('t'))
    call setbufline(g:VimGlobalSessionBuffer,  25, 'A:' . VimGlobalSession#setReplace('a'))
    call setbufline(g:VimGlobalSessionBuffer,  26, 'S:' . VimGlobalSession#setReplace('s'))
    call setbufline(g:VimGlobalSessionBuffer,  27, 'D:' . VimGlobalSession#setReplace('d'))
    call setbufline(g:VimGlobalSessionBuffer,  28, 'F:' . VimGlobalSession#setReplace('f'))
    call setbufline(g:VimGlobalSessionBuffer,  29, 'G:' . VimGlobalSession#setReplace('g'))
    call setbufline(g:VimGlobalSessionBuffer,  30, 'Z:' . VimGlobalSession#setReplace('z'))
    call setbufline(g:VimGlobalSessionBuffer,  31, 'X:' . VimGlobalSession#setReplace('x'))
    call setbufline(g:VimGlobalSessionBuffer,  32, 'C:' . VimGlobalSession#setReplace('c'))
    call setbufline(g:VimGlobalSessionBuffer,  33, 'V:' . VimGlobalSession#setReplace('v'))
    call setbufline(g:VimGlobalSessionBuffer,  34, 'B:' . VimGlobalSession#setReplace('b'))
endfunction
if g:VimGlobalSessionAutoStart == 1
    call VimGlobalSession#setWindow()
endif

""困ったことに、autocmd TextYankPostではsetbuflistが動かせない。。。
"autocmd! TextYankPost * let g:VimGlobalSessionEvent = deepcopy(v:event) | call VimGlobalSession#do(g:VimGlobalSessionEvent)
"function! VimGlobalSession#do(list)
"    if a:list["regname"] == ''
"        echo a:list
"endfunction

    "25vs RegInfoWindow://
    "call appendbufline('Test://', 0, s:word)
    "call setbufline('Test://', 0, 'anko')
    "call setreg("key","value)
    "getregtype("a")

