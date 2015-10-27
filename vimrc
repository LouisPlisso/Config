"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set backspace=indent,eol,start

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = " "
let g:mapleader = " "
" time after leader (or g) to type other letter
set timeoutlen=400

" Sets how many lines of history VIM has to remember
set history=300

set visualbell

" Enable filetype plugin
filetype on
filetype plugin on
filetype indent on
syntax on

" Set to auto read when a file is changed from the outside
set autoread

" Fast saving
nnoremap <leader><space> :wa<CR>
nnoremap <leader>w :w!<CR>
" fast quiting
noremap <leader>qq :q!<CR>

" Fast editing of the .vimrc
map <leader>e :e! ~/.vim/vimrc<CR>

" When vimrc is edited, reload it
autocmd! bufwritepost vimrc source ~/.vimrc

" file to save many configs
set viminfo='1000,f1,<500,h,n$HOME/.vim/viminfo

" persistant undo file
set undofile
set undodir=~/tmp/vim_undos

set formatoptions=tqn

set showcmd
set smartcase          " Do smart case matching
set autowriteall " Automatically save before commands like :next and :make

" to quit a buffer and remove it from buffer list
noremap <leader>q :w<CR>:Bclose<CR>
noremap <leader>d :Bclose<CR>

command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
   let l:currentBufNum = bufnr("%")
   let l:alternateBufNum = bufnr("#")

   if buflisted(l:alternateBufNum)
     buffer #
   else
     bnext
   endif

   if bufnr("%") == l:currentBufNum
     new
   endif

   if buflisted(l:currentBufNum)
     execute("bdelete ".l:currentBufNum)
   endif
endfunction

" open file at previous known position
if has("autocmd")
autocmd BufReadPost *
            \ if line("'\"") > 0 && line("'\"") <= line("$") |
            \ exe "normal g'\"" |
            \ endif
endif

" Searching
set gdefault
set hlsearch
set ignorecase "Ignore case when searching
set hlsearch "Highlight search things
set magic "Set magic on, for regular expressions
set showmatch "Show matching bracets when text indicator is over them
set mat=2 "How many tenths of a second to blink

map <silent> <leader>/ :noh<CR>

" Turn off incremental searching for files over 10,000,000 bytes. It's too
" slow.
function! IncSearch()
    if line2byte(line("$")) < 10000000
        set incsearch
    else
        set noincsearch
    endif
endfunction

autocmd BufReadPost * call IncSearch()

" When pressing <leader>cd switch to the directory of the open buffer
"map <leader>cd :cd %:p:h<CR>
set autochdir

" make move behave ok whith wrapping lines
vnoremap gj j
nnoremap gj j
vnoremap gk k
nnoremap gk k

vnoremap j gj
nnoremap j gj
vnoremap k gk
nnoremap k gk

map gm :call cursor(0, virtcol('$')/2)<CR>

" vim grep command
set grepprg=/bin/grep\ -nH\ $*

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" window navigation
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

nnoremap <right> :bnext<CR>
nnoremap <left> :bprevious<CR>
noremap <C-J> <C-W>j
noremap <C-K> <C-W>k
noremap <C-H> <C-W>h
noremap <C-L> <C-W>l

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" set wildmenu
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set wildmenu
set wildmode=longest,list
"set wildmode=longest:full
set wildignore=*.pyc

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Set 3 lines to the curors - when moving vertical..
set so=3
set ruler "Always show current position
set cmdheight=1 "The commandbar height

" Useful on some European keyboards
map ½ $
imap ½ $
vmap ½ $
cmap ½ $

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Statusline
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set laststatus=2

" Format the statusline
"set statusline=%=bufs:\ %{buftabs#statusline()}
"set statusline=%<CWD:\ %r%{CurDir()}%h\ \ %F%m%r%h\ %w\ Line:\ %l/%L:\ %p%%\ %(Column:\ %c%)
"set statusline=%<%F%m%r%h%w\ L:%l/%L\ %p%%\|%(C:%c%)%=%{buftabs#statusline()}
set statusline=\|L:%l/%L\ %p%%\|%(C:%c%)
"let g:buftabs_in_statusline=1

function! CurDir()
    let curdir = substitute(getcwd(), '/Users/amir/', "~/", "g")
    return curdir
endfunction


" allows to recover cut text in insert mode
"inoremap <c-u> <c-g>u<c-u>
"inoremap <c-w> <c-g>u<c-w>
"inoremap <c-w> <c-o>db

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

syntax enable "Enable syntax hl

" Color scheme
if has("gui_running")
  set guioptions-=T
  "set background=dark
  set background=light
  set t_Co=256
  set background=light
  "colorscheme moria
  colorscheme solarized
else
  "set background=dark
  set background=light
  "colorscheme blackboard
  colorscheme solarized
  "colorscheme default
  "colorscheme transparent
  "colorscheme moria
endif

set cursorline
"hi CursorLine   term=Grey90 cterm=Grey90 guibg=Grey90

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" autocomands
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" automatically insert "#!/bin/sh" line for *.sh files
au BufEnter *.sh if getline(1) == "" | :call setline(1, "#!/bin/sh") | endif
" idem for python
au BufEnter *.py if getline(1) == "" | :call setline(1, "#!/usr/bin/env python") | endif

" Define a function that can tell me if a file is executable
function! FileExecutable (fname)
  execute "silent! ! test -x" a:fname
  return v:shell_error
endfunction

" Automatically make Python and Shell scripts executable if they aren't already
au BufWritePost *.sh,*.py if FileExecutable("%:p") | silent !chmod a+x %   endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set encoding=utf8

set smarttab
set linebreak

set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines
set sidescroll=3
set list
set listchars=precedes:<,extends:>,trail:· ",eol:¶
" remove trailing spaces with F11
map <F11> :%s/\s\+$//g<CR>:nohlsearch<CR>

"map <leader>t2 :setlocal shiftwidth=2<cr>
"map <leader>t4 :setlocal shiftwidth=4<cr>
"map <leader>t8 :setlocal shiftwidth=4<cr>

set expandtab
autocmd BufRead *.py set textwidth=79
"set textwidth=79
autocmd BufRead *.py match ErrorMsg '\%>80v.\+'
set tabstop=4
set softtabstop=4
set shiftwidth=4
set autoindent
autocmd Filetype ruby setlocal ts=2 sts=2 sw=2
autocmd Filetype python setlocal ts=4 sts=4 sw=4

" readjust sentence
map <leader>s gqis

" Customs mapping for convenience
map <leader>o o
map <leader>O O
map <leader>k ik$
map <leader>K i
map <leader>j i
imap <C-A> <Home>
" imap <C-E> <End>

" for restructured text
imap  yypVr-o
map <leader>z yypVr
autocmd BufEnter *.rst.txt set syntax=rst
autocmd BufEnter *.txt set nowrap
map <leader>x :w<cr>:silent !rst2html.py % > %.html<cr>
autocmd BufWrite *.rst.txt :call DeleteTrailingWS()
"autocmd BufRead *.txt map <leader>ll :silent !rst2html % > %.html

" for wiki à la google code
autocmd BufNewFile,BufRead *.wiki set ft=googlecodewiki

"Delete trailing white space, useful for Python ;)
func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc
command! DeleteTrailingWS call DeleteTrailingWS()
" to visualize trailing whitespace
au BufRead,BufNewFile *.rb,*.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/


" useful for python folding
set foldmethod=indent
set foldlevel=99

" from:
" http://concisionandconcinnity.blogspot.com/2009/07/vim-part-ii-matching-pairs.html
" matching pairs
inoremap ( ()<Left>
inoremap [ []<Left>
inoremap { {}<Left>
"autocmd Syntax html,vim inoremap < <lt>><Left>
function! ClosePair(char)
    if getline('.')[col('.') - 1] == a:char
        return "\<Right>"
    else
        return a:char
    endif
endf
inoremap ) <c-r>=ClosePair(')')<CR>
inoremap ] <c-r>=ClosePair(']')<CR>
inoremap } <c-r>=ClosePair('}')<CR>
function! InAnEmptyPair()
    let cur = strpart(getline('.'),getpos('.')[2]-2,2)
    for pair in (split(&matchpairs,',') + ['":"',"':'"])
        if cur == join(split(pair,':'),'')
            return 1
        endif
    endfor
    return 0
endfunc
func! DeleteEmptyPairs()
    if InAnEmptyPair()
        return "\<Left>\<Del>\<Del>"
    else
        return "\<BS>"
    endif
endfunc
inoremap <expr> <BS> DeleteEmptyPairs()

" for quotes
function! QuoteDelim(char)
    let line = getline('.')
    let col = col('.')
    if line[col - 2] == "\\"
        "Inserting a quoted quotation mark into the string
        return a:char
    elseif line[col - 1] == a:char
        "Escaping out of the string
        return "\<Right>"
    else
        "Starting a string
        return a:char.a:char."\<Left>"
    endif
endf
inoremap " <c-r>=QuoteDelim('"')<CR>
" only imap for txt files
"inoremap ' <c-r>=QuoteDelim("'")<CR>
imap ' <c-r>=QuoteDelim("'")<CR>
autocmd BufEnter *.txt iunmap <silent> '


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Spell checking
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" F8 toggles spelling
nnoremap <F8> :setlocal spell!<CR>

"Shortcuts using <leader>
"map <leader>n ]s
"map <leader>p [s
"map <leader>z zg
"map <leader>r z=

" next error/warning with eclim
map <leader>n :lnext<CR>
map <leader>p :lprevious<CR>
" eclim sort validation
let g:EclimValidateSortResults = "severity"

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files and backups
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set backup
set wb
set swapfile

""""""""""""""""""""""""""""""
" => Visual mode related
""""""""""""""""""""""""""""""

"  In visual mode when you press * or # to search for the current selection
vnoremap <silent> * :call VisualSearch('f')<CR>
vnoremap <silent> # :call VisualSearch('b')<CR>

" From an idea by Michael Naumann
function! CmdLine(str)
    exe "menu Foo.Bar :" . a:str
    emenu Foo.Bar
    unmenu Foo
endfunction

function! VisualSearch(direction) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'b'
        execute "normal ?" . l:pattern . "^M"
    elseif a:direction == 'gv'
        call CmdLine("vimgrep " . '/'. l:pattern . '/' . ' **/*.')
    elseif a:direction == 'f'
        execute "normal /" . l:pattern . "^M"
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General Abbrevs
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
iab xdate <c-r>=strftime("%d/%m/%y %H:%M:%S")<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Omni complete functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"autocmd FileType css set omnifunc=csscomplete#CompleteCSS

" If you prefer the Omni-Completion tip window to close when a selection is
" made, these lines close it on movement in insert mode or when leaving
" insert mode
autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
autocmd InsertLeave * if pumvisible() == 0|pclose|endif

" supertab
"let g:SuperTabDefaultCompletionType = "<C-N>"
let g:SuperTabDefaultCompletionType = "context"
let g:SuperTabCompletionContexts = ['s:ContextText', 's:ContextDiscover']
let g:SuperTabContextTextOmniPrecedence = ['&completefunc', '&omnifunc']
let g:SuperTabContextDiscoverDiscovery =
            \ ["&completefunc:<c-x><c-u>", "&omnifunc:<c-x><c-o>"]
set completeopt=menuone ",longest

" for ruby
autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading = 1
autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 1
autocmd FileType ruby,eruby let g:rubycomplete_rails = 1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugins
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" python
autocmd FileType python source ~/.vim/bundle/my_config/ftplugin/python.vim

" Yankring
noremap <silent> <F10> :YRShow <CR>
"let g:yankring_manage_numbered_reg = 1
let g:yankring_max_history = 1000
let g:yankring_dot_repeat_yank = 1
let g:yankring_map_dot = 1
let g:yankring_history_dir = '~/.vim/'

" TODO: deleted place text in numbered registers
"map x @'x
"map c ""c
"map d ""d

"NERDTree
let NERDCreateDefaultMappings=0

" Taglist
let Tlist_Ctags_Cmd='/usr/bin/ctags'
nnoremap <leader>t :TlistToggle<CR>:TlistUpdate<cr>
let Tlist_Use_Right_Window = 1    " taglist open on the right
let Tlist_Exit_OnlyWindow = 1     " exit if taglist is last window open
let Tlist_Show_One_File = 1       " Only show tags for current buffer
"let Tlist_Enable_Fold_Column = 0  " no fold column (only showing one file)
let Tlist_Compact_Format = 1
let Tlist_File_Fold_Auto_Close = 1
let tlist_sql_settings = 'sql;P:package;t:table'
let tlist_ant_settings = 'ant;p:Project;r:Property;t:Target'
let g:ctags_statusline=1
" Automatically start script
let generate_tags=1

" NERDCommenter
nmap g- <Plug>NERDCommenterComment
nmap g+ <Plug>NERDCommenterUncomment

" gundo
map <leader>g :GundoToggle<CR>

" F2 shows relative line numbers
nnoremap <F2> :call RltvNmbr#RltvNmbrCtrl(1)<cr>
" F3 unshows relative line numbers
nnoremap <F3> :call RltvNmbr#RltvNmbrCtrl(0)<cr>

" Rainbow parenthesis
nnoremap <F4> :ToggleRaibowParenthesis<cr>

" snipmate
let g:snips_author = 'Louis Plissonneau'

" task list
map <leader>v <Plug>TaskList

" bufstat
"let g:bufstat_bracket_around_bufname = 1
nmap <leader>bb :buffers<CR>
" sort buffer as least recently used
let g:bufstat_sort_function = 'BufstatSortReverseMRU'
" bufExplorer
let g:bufExplorerDefaultHelp=0
let g:bufExplorerShowRelativePath=1

" latex-suite
let g:tex_flavor='latex'
" use C-space instead of C-J for jumping to <++>
map <C-CR> <Plug>IMAP_JumpForward
imap <C-CR> <Plug>IMAP_JumpForward
map <C-S-CR> <Plug>IMAP_DeleteAndJumpForward
imap <C-S-CR> <Plug>IMAP_DeleteAndJumpForward
" already mapped to insert item on next line
"imap <C-CR> <Plug>IMAP_JumpForward
"inoremap <C-S-CR> <Esc><Plug>IMAP_JumpForward i
" for imap to stop complete (ex for FTTH)
"let g:Imap_FreezeImap = 1
" for being able to type é
imap <buffer> ii<space> <Plug>Tex_InsertItemOnThisLine
imap <buffer> inn<space> <Plug>Tex_InsertItemOnNextLine
" REPLIS: vim-latex replis automatiquement certaines sections et environnements
" ou commandes. La liste de ce qui doit être replié est géré par les varibales
" globales suivantes. Les replis se font en partant de la fin de la liste puis
" en remontant. Les defaut sont dans folding.vim (~/.vim/ftplugin/latex-suite/)
let g:Tex_FoldedSections="part,chapter,section"
",%%fakesection,subsection"
let g:Tex_FoldedEnvironments="verbatim,comment,eq,figure,table,tabular,tikzpicture,thebibliography,abstract,frame"
let g:Tex_FoldedMisc = 'preamble,<<<'  " >>>
let g:Tex_MultipleCompileFormats="pdf"
" COMPILATION VISUALISATION: par defaut on compile avec pdflatex et on utilise
" evince
let g:Tex_ViewRule_pdf = "evince"
let g:Tex_DefaultTargetFormat="pdf"

"""""""""""""""""
" screen title
"set titlestring=%t%(\ %M%)%(\ (%{expand(\"%:p:h\")})%)%(\ %a%)\ -\ %{v:servername}
"autocmd BufEnter * let &titlestring = "[vim(" . expand("%:t") . ")]"
"if &term == "screen"
"    let &titlestring=expand("%:t")
"    set t_ts=k
"    set t_fs=\
"    set title
"endif

"""""""""""""""""
highlight clear SpellBad
highlight SpellBad term=standout ctermfg=1 term=underline cterm=underline
highlight clear SpellCap
highlight SpellCap term=underline cterm=underline
highlight clear SpellRare
highlight SpellRare term=underline cterm=underline
highlight clear SpellLocal
highlight SpellLocal term=underline cterm=underline  

"""""""""""""""""
" for bash plugin not to change Ctrl-J
let g:BASH_Ctrl_j = 'off'

"""""""""""""""""
" pylint no quickfix
let g:pylint_cwindow = 0

"""""""""""""""""
set mouse=a

"""""""""""""""""
" tmux
" Bind <leader>y to forward last-yanked text to Clipper
nnoremap <leader>y :call system('nc localhost 8377', @0)<CR>

"""""""""""""""""
"let g:pydiction_location = '~/.vim/bundle/pydiction/complete-dict'
"
"""""""""""""""""
" sytastic config

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

let g:syntastic_mode_map = { 'passive_filetypes': ['python'] }

"""""""""""""""""
" for SimplyFold
"""""""""""""""""
autocmd BufWinEnter *.py setlocal foldexpr=SimpylFold(v:lnum) foldmethod=expr
autocmd BufWinLeave *.py setlocal foldexpr< foldmethod<

