" TODO:
" - [ ] Toggle parent items
" - [ ] Multitline items

function! ToggleItem()
	let pos = getpos(".")
	let line = getline(line("."))
	if line =~ '\[ \]'
		exe 's/\[ \]/\[X\]/'
	elseif line =~ '\[X\]'
		exe 's/\[X\]/\[ \]/'
	endif
	call cursor(pos[1], pos[2])
endfunction

nmap <leader><Tab> :call ToggleItem()<CR>
