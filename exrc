set nolock
set nu
set ai
set searchincr
set showmatch
set showmode
set extended
set verbose

" set tabstop=3
" set shiftwidth=3

" <UP> for command history
set cedit=OA

" map <F2> to write and make
map OQ :w:!make
" <F3>: interactive git commit
map OR :w:!git commit -s --interactive
