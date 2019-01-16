runtime bundle/vim-pathogen/autoload/pathogen.vim

let mapleader=" "
let g:pathogen_disabled = []
" call add(g:pathogen_disabled, "vim-ondemandhighlight")
execute pathogen#infect()

set nocompatible

filetype plugin on
filetype indent on

syntax on
set wildmenu

set incsearch
set ignorecase
set smartcase
set hlsearch

set hidden
set enc=UTF-8

set dir=/tmp

set textwidth=132
set colorcolumn=+1
set number
set laststatus=2
set noequalalways

set tabstop=3
set shiftwidth=3
set noexpandtab

set nobackup
set wrapscan

set nomodeline

set backspace=indent,eol,start

set ttimeoutlen=50
set lazyredraw
set ttyfast

" set mouse=a
set mouse=rn

" set background=dark
set background=light
set guifont=PragmataPro\ for\ Powerline\ 10
set guioptions-=mTr
set guioptions+=c
set guicursor=a:blinkon0
colorscheme old

map j gj
map k gk

nnoremap <Leader>c :close<CR>
nnoremap <Leader>d :bd<CR>
nnoremap <Leader>w :w<CR>
nnoremap <Leader>q :q<CR>

nnoremap <F2> :w<cr>:Dispatch<cr>
nnoremap <F3> :w !translate -no-ansi<cr>
vnoremap <F3> :w !translate -no-ansi<cr>
nnoremap <F4> :!translate -b -no-ansi<cr>
vnoremap <F4> :!translate -b -no-ansi<cr>
nnoremap <F5> :cprevious<cr>
nnoremap <F6> :cnext<cr>

nnoremap gQ {v}!par 72rj
vnoremap gQ :'<,'>!par 72rj

nnoremap Q <nop>
nnoremap q <nop>

nnoremap <F1> <Esc>
inoremap <F1> <Esc>
vnoremap <F1> <Esc>

imap <Nul> <Space>

" set spell spelllang=
set spellcapcheck-=.
nnoremap <F9> :setlocal spell spelllang=de<cr>
nnoremap <F10> :setlocal spell spelllang=en_us<cr>
nnoremap <F11> :setlocal spell spelllang=<cr>

exec "set listchars=tab:>\u2219,trail:\u2219,nbsp:~"
set list

set completeopt=menuone,menu,longest,preview
set complete=.,w,b,u,t,i ",kspell
set omnifunc=syntaxcomplete#Complete

augroup vimrc_autocmd
	autocmd!
	autocmd bufenter,bufread .pwman.rc setfiletype text
	autocmd bufenter,bufread *.md setfiletype mkd
	autocmd bufenter,bufread *.groff setfiletype nroff
	autocmd bufenter,bufread *.ms setfiletype nroff
	autocmd bufenter,bufread *.json setfiletype javascript
	autocmd bufenter,bufread *.sls setfiletype yaml
	autocmd bufenter,bufread *SCons* setfiletype python
	autocmd bufenter,bufread *.asd setfiletype lisp

	autocmd bufenter,bufread /usr/src/** setlocal ts=8
	autocmd bufenter,bufread /usr/src/** setlocal sw=8

	autocmd bufenter,bufread /usr/ports/** setlocal ts=8
	autocmd bufenter,bufread /usr/ports/** setlocal sw=8

	autocmd bufenter,bufread *.ledger setlocal ts=8
	autocmd bufenter,bufread *.ledger setlocal sw=2
	autocmd bufenter,bufread *.ledger setlocal et

	autocmd bufenter,bufread *.rst setlocal ts=4
	autocmd bufenter,bufread *.rst setlocal sw=4
	autocmd bufenter,bufread *.rst setlocal et

	autocmd filetype yaml setlocal et
	autocmd filetype yaml setlocal sw=2
	autocmd filetype yaml setlocal ts=2

	autocmd FileType python setlocal et
	autocmd FileType python setlocal sw=4
	autocmd FileType python setlocal ts=4

	autocmd FileType mail setlocal tw=72

	autocmd bufenter,bufread *Makefile* setlocal noet

	autocmd FileType tex :NoMatchParen
	au FileType tex setlocal nocursorline

	au VimEnter * RainbowParenthesesToggle
	au Syntax * RainbowParenthesesLoadRound
	au Syntax * RainbowParenthesesLoadSquare
	au Syntax * RainbowParenthesesLoadBraces
augroup END

let g:netrw_liststyle=3

""" From here on, only plugin and language specific settings
"" TOhtml
let g:html_ignore_folding=1
let g:html_line_ids=1

"" Airline
let g:airline#extensions#whitespace#enabled = 0
let g:airline#extensions#syntastic#enabled = 1
let g:airline_powerline_fonts = 1
" Simpler position view
let g:airline_section_z = airline#section#create(['%3p%%'])
let g:airline_theme = "powerlineish"

"" Rainbow
let g:rbpt_colorpairs = [
    \ ['brown',       'RoyalBlue3'],
    \ ['Darkblue',    'SeaGreen3'],
    \ ['darkgray',    'DarkOrchid3'],
    \ ['darkgreen',   'firebrick3'],
    \ ['darkcyan',    'RoyalBlue3'],
    \ ['darkred',     'SeaGreen3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['brown',       'firebrick3'],
    \ ['gray',        'RoyalBlue3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['Darkblue',    'firebrick3'],
    \ ['darkgreen',   'RoyalBlue3'],
    \ ['darkcyan',    'SeaGreen3'],
    \ ['darkred',     'DarkOrchid3'],
    \ ]

"" Tmuxline
let g:tmuxline_powerline_separators = 1

"" Fugitive
map <Leader>g :Gstatus<CR>

"" Hy
let g:hy_enable_conceal = 1
let g:hy_conceal_fancy = 1

"" [ngt]roff
augroup nroff
	setlocal tw=0
	setlocal spelllang=de
augroup END

"" Syntax highlighting for sh files
let g:is_kornshell=1
