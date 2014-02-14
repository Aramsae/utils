
syntax on

set incsearch
set paste
set encoding=utf-8
" %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% "
"               Display of line numbers
" %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% "
 set number    "Startup: display numbers"
 nnoremap <F2> :set nonumber!<CR>:set foldcolumn=0<CR>



"  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% "
"                Indentation management                     "
"  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% "
function! SpacesAndTabs()
    if &expandtab
        retab
    else
        try
            %s/^ \+/\=substitute(submatch(0), repeat(' ', &ts), '\t', 'g')
        catch
        endtry
    endif
endfunction

nnoremap <F3> <ESC>:set expandtab!<CR>:call SpacesAndTabs()<CR><CR>

set list lcs=tab:>-,trail:.

filetype plugin indent on


set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4


" docblock comments are continued when a newline is inserted
set comments=sr:/*,mb:*,ex:*/
filetype on
filetype plugin on
" check syntax with Ctrl + L
autocmd FileType php noremap &lt;C-L&gt; :!/usr/bin/env php -l %&lt;CR&gt;
autocmd FileType phtml noremap &lt;

set hlsearch

nnoremap <F4> :!pep8.py % <CR>

