
""delmarks!では
"A-Zが消えない。

""グローバルマークはviminfoの下記
"# File marks:

""この行はなくても問題ない。
"marksでは開いてなければファイル名が。
"開いていれば行の内容がmarksコマンドで取得することができる。
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

autocmd bufEnter * call VimMarkds#setSign()
let g:local_list ='abcdefghijklmnopqrstuvwxyz'

"set sign
function! VimMarkds#setSign()
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
    
    ""すべて解除
    call sign_unplace( 'local_group')
    
    ""local_mark
    for s:word in g:local_list
        "getpos = 0だとエラー
        if getpos("'" . s:word)[1] != 0
            call sign_place( 0, 'local_group', 'local_' . s:word, 1,{'lnum' : getpos("'" . s:word)[1] })
        endif
    endfor
endfunction

""local_markの色を定義
function! VimMarkds#setVisual()
    hi LocalMark ctermfg=254 ctermbg=242
    "local_mark
    for s:word in g:local_list
        call sign_define("local_" . s:word,{"text" : s:word . ">", "texthl" : "LocalMark"})
    endfor
endfunction


"new window marklist
function! VimMarkds#a()
    echo 'ank'
endfunction



















