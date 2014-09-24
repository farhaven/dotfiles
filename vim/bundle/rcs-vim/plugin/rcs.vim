" rcs.vim -- A wrapper around the RCS file management program
" Maintainer: Gregor Best <gbe@unobtanium.de>
" Version:    $Revision: 1.1 $

if exists("g:loaded_rcs")
	finish
endif
let g:loaded_rcs = 1

command -nargs=? -complete=buffer -complete=file Ci :execute s:ci(<q-args>)

function s:ci(filename)
	let fname="%"
	if a:filename != ""
		let fname = a:filename
	endif

	" TODO: dispatch integration
	" TODO: show diff in vim
	" TODO: edit commit message in vim, pass to ci
	" TODO: reload file
	execute "w " . fname
	execute "!rcsdiff -u " . fname
	execute "!ci -l " . fname
endfunction
