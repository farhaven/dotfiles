#!/usr/local/bin/mksh
[ -z "$PS1" ] && return

# prompt {{{
is_scm_dir() {
	if [ -d "$2/.$1" ]; then
		return 0
	elif [ "$2" == "/" ]; then
		return 1
	fi
	is_scm_dir $1 $(dirname "$2")
	return $?
}
scm_branch() {
	if is_scm_dir git $(pwd); then
		branch=$(git branch | grep -e '^\*' | cut -d ' ' -f 2-)
		echo "(git)(${branch})"
		return 0
	fi

	if is_scm_dir hg $(pwd); then
		branch=$(hg branch)
		echo "(hg)(${branch})"
		return 0
	fi

	# if is_scm_dir svn $(pwd); then
	if [ -d ".svn" ]; then
		branch=$(svn info | grep ^Rev | cut -d' ' -f2)
		echo "(svn)(${branch})"
		return 0
	fi

	if is_scm_dir bzr $(pwd) ; then
		branch=$(bzr log | grep '^rev' | head -n1 | cut -d' ' -f2)
		echo "(bzr)(${branch})"
		return 0
	fi
	return 1
}
function neatpwd {
	typeset d=${PWD:-?} n;
	n=${#d}
	d=${d##${HOME}}
	[[ ${#d} -lt $n ]] && d="~$d"

	echo -n "$d"
}
function rtable {
	ps axo rtable,pid | grep " $$\$" | sed -Ee 's/ +//' -e 's/ .*//'
}
function color {
	if [ "$TERM" == "vt100" ]; then
		shift 2
		echo $@
		return
	fi

	# background, then foreground
	echo -n ""
	if [ $1 != "00" ]; then
		echo -n "[48;5;${1}m"
	fi
	if [ $2 != "00" ]; then
		echo -n "[38;5;${2}m"
	fi
	shift 2
	echo -n "$@[00m"
}
function colorcube {
	# Map XTerm color cube coordinates to terminal color value
	# http://www.calmar.ws/vim/256-xterm-24bit-rgb-color-chart.html
	echo -n $((($1 * 36) + ($2 * 6) + $3 + 16))
}
C_WHITE=$(colorcube 5 5 5)
function prompt {
	if ! echo $TERM | grep -q 256color; then
		echo "$(neatpwd)"
		return
	fi

	typeset laststatus=$?
	typeset branch=$(scm_branch)

	if [ $laststatus -ne 0 ]; then
		color $(colorcube 3 0 0) $C_WHITE " ◊ $laststatus "
		color 25 $(colorcube 3 0 0) 
	fi

	color 25 $C_WHITE " $(hostname -s) "

	if [ "`uname`" = "OpenBSD" ]; then
		color $(colorcube 3 1 0) 25 
		color $(colorcube 3 1 0) $C_WHITE " $(rtable) "
		color $(colorcube 0 2 0) $(colorcube 3 1 0) 
	else
		color $(colorcube 0 2 0) 25 
	fi

	color $(colorcube 0 2 0) $C_WHITE " $(neatpwd) "
	if [ -z "$branch" ]; then
		color 00 $(colorcube 0 2 0) 
	else
		color $(colorcube 3 0 0) $(colorcube 0 2 0) 
		color $(colorcube 3 0 0) $C_WHITE "  $branch "
		color 00 $(colorcube 3 0 0) 
	fi
}
PS1='$(prompt)
$(color 00 $(colorcube 1 1 2) "$") '
# }}}

# aliases {{{
RSYNC_COMMON='rsync -hPr'
alias rm='rm -rf'
alias cp=$RSYNC_COMMON
alias xmv="$RSYNC_COMMON --remove-source-files --delete-delay"
alias rsync=$RSYNC_COMMON
alias less='less -R'
alias ..='cd ..'
alias ls='ls -F'
alias sudo='sudo -E'
alias m=mimehandler
# }}}

# history {{{
export HISTSIZE=200000
export HISTFILE=~/.history
# }}}

# env vars {{{
PATH=${HOME}/bin:${PATH}
PATH=${PATH}:/usr/local/games
PATH=${PATH}:/usr/games
PATH=${PATH}:/usr/local/jdk-1.7.0/bin
export PATH

GOPATH=${HOME}/sourcecode/go
export GOPATH

export LIMPRUNTIME=$HOME/.vim/limp/latest/
export BROWSER=$HOME/bin/mimehandler
if [ "$TERM" != "vt100" ]; then
	# export EDITOR="vim"
	export EDITOR="/usr/bin/vi"
else
	export EDITOR="ex"
fi
export FCEDIT=$EDITOR

export LC_CTYPE=en_US.UTF-8
export LC_MESSAGES=$LC_CTYPE

export DOOMWADDIR=~/doom/iwads

export GTK2_RC_FILES="/home/gregor/.gtkrc.mine"

export GROFF_TMAC_PATH=~/.groff/tmac
export GROFF_FONT_PATH=~/.groff/fonts

export AUTOMAKE_VERSION=1.14
export AUTOCONF_VERSION=2.69

export AUTOSSH_LOGLEVEL=0

if which opam 2>/dev/null >/dev/null; then
	eval `opam config env`
fi
# }}}

# shell options {{{
set -o emacs
# }}}

bind ^D=eot
bind ^Y=beginning-of-line
if [ "`uname`" = "OpenBSD" ]; then
	stty -ixon -ixoff ixany status ^T
fi
