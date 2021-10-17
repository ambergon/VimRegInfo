"""setting
"
"g:marker_window = ''
"

let g:local_list ='abcdefghijklmnopqrstuvwxyz'
let g:global_list ='ABCDEFGHIJKLMNOPQRSTUVWXYZ'
let s:left_buffer_name ='TEST://MARKERS'

if !exists("g:marker_window")
    let g:marker_window=g:local_list
endif


command! -nargs=0 MarkStart call VimMarkds#startup()
autocmd! vimEnter * call VimMarkds#startup()

autocmd! bufWinEnter * call VimMarkds#openMarkerWindow()
autocmd! WinEnter * call VimMarkds#openMarkerWindow()
"autocmd! bufEnter * call VimMarkds#openMarkerWindow()
"autocmd! InsertLeave * call VimMarkds#openMarkerWindow()

autocmd! bufEnter * call VimMarkds#signSet()
autocmd! InsertLeave * call VimMarkds#signSet()

function! VimMarkds#startup()
    call VimMarkds#setHighLight()
    call VimMarkds#openMarkerWindow()
endfunction

function! VimMarkds#openMarkerWindow()
    if !bufexists(s:left_buffer_name)
        let l:current_winID = win_getid()
        execute("aboveleft 30vs " . s:left_buffer_name)

        autocmd! BufLeave <buffer> vert resize 30
        autocmd! VimResized <buffer> vert resize 30

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
    call VimMarkds#windowAppendLines()
endfunction

function! VimMarkds#Replace( text )
    let l:res = a:text
    let l:res = substitute( l:res ,"^ *","",'')
    let l:res = substitute( l:res ,"^function","F",'')
    return l:res
endfunction

function! VimMarkds#windowLocalMark(word)
    let l:line = VimMarkds#Replace(getline(getpos("'" . a:word)[1]))
    return a:word . ":" . l:line
endfunction

function! VimMarkds#windowGlobalMark(word)
    let l:line = bufname(getpos("'" . a:word)[0])
    return a:word . ":" . l:line
endfunction

function! VimMarkds#windowAppendLines()
    "clean
    call deletebufline(s:left_buffer_name,1,"$")
    
    ""local
    let l:x=0
    for l:local_word in g:marker_window
        if getpos("'" . l:local_word)[1] != 0
            let l:x = l:x+1
            call setbufline(s:left_buffer_name,  l:x, VimMarkds#windowLocalMark(l:local_word))
        endif
    endfor
    let l:x = l:x+1
    call setbufline(s:left_buffer_name,  l:x, "=============================")
    ""global
    for l:global_word in g:global_list
        if getpos("'" . l:global_word)[1] != 0
            let l:x = l:x+1
            call setbufline(s:left_buffer_name,  l:x, VimMarkds#windowGlobalMark(l:global_word))
        endif
    endfor
endfunction

"set sign
function! VimMarkds#signSet()
    ""すべて解除
    call sign_unplace( 'local_group')
    call sign_unplace( 'global_group')
    
    for l:local_word in g:local_list
        "getpos = 0だとエラー
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

function! VimMarkds#setHighLight()
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


""グローバルマークはviminfoの下記
"# File marks:

"marksでは開いてなければファイル名が。
"開いていれば行の内容がmarksコマンドで取得することができる。
"
"この行はなくても問題ない。
"'B  21  0  ~\my_workspace\vim\VimGlobalSession\plugin\VimGlobalSession.vim
"|4,65,21,0,1634133756,"~\\my_workspace\\vim\\VimGlobalSession\\plugin\\VimGlobalSession.vim"

"|4,57,14,0,1634169111,"~\\my_workspace\\vim\\VimGlobalSession\\plugin\\VimGlobalSession.vim"


"# History of marks within files (newest to oldest):

"> ~\my_workspace\vim\VimGlobalSession\VimMarkds.vim
"	*	1634170193	0
"	"	13	0
"	^	4	0
"	.	4	0
"	+	5	0
"	+	4	0
"	a	1	0
"	b	2	0
"	c	3	0
"	d	4	0
"	e	5	0
"	f	6	0
"	g	7	0
"	h	8	0
"	i	8	0
"	j	9	0
"	k	9	0
"	l	10	0
"	m	12	0
"	n	11	0












