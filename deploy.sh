#!/bin/ksh

function create_link {
	if [ -e "${HOME}/.$1" ]; then
		echo "${HOME}/.$1 already exists"
		return 1
	fi

	ln -s "`pwd`/$1" "${HOME}/.$1"
}

create_link vimrc
create_link kshrc
