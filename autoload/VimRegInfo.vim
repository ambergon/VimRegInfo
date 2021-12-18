"if !exists("g:VimRegInfoDir")
"    let g:VimRegInfoDirectory=expand("~/.cache/viminfo")
"else
"    let g:VimRegInfoDirectory=expand(g:VimRegInfoDir)
"endif

if !exists("g:RegInfoWindowSize")
    let g:RegInfoWindowSize =25
endif
let s:VimRegInfoBuffer='RegInfoWindow://'


function! VimRegInfo#regInfoLoad( name )
    let l:file = g:VimRegInfoDirectory . '/default_viminfo.vim'
    if a:name != ''
        let l:file = g:VimRegInfoDirectory . '/' . a:name
    endif

    "現在のviminfoをバックアップ
    let l:backup_file = g:VimRegInfoDirectory . '/defaultbackup_viminfo.vim'
    execute("wviminfo! " . l:backup_file )
    "目的のinfofileをLoad
    if filereadable(l:file)
        execute("rviminfo! " . l:file )
    endif
    "バックアップを上書きせずにロード
    execute("rviminfo " . l:backup_file )

    call VimRegInfo#openWindow()
endfunction

function! VimRegInfo#regInfoEdit( name )
    let l:file = g:VimRegInfoDirectory . '/default_viminfo.vim'
    if a:name != ''
        let l:file = g:VimRegInfoDirectory . '/' . a:name
    endif
    if filereadable(l:file)
        execute("e " . l:file )
    endif
endfunction

function! VimRegInfo#regInfoSave( name )
    let l:file = g:VimRegInfoDirectory . '/default_viminfo.vim'
    if a:name != ''
        let l:file = g:VimRegInfoDirectory . '/' . a:name
    endif
    "vimrcで指定しているviminfoのバックアップ
    let l:backup_viminfo_setting=&viminfo
    "余計な出力を減らす努力
    set viminfo='0,/0,:0,@0,f0
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
    "復元
    eval("set viminfo=" . l:backup_viminfo_setting)
endfunction

function! VimRegInfo#regExchange(reg_name)
    let l:count = strlen(a:reg_name)
    if l:count == 1
        "引数を一文字として扱いレジスタ名に。
        "無名レジスタの中身を指定レジスタに。
        call setreg( a:reg_name, getreg(""))
        echo '* -> ' . a:reg_name
    else
        "1文字目を2文字目のレジスタに。
        call setreg( a:reg_name[1], getreg(a:reg_name[0]))
        call setreg( a:reg_name[0], [])
        echo a:reg_name[0] . ' -> ' . a:reg_name[1]
    endif
    call VimRegInfo#openWindow()
endfunction

function! VimRegInfo#regClean()
    call setreg( "",[])
    call setreg("a",[])
    call setreg("b",[])
    call setreg("c",[])
    call setreg("d",[])
    call setreg("e",[])
    call setreg("f",[])
    call setreg("g",[])
    call setreg("h",[])
    call setreg("i",[])
    call setreg("j",[])
    call setreg("k",[])
    call setreg("l",[])
    call setreg("m",[])
    call setreg("n",[])
    call setreg("o",[])
    call setreg("p",[])
    call setreg("q",[])
    call setreg("r",[])
    call setreg("s",[])
    call setreg("t",[])
    call setreg("u",[])
    call setreg("v",[])
    call setreg("w",[])
    call setreg("x",[])
    call setreg("y",[])
    call setreg("z",[])
    call VimRegInfo#openWindow()
endfunction

function! VimRegInfo#checkBufList()
    let l:list = tabpagebuflist()
    if len(l:list) == 2
        call VimRegInfo#closeWindow()
    endif
endfunction

function! VimRegInfo#closeWindow()
        autocmd! right_window
        if bufexists(s:VimRegInfoBuffer)
            execute("bw " . s:VimRegInfoBuffer)
        endif
endfunction

function! VimRegInfo#openWindow()
    if !bufexists(s:VimRegInfoBuffer)
        let l:current_winID = win_getid()

        execute(g:RegInfoWindowSize . "vs " . s:VimRegInfoBuffer)
        augroup right_window
            execute("autocmd BufLeave <buffer> vert resize " . g:RegInfoWindowSize)
            execute("autocmd VimResized <buffer> vert resize " . g:RegInfoWindowSize)
            execute("autocmd BufWinEnter <buffer> vert resize " . g:RegInfoWindowSize)
            execute("autocmd BufWinLeave <buffer> vert resize " . g:RegInfoWindowSize)
            autocmd QuitPre * call VimRegInfo#checkBufList()
            autocmd TextYankPost * call VimRegInfo#nextYankPost()
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
    call VimRegInfo#setTemplate()
endfunction

function! VimRegInfo#nextYankPost()
    augroup right_window
        autocmd SafeState * ++once call VimRegInfo#openWindow()
    augroup end
endfunction

function! VimRegInfo#setReplace(reg_name)
    let l:str = substitute(getreg(a:reg_name),"^ *","",'g')
    return l:str
endfunction

function! VimRegInfo#setTemplate()
    call setbufline(s:VimRegInfoBuffer,  1, '====================' )
    call setbufline(s:VimRegInfoBuffer,  2, '*:' . VimRegInfo#setReplace(''))
    call setbufline(s:VimRegInfoBuffer,  3, '====================' )
    call setbufline(s:VimRegInfoBuffer,  4, 'Y:' . VimRegInfo#setReplace('y'))
    call setbufline(s:VimRegInfoBuffer,  5, 'U:' . VimRegInfo#setReplace('u'))
    call setbufline(s:VimRegInfoBuffer,  6, 'I:' . VimRegInfo#setReplace('i'))
    call setbufline(s:VimRegInfoBuffer,  7, 'O:' . VimRegInfo#setReplace('o'))
    call setbufline(s:VimRegInfoBuffer,  8, 'P:' . VimRegInfo#setReplace('p'))
    call setbufline(s:VimRegInfoBuffer,  9, ' ' )
    call setbufline(s:VimRegInfoBuffer,  10, 'H:' . VimRegInfo#setReplace('h')) 
    call setbufline(s:VimRegInfoBuffer,  11, 'J:' . VimRegInfo#setReplace('j')) 
    call setbufline(s:VimRegInfoBuffer,  12, 'K:' . VimRegInfo#setReplace('k'))
    call setbufline(s:VimRegInfoBuffer,  13, 'L:' . VimRegInfo#setReplace('l'))
    call setbufline(s:VimRegInfoBuffer,  14, ' ' )
    call setbufline(s:VimRegInfoBuffer,  15, 'N:' . VimRegInfo#setReplace('n'))
    call setbufline(s:VimRegInfoBuffer,  16, 'M:' . VimRegInfo#setReplace('m'))
    call setbufline(s:VimRegInfoBuffer,  17, '====================' )
    call setbufline(s:VimRegInfoBuffer,  18, '*                  *' )
    call setbufline(s:VimRegInfoBuffer,  19, '====================' )
    call setbufline(s:VimRegInfoBuffer,  20, 'Q:' . VimRegInfo#setReplace('q'))
    call setbufline(s:VimRegInfoBuffer,  21, 'W:' . VimRegInfo#setReplace('w'))
    call setbufline(s:VimRegInfoBuffer,  22, 'E:' . VimRegInfo#setReplace('e'))
    call setbufline(s:VimRegInfoBuffer,  23, 'R:' . VimRegInfo#setReplace('r'))
    call setbufline(s:VimRegInfoBuffer,  24, 'T:' . VimRegInfo#setReplace('t'))
    call setbufline(s:VimRegInfoBuffer,  25, ' ' )
    call setbufline(s:VimRegInfoBuffer,  26, 'A:' . VimRegInfo#setReplace('a'))
    call setbufline(s:VimRegInfoBuffer,  27, 'S:' . VimRegInfo#setReplace('s'))
    call setbufline(s:VimRegInfoBuffer,  28, 'D:' . VimRegInfo#setReplace('d'))
    call setbufline(s:VimRegInfoBuffer,  29, 'F:' . VimRegInfo#setReplace('f'))
    call setbufline(s:VimRegInfoBuffer,  30, 'G:' . VimRegInfo#setReplace('g'))
    call setbufline(s:VimRegInfoBuffer,  31, ' ' )
    call setbufline(s:VimRegInfoBuffer,  32, 'Z:' . VimRegInfo#setReplace('z'))
    call setbufline(s:VimRegInfoBuffer,  33, 'X:' . VimRegInfo#setReplace('x'))
    call setbufline(s:VimRegInfoBuffer,  34, 'C:' . VimRegInfo#setReplace('c'))
    call setbufline(s:VimRegInfoBuffer,  35, 'V:' . VimRegInfo#setReplace('v'))
    call setbufline(s:VimRegInfoBuffer,  36, 'B:' . VimRegInfo#setReplace('b'))
endfunction

