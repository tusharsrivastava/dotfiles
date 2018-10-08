" dot file for my personal vim configuration
" Author        : Tushar Srivastava
" Created Date  : 5 October 2018
" Last Modified : 6 October 2018

" Base configuration
set modelines=5
"set nocompatible
set backspace=2
set number
set noshowmode
set mouse=a

" Don't write backup file if vim is being called by "crontab -e"
au BufWrite /private/tmp/crontab.* set nowritebackup nobackup
" Don't write backup file if vim is being called by "chpass"
au BufWrite /private/etc/pw.* set nowritebackup nobackup

" Plugin Setup
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'

" Installed Plugin List
Plugin 'itchyny/lightline.vim'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'tpope/vim-surround'
Plugin 'scrooloose/nerdtree'
Plugin 'mattn/emmet-vim'
Plugin 'srcery-colors/srcery-vim'
Plugin 'chiel92/vim-autoformat'
Plugin 'valloric/youcompleteme'
Plugin 'ervandew/supertab'
Plugin 'Xuyuanp/nerdtree-git-plugin'
Plugin 'airblade/vim-gitgutter'
Plugin 'w0rp/ale'
Plugin 'itchyny/vim-gitbranch'
Plugin 'plytophogy/vim-virtualenv'
Plugin 'shemerey/vim-project'

call vundle#end()

filetype off
filetype plugin indent on
set modeline
au filetype python set sw=4
au filetype python set ts=4
au filetype python set sts=4

set laststatus=2
set tabstop=4
set shiftwidth=4
set expandtab
set updatetime=500

" Configure Theme
syntax on
set t_Co=256
colorscheme srcery
let g:srcery_italic = 1

" Configure StatusLine Configuration
au colorscheme * hi vertsplit cterm=NONE ctermfg=Green ctermbg=NONE
au vimenter * hi statusline ctermbg=236 guibg=#303030
au vimenter * hi statuslinenc ctermbg=236 guibg=#303030
set fillchars+=vert:│

" Autoformatter Configuration
let g:autoformat_autoindent = 1
let g:autoformat_retab = 1
let g:autoformat_remove_trailing_spaces = 1

" Emmet Configuration
map <expr> <tab> emmet#expandAbbrIntelligent("\<tab>")

" ALE Configuration
let g:ale_sign_column_always = 1

" Git Gutter Configuration
let g:gitgutter_map_keys = 0

" Configure NERDTree
au stdinreadpre * let s:std_in=1
au vimenter * NERDTree
au vimenter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
au vimenter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif
au bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
let g:NERDTreeMinimalUI = 1
let g:NERDTreeDirArrows = 1
let g:NERDTreeAutoDeleteBuffer = 1
let g:NERDTreeHijackNetrw = 1
let g:NERDTreeIndicatorMapCustom = {
    \ "Modified"  : "✹",
    \ "Staged"    : "✚",
    \ "Untracked" : "✭",
    \ "Renamed"   : "➜",
    \ "Unmerged"  : "═",
    \ "Deleted"   : "✖",
    \ "Dirty"     : "✗",
    \ "Clean"     : "✔︎",
    \ 'Ignored'   : '☒',
    \ "Unknown"   : "?"
    \ }

" YouCompleteMe configuration
let g:ycm_collect_identifiers_from_tags_files = 1 " Let YCM read tags from Ctags file
let g:ycm_use_ultisnips_completer = 1 " Default 1, just ensure
let g:ycm_seed_identifiers_with_syntax = 1 " Completion for programming language's keyword
let g:ycm_complete_in_comments = 1 " Completion in comments
let g:ycm_complete_in_strings = 1 " Completion in string

" Configure LightLine Status
function! LightlineWarnings() abort
 let l:counts = ale#statusline#Count(bufnr(''))
 let l:all_errors = l:counts.error + l:counts.style_error
 let l:all_non_errors = l:counts.total - l:all_errors
 return l:counts.total == 0 ? '' : printf('%d ▲', all_non_errors)
endfunction

function! LightlineWrrors() abort
 let l:counts = ale#statusline#Count(bufnr(''))
 let l:all_errors = l:counts.error + l:counts.style_error
 let l:all_non_errors = l:counts.total - l:all_errors
 return l:counts.total == 0 ? '' : printf('%d ✗', all_errors)
endfunction

function! LightlineOK() abort
 let l:counts = ale#statusline#Count(bufnr(''))
 let l:all_errors = l:counts.error + l:counts.style_error
 let l:all_non_errors = l:counts.total - l:all_errors
 return l:counts.total == 0 ? '✓' : ''
endfunction

let g:lightline = {
\ 'colorscheme': 'wombat',
\ 'active': {
\   'left': [['mode', 'paste'], ['gitbranch', 'venv'], ['readonly', 'filename', 'modified']],
\   'right': [['lineinfo'], ['percent'], ['linter_warnings', 'linter_errors', 'linter_ok']]
\ },
\ 'inactive': {
\   'left': [],
\   'right': []
\ },
\ 'component_function': {
\   'linter_warnings': 'LightlineWarnings',
\   'linter_errors': 'LightlineWrrors',
\   'linter_ok': 'LightlineOK',
\   'gitbranch': 'gitbranch#name',
\   'venv': 'virtualenv#statusline'
\ },
\ 'component_type': {
\   'readonly': 'error',
\   'linter_warnings': 'warning',
\   'linter_errors': 'error',
\   'linter_ok': 'ok'
\ },
\ 'component_expand': {
\   'linter_warnings': 'LightlineWarnings',
\   'linter_errors': 'LightlineErrors',
\   'linter_ok': 'LightlineOK'
\ }
\}

augroup ale#lint
    au!
    au user ALELintPre call lightline#update()
    au user ALELintPost call lightline#update()
    au user ALEJobStarted call lightline#update()
    au user ALEFixPre call lightline#update()
    au user ALEFixPost call lightline#update()
augroup end

if !empty($VIRTUAL_ENV) || !empty($PROJECT_HOME)
    au vimenter * VirtualEnvActivate
endif
