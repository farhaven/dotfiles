runtime bundle/vim-pathogen/autoload/pathogen.vim

let mapleader=" "
let g:pathogen_disabled = []
" call add(g:pathogen_disabled, "vim-airline")
call add(g:pathogen_disabled, "pycalc")
call add(g:pathogen_disabled, "paredit.vim")
call add(g:pathogen_disabled, "jedi-vim")
execute pathogen#infect()

set nocompatible

filetype plugin on
filetype indent on

syntax on
set wildmenu

set incsearch
set ignorecase
set smartcase

set foldmethod=indent
" set foldmethod=syntax
set foldlevelstart=2

set hidden
set enc=UTF-8

set colorcolumn=133
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

" helps in Clojure
set iskeyword+=-

" set mouse=a
set mouse=rn

set background=light
colorscheme old

map j gj
map k gk

nnoremap <Leader>c :close<CR>
nnoremap <Leader>d :bd<CR>
nnoremap <Leader>w :w<CR>
nnoremap <Leader>q :q<CR>

nnoremap <F2> :w<cr>:Dispatch<cr>
nnoremap <F3> :w<cr>:!exctags -R --sort=yes --fields=+iaS --extra=+q .<cr>
nnoremap <F5> :cprevious<cr>
nnoremap <F6> :cnext<cr>

nnoremap Q <nop>
nnoremap q <nop>

set spell spelllang=
nnoremap <F9> :setlocal spell spelllang=de<cr>
nnoremap <F10> :setlocal spell spelllang=en_us<cr>
nnoremap <F11> :setlocal spell spelllang=<cr>

exec "set listchars=tab:>-,trail:\uB7,nbsp:~"
set list

let g:stop_autocomplete=0
function! BetterComplete(type)
	if a:type == 'omni'
		if strpart(getline('.'), 0, col('.') - 1) =~ '^\s*$'
			let g:stop_autocomplete=1
			return "\<TAB>"
		elseif !pumvisible() && !&omnifunc
			return "\<C-X>\<C-O>\<C-P>"
		endif
	elseif a:type == 'keyword' && !pumvisible() && !g:stop_autocomplete
		return "\<C-X>\<C-N>\<C-P>"
	elseif a:type == 'next'
		if g:stop_autocomplete
			let g:stop_autocomplete=0
		else
			return "\<C-n>"
		endif
	endif
	return ''
endfunction
set completeopt=menuone,menu,longest,preview
set complete=.,w,b,u,t,i ",kspell
set omnifunc=syntaxcomplete#Complete
inoremap <silent><TAB> <C-R>=BetterComplete('omni')<CR><C-R>=BetterComplete('keyword')<CR><C-R>=BetterComplete('next')<CR>

augroup vimrc_autocmd
	autocmd!
	autocmd bufenter,bufread .pwman.rc setfiletype text
	autocmd bufenter,bufread *.md setfiletype mkd
	autocmd bufenter,bufread *.groff setfiletype groff
	autocmd bufenter,bufread *.ms setfiletype groff
	autocmd bufenter,bufread *.json setfiletype javascript
	autocmd bufenter,bufread *SCons* setfiletype python

	autocmd bufenter,bufread ~/work/** setlocal et
	autocmd bufenter,bufread ~/work/** setlocal ts=2
	autocmd bufenter,bufread ~/work/** setlocal sw=2
	autocmd FileType python setlocal ts=4
	autocmd FileType python setlocal sw=4

	autocmd bufenter,bufread *Makefile* setlocal noet

	autocmd FileType tex :NoMatchParen
	au FileType tex setlocal nocursorline

	au VimEnter * RainbowParenthesesToggle
	au Syntax * RainbowParenthesesLoadRound
	au Syntax * RainbowParenthesesLoadSquare
	au Syntax * RainbowParenthesesLoadBraces
	" These would be nice for C++11, but crap up on < and > for comparisons
	" au Syntax * RainbowParenthesesLoadChevrons
augroup END

let g:netrw_liststyle=3

""" From here on, only plugin and language specific settings
"" OCaml
let g:opamshare = substitute(system('opam config var share'), '\n$', '', '''')
execute "set rtp+=" . g:opamshare . "/merlin/vim"
execute "set rtp+=" . g:opamshare . "/merlin/vimbufsync"

augroup ocaml
	autocmd!
	autocmd FileType ocaml set expandtab
augroup END

"" VimWiki
let g:vimwiki_hl_headers=1
let g:vimwiki_folding='expr'
function! VimwikiLinkHandler(link)
	let link = a:link
	if link =~ "http://" || link =~ "https://" || link =~ "file://"
	else
		return 0
	endif

	let browser="~/bin/mimehandler"
	echom link
	try
		call system(browser .' "'. link . '" &')
		return 1
	catch
		echom "Failed to launch browser"
	endtry
	return 0
endfunction

"" Fireplace and other Clojure stuff
let g:clojure_align_multiline_strings = 1

"" Airline
let g:airline#extensions#whitespace#enabled = 0
let g:airline#extensions#syntastic#enabled = 1
let g:airline_powerline_fonts = 1
" Simpler position view
let g:airline_section_z = airline#section#create(['%3p%%'])
" let g:airline_theme = "base16"
" let g:airline_theme = "wombat"
" let g:airline_theme = "jellybeans"
" let g:airline_theme = "bubblegum"
let g:airline_theme = "powerlineish"
" let g:airline_theme = "serene"
" let g:airline_theme = "sol"
" let g:airline_theme = "understated"

"" Slimux
let g:slimux_select_from_current_window=1
map <Leader>s :SlimuxREPLSendLine<CR>
vmap <Leader>s :SlimuxREPLSendSelection<CR>

"" Vimux
map <Leader>vp :VimuxPromptCommand<CR>

"" Fugitive
map <Leader>g :Gstatus<CR>
