" .vimrc
" ----------------------------------------------------------------------------
" General Settings
" ----------------------------------------------------------------------------
set background=dark
" Enable syntax highlighting
syntax on
" Show line numbers
set number
" Highlight search matches
set hlsearch
" Ignore case for lowercase search string; for upper case retain it
set ignorecase
set smartcase
" Only whitespace after end of document, no ~
set fillchars=eob:\  
" Scrolloff scrolls screen before cursor reaches last - x line
set scrolloff=15
" Copy to system clipboard
set clipboard=unnamedplus
" ----------------------------------------------------------------------------
" Keybindings
" ----------------------------------------------------------------------------
" Remap leader to Space
let mapleader=" "
" Save file
nnoremap <leader>w :w<CR>
" Quit
nnoremap <leader>q :q<CR>
" hlsearch off with <leader>l
nnoremap <silent> <leader>l :nohlsearch<CR>
" Scroll page
nnoremap <C-j> 5<C-e>
nnoremap <C-k> 5<C-y>
" Let Backspace delete in normal mode
nnoremap <BS> X
" Enter in insert mode on new line with Enter
nnoremap <cr> o
" Move current line up/down in normal mode
nnoremap <leader>j :m .+1<CR>==
nnoremap <leader>k :m .-1<CR>==

set backspace=indent,eol,start
" ----------------------------------------------------------------------------
" Indentation Settings
" ----------------------------------------------------------------------------
" Set tab width to 4 spaces
set tabstop=4        " Number of spaces that a <Tab> in the file counts for
set shiftwidth=4     " Number of spaces to use for each step of (auto)indent
" Enable auto-indenting to make code formatting easier
set autoindent
set smartindent
" Specific settings for YAML files: autoindent with 2 spaces
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
" ----------------------------------------------------------------------------
" Split Window Navigation
" ----------------------------------------------------------------------------
" Split panes behavior
set splitbelow       " Horizontal splits will automatically be below
set splitright       " Vertical splits will automatically be to the right
" Navigate between splits using Leader + j/k/l/h
nnoremap <leader>j <C-W><C-J>
nnoremap <leader>k <C-W><C-K>
nnoremap <leader>l <C-W><C-L>
nnoremap <leader>h <C-W><C-H>
" status line color
highlight StatusLine ctermfg=208 ctermbg=black
highlight StatusLineNC ctermfg=214 ctermbg=black
highlight VertSplit ctermfg=214 ctermbg=black

" Kommentare
highlight Comment ctermfg=8

" Strings
highlight String ctermfg=2

" Suchtreffer
highlight Search ctermfg=0 ctermbg=3

" Fehler
highlight Error ctermfg=1

" TODO/FIXME
highlight Todo ctermfg=3

" Zeilennummern

highlight Comment ctermfg=8
highlight String ctermfg=2

highlight Constant ctermfg=NONE
highlight Identifier ctermfg=NONE
highlight Statement ctermfg=NONE
highlight Type ctermfg=NONE
highlight PreProc ctermfg=NONE
"highlight Special ctermfg=NONE

" comments
highlight Comment ctermfg=4
" linenumber
highlight LineNr ctermfg=8
highlight CursorLineNr ctermfg=6
" ----------------------------------------------------------------------------
" Netrw Settings (File Explorer)
" ----------------------------------------------------------------------------
" Set the default Netrw window size
let g:netrw_winsize=30
let g:netrw_banner=0
let g:netrw_browse_split=4
let g:netrw_altv=1
let g:netrw_liststyle=3
" ----------------------------------------------------------------------------
" Display Settings
" ----------------------------------------------------------------------------
" Display whitespaces when 'set list' is activated
set listchars=eol:¬,tab:▸•,space:□
" ----------------------------------------------------------------------------
" Custom commands
" ----------------------------------------------------------------------------
command HR normal i# ----------------------------------------------------------------------------<CR>
command DOT normal i•
command ARROW normal i▸
" Allow saving of files as sudo
cmap w!! w !sudo tee > /dev/null %
