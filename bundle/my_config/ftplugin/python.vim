autocmd FileType python set omnifunc=pythoncomplete#Complete
"autocmd FileType python setlocal omnifunc=pysmell#Complete
"
autocmd FileType python compiler pylint

"from
"http://dancingpenguinsoflight.com/2009/02/python-and-vim-make-your-own-ide/
autocmd FileType python set complete+=k~/.vim/syntax/python.vim
"isk+=.,(

autocmd BufWrite *.py :call DeleteTrailingWS()

" for correct comment indent
set nosmartindent

" `gf` jumps to the filename under the cursor.  Point at an import statement
" and jump to it!
"python << EOF
"import os
"import sys
"import vim
"for p in sys.path:
"    if os.path.isdir(p):
"        vim.command(r"set path+=%s" % (p.replace(" ", r"\ ")))
"EOF

" Execute a selection of code (very cool!)
" Use VISUAL to select a range and then hit ctrl-h to execute it.
python << EOL
import vim
def EvaluateCurrentRange():
    eval(compile('\n'.join(vim.current.range),'','exec'),globals())
EOL

vmap <C-h> :py EvaluateCurrentRange()

"autocmd BufRead *.py set makeprg=python\ -c\ \"import\ py_compile,sys;\ sys.stderr=sys.stdout;\ py_compile.compile(r'%')\"

autocmd BufRead *.py set efm=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m 

" config for python syntax plugin
let python_highlight_all = 1
let python_print_as_function = 1
let python_slow_sync = 1

" for pydiction
let g:pydiction_location = '~/.vim/bundle/Pydiction/complete-dict'

" taken from python-folding script
" Execute file being edited with <leader> + <Shift> + E:
map <buffer> <leader><S-e> :w<CR>:!/usr/bin/env python % <CR>

" go to definition for python with gD
map <buffer> gD yiw/def <C-R>"(<CR>
