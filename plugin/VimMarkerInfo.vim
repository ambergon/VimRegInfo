"""setting
"let g:marker_window_local = 'abcde'
"let g:marker_window_global = 'ABCDE'
"let g:mark_replace = [["","",""],["","","g"]]

if exists('g:loaded_VimMarkerInfo')
  finish
endif
let g:loaded_VimMarkerInfo = 1

let g:local_list ='abcdefghijklmnopqrstuvwxyz'
let g:global_list ='ABCDEFGHIJKLMNOPQRSTUVWXYZ'
let g:VimMarkerInfoBuffer ='MarkerInfoWindow://'

if !exists("g:marker_window_local")
    let g:marker_window_local=g:local_list
endif
if !exists("g:marker_window_global")
    let g:marker_window_global=g:global_list
endif

if !exists("g:mark_replace")
    let g:mark_replace =[["","",""]]
endif


command! -nargs=0 MarkerInfo call VimMarkerInfo#setWindow()
command! -nargs=0 MarkerInfoOff call VimMarkerInfo#closeWindow()

augroup VimMarkerInfoSetup
    autocmd VimEnter * call VimMarkerInfo#setup()
augroup end

"function! VimMarkerInfo#quitBuffer()
"    let l:list = tabpagebuflist()
"    if len(l:list) == 2
"        if bufexists(g:VimMarkerInfoBuffer)
"            call VimMarkerInfo#closeWindow()
"        endif
"    endif
"endfunction

function! VimMarkerInfo#closeWindow()
    call sign_unplace( 'local_group')
    call sign_unplace( 'global_group')
    autocmd! left_window
    autocmd! VimMarkerInfo
    if bufexists(g:VimMarkerInfoBuffer)
        execute("bw " . g:VimMarkerInfoBuffer)
    endif
endfunction

function! VimMarkerInfo#setWindow()
    call VimMarkerInfo#openMarkerWindow()
    call VimMarkerInfo#signSet()
    augroup VimMarkerInfo
        autocmd bufEnter * call VimMarkerInfo#signSet()
        autocmd bufWinEnter * call VimMarkerInfo#openMarkerWindow()
        autocmd WinEnter * call VimMarkerInfo#openMarkerWindow()
        autocmd InsertLeave * call VimMarkerInfo#openMarkerWindow() | call VimMarkerInfo#signSet()
    augroup end
endfunction


function! VimMarkerInfo#setup()
    call VimMarkerInfo#setHighLight()
    "call VimMarkerInfo#openMarkerWindow()
endfunction

function! VimMarkerInfo#openMarkerWindow()
    if !bufexists(g:VimMarkerInfoBuffer)
        let l:current_winID = win_getid()
        execute("aboveleft 30vs " . g:VimMarkerInfoBuffer)

        augroup left_window
            autocmd BufLeave <buffer> vert resize 30
            autocmd VimResized <buffer> vert resize 30
            autocmd BufWinLeave <buffer> vert resize 30
            autocmd BufWinEnter <buffer> vert resize 30
            "autocmd QuitPre * call VimMarkerInfo#quitBuffer()
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
    call VimMarkerInfo#windowAppendLines()
endfunction

function! VimMarkerInfo#Replace( text )
    let l:res = a:text
    let l:res = substitute( l:res ,"^ *","",'')
    for l:replace in g:mark_replace
        let l:res = substitute( l:res ,replace[0],replace[1],replace[2])
    endfor
    return l:res
endfunction

function! VimMarkerInfo#windowLocalMark(word)
    let l:line = VimMarkerInfo#Replace(getline(getpos("'" . a:word)[1]))
    return a:word . ":" . l:line
endfunction

function! VimMarkerInfo#windowGlobalMark(word)
    let l:line = bufname(getpos("'" . a:word)[0])
    return a:word . ":" . l:line
endfunction

function! VimMarkerInfo#windowAppendLines()
    "clean
    call deletebufline(g:VimMarkerInfoBuffer,1,"$")
    
    ""local
    let l:x=0
    for l:local_word in g:marker_window_local
        if getpos("'" . l:local_word)[1] != 0
            let l:x = l:x+1
            call setbufline(g:VimMarkerInfoBuffer,  l:x, VimMarkerInfo#windowLocalMark(l:local_word))
        endif
    endfor
    let l:x = l:x+1
    call setbufline(g:VimMarkerInfoBuffer,  l:x, "=============================")
    ""global
    for l:global_word in g:marker_window_global
        if getpos("'" . l:global_word)[1] != 0
            let l:x = l:x+1
            call setbufline(g:VimMarkerInfoBuffer,  l:x, VimMarkerInfo#windowGlobalMark(l:global_word))
        endif
    endfor
endfunction

function! VimMarkerInfo#signSet()
    ""すべて解除
    call sign_unplace( 'local_group')
    call sign_unplace( 'global_group')
    
    for l:local_word in g:local_list
        if getpos("'" . l:local_word)[1] != 0
            call sign_place( 0, 'local_group', 'local_' . l:local_word, bufnr(),{'lnum' : getpos("'" . l:local_word)[1], 'priority' : 10 })
        endif
    endfor
    
    ""global_mark
    for l:global_word in g:global_list
        "getpos = 0行 = 未設定 だとエラー
        if getpos("'" . l:global_word)[1] != 0
            "getBufnum = current
            if getpos("'" . l:global_word)[0] == bufnr()
                call sign_place( 0, 'global_group', 'global_' . l:global_word, bufnr(),{'lnum' : getpos("'" . l:global_word)[1], 'priority' : 20 })
            endif
        endif
    endfor
endfunction

function! VimMarkerInfo#setHighLight()
    ""local_markの色を定義
    hi LocalMark ctermfg=254 ctermbg=242 guifg=#e4e4e4 guibg=#666666
    ""global_markの色を定義
    hi GlobalMark ctermfg=113 ctermbg=175 guifg=#87df5f guibg=#df87af

    "local_mark
    for s:local_word in g:local_list
        call sign_define("local_" . s:local_word,{"text" : s:local_word . ">", "texthl" : "LocalMark"})
    endfor
    "global_mark
    for l:global_word in g:global_list
        call sign_define("global_" . l:global_word,{"text" : l:global_word . ">", "texthl" : "GlobalMark"})
    endfor
endfunction

""""vim info
""Global
"# File marks:
""Local
"# History of marks within files (newest to oldest):

