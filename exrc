set nolock
set nu
set ai
set searchincr
set showmatch
set showmode
set extended
set verbose

set tabstop=4
set shiftwidth=4

" <UP> for command history
set cedit=OA
" <Down> for file completion
set filec=\	

" map <F2> to write and make
map OQ :w:!make
map [12~ :w:!make

" <F3>: interactive git commit
map OR :w:!git commit -s --interactive

" =: expand tabs
map = :%!expand -t 4

map gg 1G
map gq {!}par 72qj}
map gQ {!}par 72qj

map [D h
map [A k
map [C l
map [B j
