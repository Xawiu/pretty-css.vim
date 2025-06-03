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

  " Add semicolon before } if missing and not already present (fixes transition: ...})
  silent! %s/\v([^;{}])}/\1;\r}/g

  " Ensure lines not ending in ; or } get a semicolon before newline
  silent! %s/\v([^\s;{}])\s*[\r\n]/\1;\r/g

  " Break line **before** opening comment `/*`
  silent! %s/\v(\/\*)/\r\1/g
  
  " Break line **after** closing comment `*/`
  silent! %s/\v(\*\/)/\1\r/g

  " Add space after {
  silent! %s/{/ {/g

  " Add semicolon before }
  silent! %s/}/;}/g

  " Break line after every }
  silent! %s/}\s*/}\r/g

  " Enforce single space after comma or colon
  silent! %s/\s*[,:]\s*/& /g

  " Join lines ending with ', ' with the following line (especially for transitions)
  silent! %s/\v(0\.\d+s,)\s+/\1 /g
  silent! %g/, $/join

  " Remove unnecessary spaces
  silent! %s/\s*;[ ]*/;/g      " after ;
  silent! %s/(\s\+/(/g         " after (
  silent! %s/\s\+)/)/g         " before )

  " Remove double semicolons
  silent! %s/;;/;/g

  " Remove spaces before colon at start of line
  silent! %s/^\s*:\s\+/:/g

  " Clear lines containing only semicolon or whitespace
  silent! %s/\v^\s*(;)?\s*$//g

  " Remove all empty lines
  silent! g/^\s*$/d

  " Join lines starting with '{' with previous line
  silent! g/^\s*{/-1join

  " Add tab to lines ending with ; or starting with --
  silent! %s/\v^[^\s].*;$/\t&/g
  silent! %s/\v^--.*/\t&/g

  " Replace multiple spaces with single space
  silent! %s/  \+/ /g

  " Replace tabs with 4 spaces (optional)
  silent! %s/^\t/    /g

  " Remove any extra semicolon before }
  silent! %s/;\s*}/}/g

  " Remove spaces after ':' in lines ending with '}' (e.g., a:hover)
  silent! g/{\s*$/s/:\s\+/:/g

  " Add an empty line after closing brace unless followed by another closing brace or comment
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


command! MinifyCSS call MinifyCss()

function! MinifyCss()
  if &filetype !=# 'css'
    echohl WarningMsg
    echom "MinifyCSS: Current file is not of type CSS (filetype=".&filetype.")"
    echohl None
    return
  endif

  " Remove comments
  silent! %s:/\*.\{-}\*/::g

  " Remove line breaks
  silent! %s/\n/ /g

  " Remove multiple spaces
  silent! %s/  \+/ /g

  " Remove spaces around key characters
  silent! %s/ *{ */{/g
  silent! %s/ *} */}/g
  silent! %s/ *: */:/g
  silent! %s/ *; */;/g
  silent! %s/ *\, */,/g
  silent! %s/ *> */>/g

  " Remove leading zero from decimals (e.g. 0.3 → .3)
  silent! %s/\v([^0-9a-zA-Z])0\.(\d)/\1.\2/g

  " Shorten hex colors, e.g. #ffffff → #fff
  silent! %s/\v#([0-9a-fA-F])\1([0-9a-fA-F])\2([0-9a-fA-F])\3/#\1\2\3/g

  " Remove semicolon before closing brace
  silent! %s/;}/}/g

  " Remove spaces after colon in pseudo-elements
  silent! %s/:\s\+/:/g

  " Remove trailing whitespace again at the end
  silent! %s/\s\+$//e

  " Trim leading whitespace or tabs from the first line
  silent! 1s/^\s\+//

  " Trim trailing whitespace or tabs from the last line
  silent! $s/\s\+$//

  echohl Identifier
  echo "MinifyCSS: Minification complete."
  echohl None
endfunction
