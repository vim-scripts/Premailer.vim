" ============================================================
" File:          premailer.vim
" Description:   Interface with the ruby script Premailer
" Author:        Kien Nguyen <info@designtomarkup.com>
" License:       MIT
" Repository:    https://github.com/kien/premailer.vim
" ============================================================

if exists('g:loaded_premailer') && g:loaded_premailer
  finish
endif
let g:loaded_premailer = 1

com! -nargs=* Premailer cal premailer#init(<f-args>)
