" VimGlobalSession
" Version: 0.0.1
" Author: 
" License: 

if exists('g:loaded_VimGlobalSession')
  finish
endif
let g:loaded_VimGlobalSession = 1

let s:save_cpo = &cpo
set cpo&vim



let &cpo = s:save_cpo
unlet s:save_cpo

" vim:set et:
