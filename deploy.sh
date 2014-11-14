#!/bin/ksh

function create_link {
	if [ -e "${HOME}/.$1" ]; then
		echo "${HOME}/.$1 already exists"
		return 1
	fi

	ln -s "`pwd`/$1" "${HOME}/.$1"
}

git submodule init
git submodule update

create_link vimrc
create_link vim

create_link exrc

create_link kshrc
create_link profile

create_link xsession
create_link status.pl

create_link tmux.conf
create_link tmux-statusline-colors.conf
