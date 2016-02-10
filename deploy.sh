#!/bin/ksh

function create_link {
	typeset source="$1"
	while [ $# -gt 0 ]; do
		typeset target="${HOME}/.$1"

		if [ -e "$target" ]; then
			echo "$target already exists" 1>&2
		else
			echo "$target linked" 1>&2
			ln -s "`pwd`/$source" "$target"
		fi

		shift
	done
}

create_link gitconfig

create_link vimrc
create_link vim

create_link exrc

create_link kshrc mkshrc
create_link profile

create_link xsession

create_link tmux.conf
create_link tmux-statusline-colors.conf

create_link dwm-gbe.scm

git submodule init
git submodule update

