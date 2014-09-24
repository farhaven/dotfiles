#!/bin/ksh

function create_link {
	if [ -f "${HOME}/.$1" ]; then
		echo "${HOME}/.$1 is a regular file"
		return 1
	fi

	rm -f "${HOME}/.$1"
	ln -s "`pwd`/$1" "${HOME}/.$1"
}

create_link vimrc
