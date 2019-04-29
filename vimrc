runtime bundle/vim-pathogen/autoload/pathogen.vim

let mapleader=" "
let maplocalleader="\\"
let g:pathogen_disabled = []
" call add(g:pathogen_disabled, "vim-ondemandhighlight")
execute pathogen#infect()

set nocompatible

filetype plugin on
filetype indent on

syntax on
set wildmenu

set inccommand=nosplit  " Show preview for search/replace
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
set guicursor=a:blinkon0
" colorscheme old
colorscheme kalahari
" colorscheme xcode-default

map j gj
map k gk

" Keep visual selection during shift, like emacs' evil mode
vnoremap < <gv
vnoremap > >gv

" Use ]e and [e to jump between errors
nnoremap ]e :lnext<CR>
nnoremap [e :lprev<CR>

nnoremap <Leader>c :close<CR>
nnoremap <Leader>d :bd<CR>
nnoremap <Leader>w :w<CR>
nnoremap <Leader>q :q<CR>

nnoremap <F2> :w<cr>:Dispatch<cr>
nnoremap M :w<cr>:Dispatch make<cr>
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
	autocmd bufenter,bufread Vagrantfile setfiletype ruby

	autocmd bufenter,bufread /usr/src/** setlocal sw=8
	autocmd bufenter,bufread /usr/src/** setlocal ts=8

	autocmd bufenter,bufread /usr/ports/** setlocal ts=8
	autocmd bufenter,bufread /usr/ports/** setlocal sw=8

	autocmd bufenter,bufread *.rst setlocal ts=4
	autocmd bufenter,bufread *.rst setlocal sw=4
	autocmd bufenter,bufread *.rst setlocal et

	autocmd FileType python setlocal et
	autocmd FileType python setlocal sw=4
	autocmd FileType python setlocal ts=4

	autocmd FileType javascript setlocal et
	autocmd FileType javascript setlocal sw=2
	autocmd FileType javascript setlocal ts=2

	autocmd FileType scss setlocal et
	autocmd FileType scss setlocal sw=2
	autocmd FileType scss setlocal ts=2

	autocmd FileType mail setlocal tw=72

	autocmd bufenter,bufread *Makefile* setlocal noet

	au FileType tex :NoMatchParen
	au FileType tex setlocal nocursorline
	au FileType tex syn region texZone start="\\begin{lstlisting}" end="\\end{lstlisting}\|%stopzone\>"
	au FileType tex syn region texZone  start="\\lstinputlisting" end="{\s*[a-zA-Z/.0-9_^]\+\s*}"
	au FileType tex syn match texInputFile "\\lstinline\s*\(\[.*\]\)\={.\{-}}" contains=texStatement,texInputCurlies,texInputFileOpt

	au VimEnter * RainbowParenthesesToggle
	au Syntax * RainbowParenthesesLoadRound
	au Syntax * RainbowParenthesesLoadSquare
	au Syntax * RainbowParenthesesLoadBraces

	au FileType qf setlocal nolist
	au FileType qf map <buffer> q :close<CR>

	au FileType help map <buffer> q :close<CR>
augroup END

let g:netrw_liststyle=3

""" From here on, only plugin and language specific settings
"" Neomake
call neomake#configure#automake('nrwi', 500)
let g:neomake_python_exe = "python3"

"" Latex
let g:tex_flavor='latex'

"" Airline
let g:airline#extensions#whitespace#enabled = 0
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
" Simpler position view
let g:airline_section_z = airline#section#create(['%3p%%'])
" let g:airline_theme = "one"
let g:airline_theme = "edocx"

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
map <Leader>gs :Gstatus<CR>

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
augroup sh
	" Embedded AWK scripts enclosed in a Here-Doc started with <<EO_AWK
	autocmd FileType sh call SyntaxRange#Include('<<?\("\)EO_AWK\1', "^EO_AWK", "awk", "shHereDoc")
augroup END

"" Django
augroup django_autocmd
	autocmd FileType htmldjango syn clear djangoError
	autocmd FileType htmldjango setlocal ts=2
	autocmd FileType htmldjango setlocal sw=2
	autocmd FileType htmldjango setlocal et
augroup END

"" Org-Mode
" Indent body text after headings
let g:org_indent=0                      " If this is on, adding new items to lists behaves weirdly
let g:org_heading_shade_leading_stars=0 " Looks confusing if enabled
let g:org_tag_column=100                " More space for tags next to headings
augroup org
	autocmd FileType org setlocal ts=2
	autocmd FileType org setlocal sw=2
	autocmd FileType org setlocal tw=132

	autocmd FileType org call SyntaxRange#Include("#+BEGIN_SRC sh", "#+END_SRC", "sh")
	autocmd FileType org call SyntaxRange#Include("#+BEGIN_SRC yaml", "#+END_SRC", "ansible")
augroup END

"" YAML
augroup YAML
	autocmd filetype yaml setlocal et
	autocmd filetype yaml setlocal sw=2
	autocmd filetype yaml setlocal ts=2

"" Ledger
augroup ledger
	autocmd bufenter,bufread *.ledger setlocal ts=8
	autocmd bufenter,bufread *.ledger setlocal sw=2
	autocmd bufenter,bufread *.ledger setlocal et
augroup END
