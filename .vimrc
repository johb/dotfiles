" .vimrc
" ----------------------------------------------------------------------------
" General Settings
" ----------------------------------------------------------------------------
" Enable syntax highlighting
syntax on
" Show line numbers
set number
" Highlight the current line
set cursorline
" Highlight search matches
set hlsearch
" Ignore case when searching
set ic
" Only whitespace after end of document, no ~
set fillchars=vert:\ ,eob:\  
" ----------------------------------------------------------------------------
" Keybindings
" ----------------------------------------------------------------------------
" Remap leader to ;
let mapleader=","
" hlsearch off with <leader>l
nnoremap <leader>l :nohlsearch<CR>
" Movement in insert mode with <Ctrl>-h,j,k,l
inoremap <C-h> <Left>
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-l> <Right>
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
" Navigate between splits using Ctrl + (H/J/K/L)
nnoremap <C-j> <C-W><C-J>
nnoremap <C-k> <C-W><C-K>
nnoremap <C-l> <C-W><C-L>
nnoremap <C-h> <C-W><C-H>
" Scroll pane up and down with Ctrl + (J/K)
nnoremap <C-k> <C-y>
nnoremap <C-j> <C-e>
" status line color
highlight StatusLine ctermfg=208 ctermbg=black
highlight StatusLineNC ctermfg=214 ctermbg=black
highlight VertSplit ctermfg=214 ctermbg=black
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
