
""delmarks!では
"A-Zが消えない。

""グローバルマークはviminfoの下記
"# File marks:

"marksでは開いてなければファイル名が。
"開いていれば行の内容がmarksコマンドで取得することができる。
"
"この行はなくても問題ない。
"'B  21  0  ~\my_workspace\vim\VimGlobalSession\plugin\VimGlobalSession.vim
"|4,65,21,0,1634133756,"~\\my_workspace\\vim\\VimGlobalSession\\plugin\\VimGlobalSession.vim"

"|4,57,14,0,1634169111,"~\\my_workspace\\vim\\VimGlobalSession\\plugin\\VimGlobalSession.vim"


""localなマークはこのように保存されている
"+はundoなどで使うのではないだろうか
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


let g:local_list ='abcdefghijklmnopqrstuvwxyz'
let g:global_list ='ABCDEFGHIJKLMNOPQRSTUVWXYZ'
"25vs RegInfoWindow://
let s:left_buffer_name ='TEST://MARKERS'

command! -nargs=0 MarkClean call VimMarkds#localMarkClean()

command! -nargs=0 MarkSing call VimMarkds#setSing()
command! -nargs=0 MarkVisual call VimMarkds#setVisual()
command! -nargs=0 MarkWindow call VimMarkds#markersWindow()

autocmd! VimEnter * call VimMarkds#setVisual()
autocmd! bufEnter,InsertLeave * call VimMarkds#setVisual()
"autocmd! bufEnter * call VimMarkds#setSign()
autocmd! VimEnter,bufEnter,InsertLeave * call VimMarkds#setSign()
autocmd! bufEnter * call VimMarkds#setSign()

function! VimMarkds#markersWindow()
    if !bufexists(s:left_buffer_name)
        let l:current_winID = win_getid()
        execute("aboveleft 25vs " . s:left_buffer_name)

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
        call win_gotoid(l:current_winID)
    endif
    call VimMarkds#setMarkerLine()
endfunction

function! VimMarkds#setMarkerLine()
    "引数がなければグローバル
    "getmarklist(bufnr())
    "local
    ""dict
    "mark,post
    "
    "global
    ""dict
    "file,mark,pos
    "
    let l:x=0
    for l:local_mark in getmarklist(bufnr())
        let l:x = x+1
        call setbufline(s:left_buffer_name,  1, l:local_mark["mark"] )
    endfor


    "call setbufline(s:left_buffer_name,  1, '====================' )
endfunction

function! VimMarkds#localMarkClean()
    delmarks!
endfunction

"set sign
function! VimMarkds#setSign()
    ""すべて解除
    call sign_unplace( 'local_group')
    call sign_unplace( 'global_group')
    
    ""local_mark
    for s:local_word in g:local_list
        "getpos = 0だとエラー
        if getpos("'" . s:local_word)[1] != 0
            call sign_place( 0, 'local_group', 'local_' . s:local_word, bufnr(),{'lnum' : getpos("'" . s:local_word)[1], 'priority' : 10 })
        endif
    endfor
    
    ""global_mark
    for s:global_word in g:global_list
        "getpos = 0行 = 未設定 だとエラー
        if getpos("'" . s:global_word)[1] != 0
            "getBufnum = current
            if getpos("'" . s:global_word)[0] == bufnr()
                call sign_place( 0, 'global_group', 'global_' . s:global_word, bufnr(),{'lnum' : getpos("'" . s:global_word)[1], 'priority' : 20 })
            endif
        endif
    endfor
endfunction

function! VimMarkds#setVisual()
    ""local_markの色を定義
    hi LocalMark ctermfg=254 ctermbg=242 guifg=#e4e4e4 guibg=#666666
    ""global_markの色を定義
    hi GlobalMark ctermfg=113 ctermbg=175 guifg=#87df5f guibg=#df87af

    "local_mark
    for s:local_word in g:local_list
        call sign_define("local_" . s:local_word,{"text" : s:local_word . ">", "texthl" : "LocalMark"})
    endfor
    "global_mark
    for s:global_word in g:global_list
        call sign_define("global_" . s:global_word,{"text" : s:global_word . ">", "texthl" : "GlobalMark"})
    endfor
endfunction


"new window marklist


"let s:mark_a = getpos("'a")
"echo s:mark_a
""buf-num current=0
"echo s:mark_a[0]
""行番号
"echo s:mark_a[1]
""列
"echo s:mark_a[2]
""offset
"echo s:mark_a[3]
    













