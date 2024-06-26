".vimrc
"Simon Hulse
"simonhulse@protonmail.com
"Last Edited: Wed 26 Jun 2024 15:20:00 PDT

" ---Basic stuff---
set nocompatible
syntax on                    " Syntax highlighting
set splitright               " Vertical window forms to right of current
set splitbelow               " Horizontal window forms below current
set encoding=utf-8           " UTF-8 encoding
set number relativenumber    " Line numbering
set so=999                   " Keep the cursor centered
set timeoutlen=200           " Set so that simply pressing 'o' or 'O' doesn't cause a long hang
set foldmethod=indent        " Set fold best on text indentation
set tabstop=4
set shiftwidth=4
set expandtab
set laststatus=2             "https://github.com/itchyny/lightline.vim/blob/master/README.md#introduction
set noshowmode               " With lightline, there isn't much need for showmode
set foldlevel=99
set mouse=a                  " Allow mouse (mainly so I jump quickly with the cursor)
set backspace=2              " Backspace works in insert mode

" Setup undo to work between vim sessions
if !isdirectory($HOME."/.vim")
    call mkdir($HOME."/.vim", "", 0770)
endif
if !isdirectory($HOME."/.vim/undo-dir")
    call mkdir($HOME."/.vim/undo-dir", "", 0700)
endif
set undodir=~/.vim/undo-dir
set undofile

" Configure file backups
if !isdirectory($HOME."/.vim/backups")
    call mkdir($HOME."/.vim/backups", "", 0700)
endif
set backup
set backupdir=~/.vim/backups
set backupcopy=yes

" ---Mappings---
let mapleader = " "
let maplocalleader = "\\"
" Deny visual mode
nnoremap Q <nop>
" Save file with leader instead of colon
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
" Enter command mode with ; rather than :
nnoremap ; :
vnoremap ; :
" Window navigations
nnoremap <Down> <C-W><C-J>
nnoremap <Up> <C-W><C-K>
nnoremap <Right> <C-W><C-L>
nnoremap <Left> <C-W><C-H>
" Open vimrc in new window
nnoremap <leader>ev :vnew $MYVIMRC<cr>
" Source vimrc
nnoremap <leader>sv :source $MYVIMRC<cr>
" Add newline without entering insert mode
nnoremap oo o<esc>k
nnoremap OO O<esc>j
" Move current line below next line
nnoremap - ddp
" Move current line above next line
nnoremap _ dd2kp
" Wrap visually selected text in brackets/quotes
vnoremap <leader>( <esc>`>i)<esc>`<i(<esc>`><cr>
vnoremap <leader>) <esc>`>i)<esc>`<i(<esc>`><cr>
vnoremap <leader>[ <esc>`>i]<esc>`<i[<esc>`><cr>
vnoremap <leader>] <esc>`>i]<esc>`<i[<esc>`><cr>
vnoremap <leader>' <esc>`>i'<esc>`<i'<esc>`><cr>
vnoremap <leader>" <esc>`>i"<esc>`<i"<esc>`><cr>
" Escape insert mode with jk
inoremap jk <esc>
inoremap kj  <esc>
inoremap JK <esc>
inoremap KJ <esc>
" Don't use escape to leave insert mode!
inoremap <esc> <nop>
" Delete line in insert mode
inoremap <c-d> <esc>ddi
" Don't use arrows in insert mode!
inoremap <Left> <nop>
inoremap <Right> <nop>
inoremap <Up> <nop>
inoremap <Down> <nop>
" Delete contents of line but not line itself
nnoremap dl ddO<esc>
" Template for global substitute command
nnoremap <F4> :%s///g<left><left><left>
" Jump to previous buffer
nnoremap # :b#<cr>
" Paste with initial space
nnoremap <leader>p a<space><esc>p
" Break long line up to the set text wrapping length
nnoremap <leader>b 0v$gq

" ---Setup Vundle---
filetype off                  " required

" set the runtime path to include Vundle and initialize
call plug#begin()

" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')
" let Vundle manage Vundle, required
Plug 'gmarik/Vundle.vim'

" add all your plugins here (note older versions of Vundle
" used Bundle instead of Plugin)

" General plugins
Plug 'valloric/YouCompleteMe', { 'do': 'python3.9 ./install.py', 'commit': 'd98f896' }
Plug 'SirVer/ultisnips'
Plug 'tpope/vim-commentary'
Plug 'airblade/vim-gitgutter'
Plug 'morhetz/gruvbox'
Plug 'embear/vim-localvimrc'
Plug 'itchyny/lightline.vim'
Plug 'skywind3000/asyncrun.vim'
Plug 'dense-analysis/ale'

" .py plugins
Plug 'vim-scripts/indentpython.vim'

" .tex plugins
Plug 'lervag/vimtex'

" .rs plugins
Plug 'rust-lang/rust.vim'

" .fish plugins
Plug 'dag/vim-fish'

call plug#end()

" Jump to next ALE linting error.
nnoremap <leader>aj :ALENext<cr>
nnoremap <leader>ak :ALEPrevious<cr>

" Write with W
command! W write
" Remove trailing whitespace upon save
autocmd BufWritePre * :%s/\s\+$//e
" Save a file as soon as it is created
autocmd BufNewFile * :write

" Color configuration
if (empty($TMUX))
    if (has("nvim"))
        let $NVIM_TUI_ENABLE_TRUE_COLOR=1
    endif
    if (has("termguicolors"))
        set termguicolors
    endif
endif

function AddStamp()
    if &filetype != ''
        if (g:add_stamp == 1)
            let current_line = line('.')
            let current_col = col('.')
            let cstring = substitute(&commentstring, '\%\(s\)\@!', '\%', '')
            :normal gg
            if stridx(getline(2), 'Simon Hulse') == -1
                let current_line = current_line + 5
                :normal O<esc>dl
                :normal 4.
                call setline(2, printf(cstring, 'Simon Hulse'))
                call setline(3, printf(cstring, 'simonhulse@protonmail.com'))
                call setline(5, '')
            endif
            call setline(1, printf(cstring, expand('%:t')))
            call setline(4, printf(cstring, 'Last Edited: ' . strftime('%c')))
            call cursor(current_line, current_col)
        endif
    endif
endfunction

let g:add_stamp = 1
autocmd BufWritePre * :call AddStamp()

set background=dark
let g:gruvbox_contrast_dark='hard'
let g:gruvbox_contrast_light='hard'
let g:gruvbox_transparent_bg=1
colorscheme gruvbox
hi! Normal ctermbg=NONE guibg=NONE

" Trigger configuration. You need to change this to something other than
" <tab> if you use one of the following:
" - https://github.com/Valloric/YouCompleteMe
" - https://github.com/nvim-lua/completion-nvim
let g:UltiSnipsExpandTrigger="<Esc>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

let g:localvimrc_enable=1
let g:localvimrc_ask=0
let g:localvimrc_reverse=1
let g:localvimrc_sandbox=0
