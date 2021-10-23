" Author: ambergon
" License: 
" Version: 0.0.1
" VimSelectInfo

if exists('g:loaded_VimSelectInfo')
  finish
endif
let g:loaded_VimSelectInfo = 1

""setting
"viminfoを管理するディレクトリ
"let g:VimSelectInfoDir="~/.cache/viminfo"
"1で自動起動
"let g:VimSelectInfoAutoStart = 1
"サイズ指定
"let g:SelectInfoWindowSize =25

if !exists("g:VimSelectInfoDir")
    let s:VimSelectInfo=expand("~/.cache/viminfo")
else
    let s:VimSelectInfo=expand(g:VimSelectInfoDir)
endif

if !exists("g:SelectInfoWindowSize")
    let g:SelectInfoWindowSize =25
endif



let s:VimSelectInfoBuffer='RegInfoWindow://'


command! -nargs=? -complete=customlist,CompInfo SelectInfo call VimSelectInfo#selectInfo('<args>')
command! -nargs=? -complete=customlist,CompInfo SelectInfoEdit call VimSelectInfo#selectInfoEdit('<args>')
command! -nargs=? -complete=customlist,CompInfo SelectInfoSave call VimSelectInfo#selectInfoSave('<args>')

command! -nargs=0 RegInfoWindow call VimSelectInfo#openWindow()
command! -nargs=0 RegInfoWindowClean call VimSelectInfo#regClean()
command! -nargs=1 RegExchange call VimSelectInfo#regExchange(<f-args>)

function! CompInfo(lead, line, pos )
    let l:matches = []
    let l:dir = s:VimSelectInfo
    let l:sep = fnamemodify(',' , ':p')[-1:]
    let l:Filter = { file -> !isdirectory( l:dir . l:sep . file ) }
    let l:files = readdir( l:dir , l:Filter )

    for file in l:files
        if file =~? '^' . strpart(a:lead,0)
            call add(l:matches,file)
        endif
    endfor
    return l:matches
endfunction

function! VimSelectInfo#selectInfo( name )
    let l:file = s:VimSelectInfo . '/default_viminfo.vim'
    if a:name != ''
        let l:file = s:VimSelectInfo . '/' . a:name
    endif
    if filereadable(l:file)
        execute("rviminfo! " . l:file )
    endif
    call VimSelectInfo#openWindow()
endfunction

function! VimSelectInfo#selectInfoEdit( name )
    let l:file = s:VimSelectInfo . '/default_viminfo.vim'
    if a:name != ''
        let l:file = s:VimSelectInfo . '/' . a:name
    endif
    if filereadable(l:file)
        execute("e " . l:file )
    endif
endfunction

function! VimSelectInfo#selectInfoSave( name )
    let l:file = s:VimSelectInfo . '/default_viminfo.vim'
    if a:name != ''
        let l:file = s:VimSelectInfo . '/' . a:name
    endif
    if filereadable(l:file)
        echo 'overwrite? y / other'
        let l:c = getcharstr()
        if l:c == 'Y' || l:c == 'y'
            execute("wviminfo! " . l:file )
            echo 'done'
        else
            echo 'do not'
        endif
    else
        execute("wviminfo! " . l:file )
    endif
endfunction

function! VimSelectInfo#regExchange(reg_name)
    let l:count = strlen(a:reg_name)
    if l:count == 1
        "引数を一文字として扱いレジスタ名に。
        "無名レジスタの中身を指定レジスタに。
        call setreg( a:reg_name, getreg("*"))
        echo '* -> ' . a:reg_name
    else
        "２文字目を一文字目のレジスタに。
        call setreg( a:reg_name[1], getreg(a:reg_name[0]))
        echo a:reg_name[0] . ' -> ' . a:reg_name[1]
    endif
    call VimSelectInfo#openWindow()
endfunction

function! VimSelectInfo#regClean()
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
    call VimSelectInfo#openWindow()
endfunction
function! VimSelectInfo#checkBufList()
    let l:list = tabpagebuflist()
    if len(l:list) == 2
        if bufexists(s:VimSelectInfoBuffer)
            execute("bw " . s:VimSelectInfoBuffer)
        endif
    "elseif len(l:list) == 3
    "    if bufexists(s:VimSelectInfoBuffer) && bufexists(g:VimMarkerInfoBuffer)
    "        echo ''
    "        execute("bw " . s:VimSelectInfoBuffer)
    "        execute("bw " . g:VimMarkerInfoBuffer)
    "    endif
    endif
endfunction

function! VimSelectInfo#openWindow()
    if !bufexists(s:VimSelectInfoBuffer)
        let l:current_winID = win_getid()

        execute(g:SelectInfoWindowSize . "vs " . s:VimSelectInfoBuffer)
        augroup right_window
            execute("autocmd BufLeave <buffer> vert resize " . g:SelectInfoWindowSize)
            execute("autocmd VimResized <buffer> vert resize " . g:SelectInfoWindowSize)
            execute("autocmd BufWinEnter <buffer> vert resize " . g:SelectInfoWindowSize)
            execute("autocmd BufWinLeave <buffer> vert resize " . g:SelectInfoWindowSize)
            autocmd QuitPre * call VimSelectInfo#checkBufList()
            autocmd TextYankPost * call VimSelectInfo#nextYankPost()
        augroup end

        "qで終了
        nnoremap <buffer> q :q<CR>
        "listに載せない
        setl nobuflisted
        "折り返さない
        setl nowrap
        setl nonumber
        setl norelativenumber
        setl buftype=nowrite
        "bufexist
        setl bufhidden=wipe
        call win_gotoid(l:current_winID)
    endif
    call VimSelectInfo#setTemplate()
endfunction

function! VimSelectInfo#setReplace(reg_name)
    let l:str = substitute(getreg(a:reg_name),"^ *","",'g')
    return l:str
endfunction

function! VimSelectInfo#setTemplate()
    call setbufline(s:VimSelectInfoBuffer,  1, '====================' )
    call setbufline(s:VimSelectInfoBuffer,  2, '*:' . VimSelectInfo#setReplace('*'))
    call setbufline(s:VimSelectInfoBuffer,  3, '====================' )
    call setbufline(s:VimSelectInfoBuffer,  4, 'Y:' . VimSelectInfo#setReplace('y'))
    call setbufline(s:VimSelectInfoBuffer,  5, 'U:' . VimSelectInfo#setReplace('u'))
    call setbufline(s:VimSelectInfoBuffer,  6, 'I:' . VimSelectInfo#setReplace('i'))
    call setbufline(s:VimSelectInfoBuffer,  7, 'O:' . VimSelectInfo#setReplace('o'))
    call setbufline(s:VimSelectInfoBuffer,  8, 'P:' . VimSelectInfo#setReplace('p'))
    call setbufline(s:VimSelectInfoBuffer,  9, ' ' )
    call setbufline(s:VimSelectInfoBuffer,  10, 'H:' . VimSelectInfo#setReplace('h')) 
    call setbufline(s:VimSelectInfoBuffer,  11, 'J:' . VimSelectInfo#setReplace('j')) 
    call setbufline(s:VimSelectInfoBuffer,  12, 'K:' . VimSelectInfo#setReplace('k'))
    call setbufline(s:VimSelectInfoBuffer,  13, 'L:' . VimSelectInfo#setReplace('l'))
    call setbufline(s:VimSelectInfoBuffer,  14, ' ' )
    call setbufline(s:VimSelectInfoBuffer,  15, 'N:' . VimSelectInfo#setReplace('n'))
    call setbufline(s:VimSelectInfoBuffer,  16, 'M:' . VimSelectInfo#setReplace('m'))
    call setbufline(s:VimSelectInfoBuffer,  17, '====================' )
    call setbufline(s:VimSelectInfoBuffer,  18, '*                  *' )
    call setbufline(s:VimSelectInfoBuffer,  19, '====================' )
    call setbufline(s:VimSelectInfoBuffer,  20, 'Q:' . VimSelectInfo#setReplace('q'))
    call setbufline(s:VimSelectInfoBuffer,  21, 'W:' . VimSelectInfo#setReplace('w'))
    call setbufline(s:VimSelectInfoBuffer,  22, 'E:' . VimSelectInfo#setReplace('e'))
    call setbufline(s:VimSelectInfoBuffer,  23, 'R:' . VimSelectInfo#setReplace('r'))
    call setbufline(s:VimSelectInfoBuffer,  24, 'T:' . VimSelectInfo#setReplace('t'))
    call setbufline(s:VimSelectInfoBuffer,  25, ' ' )
    call setbufline(s:VimSelectInfoBuffer,  26, 'A:' . VimSelectInfo#setReplace('a'))
    call setbufline(s:VimSelectInfoBuffer,  27, 'S:' . VimSelectInfo#setReplace('s'))
    call setbufline(s:VimSelectInfoBuffer,  28, 'D:' . VimSelectInfo#setReplace('d'))
    call setbufline(s:VimSelectInfoBuffer,  29, 'F:' . VimSelectInfo#setReplace('f'))
    call setbufline(s:VimSelectInfoBuffer,  30, 'G:' . VimSelectInfo#setReplace('g'))
    call setbufline(s:VimSelectInfoBuffer,  31, ' ' )
    call setbufline(s:VimSelectInfoBuffer,  32, 'Z:' . VimSelectInfo#setReplace('z'))
    call setbufline(s:VimSelectInfoBuffer,  33, 'X:' . VimSelectInfo#setReplace('x'))
    call setbufline(s:VimSelectInfoBuffer,  34, 'C:' . VimSelectInfo#setReplace('c'))
    call setbufline(s:VimSelectInfoBuffer,  35, 'V:' . VimSelectInfo#setReplace('v'))
    call setbufline(s:VimSelectInfoBuffer,  36, 'B:' . VimSelectInfo#setReplace('b'))
endfunction

function! VimSelectInfo#nextYankPost()
    augroup VimSelectInfo
        autocmd SafeState * ++once call VimSelectInfo#openWindow()
    augroup end
endfunction

if exists("g:VimSelectInfoAutoStart")
    if g:VimSelectInfoAutoStart == 1
        call VimSelectInfo#openWindow()
    endif
endif

"autocmd! TextYankPost * let g:VimSelectInfoEvent = deepcopy(v:event) | call VimSelectInfo#do(g:VimSelectInfoEvent)
