#!/bin/ksh
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
function python_venv {
	if [ -z $VIRTUAL_ENV ]; then
		return
	fi
	echo -n $(basename "$VIRTUAL_ENV")
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
function rgb {
	# Map XTerm color cube coordinates to terminal color value
	# http://www.calmar.ws/vim/256-xterm-24bit-rgb-color-chart.html
	echo -n $((($1 * 36) + ($2 * 6) + $3 + 16))
}
C_WHITE=$(rgb 5 5 5)
C_BLACK=$(rgb 0 0 0)
function airline {
	typeset oldifs=$IFS
	IFS="
"
	typeset cprev=
	typeset orignum=$#
	while [ $# -gt 0 ]; do
		typeset num=$(($orignum - $#))
		typeset cnow=$1
		typeset txt=$(echo "$2" | sed -Ee 's/^[[:blank:]]+//' -e 's/[[:blank:]]+$//')
		if [ $num -gt 0 ]; then
			color $cnow $cprev 
		fi

		if [ "x$txt" != "x" ]; then
			color $cnow $C_WHITE " $txt "
		fi

		if [ $# -lt 3 ]; then
			color $C_WHITE $cnow 
			IFS=$oldifs
			return
		fi

		cprev=$cnow
		shift 2
	done
}

function prompt {
	typeset laststatus=$?
	if ! echo $TERM | grep -q 256color; then
		echo "$(neatpwd)"
		return
	fi

	typeset branch=$(scm_branch)
	typeset venv=$(python_venv)

	oldifs=$IFS
	IFS="
"

	set -A elems
	if [ $laststatus -ne 0 ]; then
		elems[${#elems[*]}]=$(rgb 3 0 0)
		elems[${#elems[*]}]="◊ $laststatus"
		elems[${#elems[*]}]=$(rgb 4 0 0)
		elems[${#elems[*]}]=" "
	fi

	elems[${#elems[*]}]=$(rgb 0 1 3)
	elems[${#elems[*]}]="$(hostname -s)"
	elems[${#elems[*]}]=$(rgb 0 2 4)
	elems[${#elems[*]}]=" "

	if [ "`uname`" = "OpenBSD" ] && `false`; then
		elems[${#elems[*]}]=$(rgb 3 1 0)
		elems[${#elems[*]}]="$(rtable)"
		elems[${#elems[*]}]=$(rgb 4 2 0)
		elems[${#elems[*]}]=" "
	fi

	if [ ! -z $venv ]; then
		elems[${#elems[*]}]=$(rgb 1 1 1)
		elems[${#elems[*]}]="$venv"
		elems[${#elems[*]}]=$(rgb 2 2 2)
		elems[${#elems[*]}]=" "
	fi

	elems[${#elems[*]}]=$(rgb 0 2 0)
	elems[${#elems[*]}]="$(neatpwd)"
	elems[${#elems[*]}]=$(rgb 0 3 0)
	elems[${#elems[*]}]=" "

	if [ ! -z "$branch" ]; then
		elems[${#elems[*]}]=$(rgb 3 0 0)
		elems[${#elems[*]}]=" $branch"
		elems[${#elems[*]}]=$(rgb 4 0 0)
		elems[${#elems[*]}]=" "
	fi

	airline ${elems[*]}
	IFS=$oldifs
}

function userchar {
	typeset chr="#"

	if [ $USER != "root" ]; then
		chr="$"
	fi

	if ! echo TERM | grep -q 256color; then
		echo $chr
		return
	fi

	echo "$(color 00 $(rgb 1 1 2) $chr)"
}

PS1='$(prompt)
$(color 00 $(rgb 1 1 2) "$(userchar)") '
# }}}

# aliases {{{
RSYNC_COMMON='rsync -hPr'
# alias rm='rm -rf'
alias cp=$RSYNC_COMMON
alias xmv="$RSYNC_COMMON --remove-source-files --delete-delay"
alias rsync=$RSYNC_COMMON
alias ..='cd ..'
alias ls='ls -F'
alias sudo='sudo -E'
alias m=mimehandler
alias top='top -HSs1'
# }}}

# history {{{
export HISTSIZE=200000
export HISTFILE=~/.history
# }}}

# env vars {{{
GOPATH=${HOME}/sourcecode/go
export GOPATH

PATH=${HOME}/bin:${PATH}:/sbin:/usr/sbin:/usr/local/sbin
PATH=${PATH}:/usr/local/games
PATH=${PATH}:/usr/games
PATH=${PATH}:/usr/local/jdk-1.7.0/bin
PATH=${PATH}:${GOPATH}/bin
export PATH

export LIMPRUNTIME=$HOME/.vim/limp/latest/
export BROWSER=$HOME/bin/mimehandler
if [ "$TERM" != "vt100" ]; then
	export EDITOR="vim"
	# export EDITOR="/usr/bin/vi"
else
	export EDITOR="ex"
fi
export FCEDIT=$EDITOR

export DOOMWADDIR=~/doom/iwads

export GROFF_TMAC_PATH=~/.groff/tmac
export GROFF_FONT_PATH=~/.groff/fonts

export AUTOMAKE_VERSION=1.15
export AUTOCONF_VERSION=2.69

export AUTOSSH_LOGLEVEL=0

export MTR_OPTIONS="-zbe"

if which opam 2>/dev/null >/dev/null; then
	eval `opam config env`
fi

export LESS='-RIMSN'

export PYTHONPATH=~/sourcecode/HyREPL
export JAVA_HOME=/usr/lib/jvm/java-1.7.0-openjdk-amd64
export MAVEN_OPTS='-Xmx1048m -XX:MaxPermSize=512m'

export LANG=en_US.UTF-8

export GUILE_LOAD_PATH="...:${HOME}/.guile"
# }}}

# perl stuff
eval $(perl -I ${HOME}/perl5/lib/perl5 -Mlocal::lib)

# shell options {{{
set -o emacs
# }}}

bind ^D=eot
bind ^Y=beginning-of-line
bind '[1~'=beginning-of-line
bind '[4~'=end-of-line
if [ "`uname`" = "OpenBSD" ]; then
	stty -ixon -ixoff ixany status ^T
fi
ulimit -c 0
