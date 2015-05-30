#!/bin/ksh

function create_link {
	typeset target="${HOME}/.$1"

	if [ -e "$target" ]; then
		echo "$target already exists" 1>&2
		return 1
	fi

	echo "$target linked" 1>&2
	ln -s "`pwd`/$1" "$target"
}

git submodule init
git submodule update

create_link vimrc
create_link vim

create_link exrc

create_link kshrc
create_link profile

create_link xsession

create_link tmux.conf
create_link tmux-statusline-colors.conf
