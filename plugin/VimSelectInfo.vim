" Author: ambergon
" License: MIT
" Version: 0.0.1
" VimSelectInfo

""setting
"viminfoを管理するディレクトリ
"let g:VimSelectInfoDir="~/.cache/viminfo"
"1で自動起動
"let g:VimSelectInfoAutoStart = 1
"サイズ指定
"let g:SelectInfoWindowSize =25

if exists('g:loaded_VimSelectInfo')
  finish
endif
let g:loaded_VimSelectInfo = 1

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

if exists("g:VimSelectInfoAutoStart")
    if g:VimSelectInfoAutoStart == 1
        call VimSelectInfo#openWindow()
    endif
endif

"autocmd! TextYankPost * let g:VimSelectInfoEvent = deepcopy(v:event) | call VimSelectInfo#do(g:VimSelectInfoEvent)
