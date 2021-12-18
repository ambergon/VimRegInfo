" Author: ambergon
" License: MIT
" Version: 0.0.1
" VimRegInfo

""setting
"viminfoを管理するディレクトリ
"let g:VimRegInfoDir="~/.cache/viminfo"
"1で自動起動
"let g:VimRegInfoAutoStart = 1
"サイズ指定
"let g:RegInfoWindowSize =25

if exists('g:loaded_VimRegInfo')
  finish
endif
let g:loaded_VimRegInfo = 1

if !exists("g:VimRegInfoDir")
    let g:VimRegInfoDirectory=expand("~/.cache/viminfo")
else
    let g:VimRegInfoDirectory=expand(g:VimRegInfoDir)
endif

command! -nargs=? -complete=customlist,VimRegInfo#CompInfo RegInfo call VimRegInfo#regInfoLoad('<args>')
command! -nargs=? -complete=customlist,VimRegInfo#CompInfo RegInfoEdit call VimRegInfo#regInfoEdit('<args>')
command! -nargs=? -complete=customlist,VimRegInfo#CompInfo RegInfoSave call VimRegInfo#regInfoSave('<args>')

command! -nargs=0 RegInfoWindow call VimRegInfo#openWindow()
command! -nargs=0 RegInfoWindowOff call VimRegInfo#closeWindow()
command! -nargs=0 RegInfoWindowClean call VimRegInfo#regClean()
command! -nargs=1 RegExchange call VimRegInfo#regExchange(<f-args>)

function! VimRegInfo#CompInfo(lead, line, pos )
    let l:matches = []
    let l:dir = g:VimRegInfoDirectory
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

if exists("g:VimRegInfoAutoStart")
    if g:VimRegInfoAutoStart == 1
        call VimRegInfo#openWindow()
    endif
endif

"autocmd! TextYankPost * let g:VimRegInfoEvent = deepcopy(v:event) | call VimRegInfo#do(g:VimRegInfoEvent)
