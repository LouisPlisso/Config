" this is mostly a matter of taste. but LaTeX looks good with just a bit
" of indentation.
set sw=2
" TIP: if you write your \label's as \label{fig:something}, then if you
" type in \ref{fig: and press <C-n> you will automatically cycle through
" all the figure labels. Very useful!
set iskeyword+=:

" no trailing white space in latex
autocmd BufWrite *.tex :call DeleteTrailingWS()

"============================================================================
"File:        tex.vim
"Description: Syntax checking plugin for syntastic.vim
"Maintainer:  Martin Grenfell <martin.grenfell at gmail dot com>
"License:     This program is free software. It comes without any warranty,
"             to the extent permitted by applicable law. You can redistribute
"             it and/or modify it under the terms of the Do What The Fuck You
"             Want To Public License, Version 2, as published by Sam Hocevar.
"             See http://sam.zoy.org/wtfpl/COPYING for more details.
"
"============================================================================
if exists("loaded_tex_syntax_checker")
    finish
endif
let loaded_tex_syntax_checker = 1

"bail if the user doesnt have lacheck installed
if !executable("lacheck")
    finish
endif

function! SyntaxCheckers_tex_GetLocList()
    let makeprg = 'lacheck '.shellescape(expand('%'))
    let errorformat =  '%E"%f"\, line %l: %m'
    return SyntasticMake({ 'makeprg': makeprg, 'errorformat': errorformat })
endfunction

