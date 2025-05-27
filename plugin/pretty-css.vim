" pretty-css.vim - Simple Vim plugin to format minified or messy CSS
" without any external dependencies.
" Author: Zbigniew Śliwiński <zeebeer at gmail.com>
" Usage:  :PrettyCSS  - formats current buffer (must be CSS)

if exists("g:loaded_pretty_css")
  finish
endif
let g:loaded_pretty_css = 1

command! PrettyCSS call PrettyCssFormat()

function! PrettyCssFormat()
  if &filetype !=# 'css'
    echohl WarningMsg
    echom "PrettyCSS: Current file is not of type CSS (filetype=".&filetype.")"
    echohl None
    return
  endif

  " Add new line and tab after ; or { if no \n present
  silent! %s/\v([;{])([^\n])/\1\r\t\2/g

  " Join lines before } – so the block ends on a single line
  silent! g/^\s*}/.-1join

  " Add semicolon before } if missing
  silent! %s/\v([^\s\{;])\s*\}/\1;\r}\r/g

  " Break line **before** opening comment `/*`
  silent! %s/\v(\/\*)/\r\1/g
  
  " Break line **after** closing comment `*/`
  silent! %s/\v(\*\/)/\1\r/g

  " Add space after {
  silent! %s/{/ {/g

  " Enforce single space after comma or colon
  silent! %s/\s*[,:]\s*/& /g

  " Join lines ending with ', ' with the following line
  silent! %g/, $/join

  " Remove spaces:
  silent! %s/\s*;[ ]*/;/g " - after ;
  silent! %s/(\s\+/(/g    " - after ( 
  silent! %s/\s\+)/)/g    " - before )

  " Remove double semicolons
  silent! %s/;;/;/g

  " Remove spaces before colon at start of line
  silent! %s/^\s*:\s\+/:/g

  " Clear lines containing only semicolon or whitespace
  silent! %s/\v^\s*(;)?\s*$//g

  " Remove all empty lines
  silent! g/^\s*$/d

  " Join lines starting with '{' (optionally preceded by whitespace) with the previous line
  silent! g/^\s*{/-1join

  " Add tab to lines ending with ; or starting with --
  silent! %s/\v^[^\s].*;$/\t&/g
  silent! %s/\v^--.*/\t&/g

  " Replace multiple spaces with a single space
  silent! %s/  \+/ /g

  " Replace tabs with 4 spaces (optional)
  silent! %s/^\t/    /g

  " Remove any extra semicolon before }
  silent! %s/;\s*}/}/g

  " Add an empty line after every line that contains only a closing brace (}) unless the next line is another closing brace or a comment boundary
  let i = 1
  while i <= line('$')
    let current = getline(i)
    let next = getline(i + 1)
  
    if current =~ '^\s*}\s*$' 
          \ && next !~ '^\s*}\s*$' 
          \ && next !~ '^\s*\*/\s*$'
          \ && next !~ '^\s*/\*'
      call append(i, '')
      let i += 1
    endif
  
    let i += 1
  endwhile

  " Save current indentation settings
  let l:sw  = &shiftwidth
  let l:sts = &softtabstop
  let l:et  = &expandtab

  " Set indentation to 4 spaces
  setlocal shiftwidth=4
  setlocal softtabstop=4
  setlocal expandtab

  " Auto-indent the entire buffer
  silent! normal! gg=G

  " Restore previous settings
  let &shiftwidth  = l:sw
  let &softtabstop = l:sts
  let &expandtab   = l:et

  highlight MySuccessMsg ctermfg=lightgreen guifg=lightgreen
  echohl MySuccessMsg
  echo "PrettyCSS: Formatting complete."
  echohl None

endfunction

