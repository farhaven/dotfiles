#!/bin/ksh
[ -z "$PS1" ] && return

# prompt {{{
is_scm_dir() {
	if [ -d "$2/.$1" ]; then
		return 0
	elif [ "$2" == "/" ]; then
		return 1
	fi
	d=$(dirname "$2")
	is_scm_dir "$1" "$d"
	return $?
}
scm_branch() {
	if is_scm_dir git "$(pwd)"; then
		branch=$(git branch | grep -e '^\*' | cut -d ' ' -f 2-)
		unmerged=$(git branch --no-merged 2>/dev/null | wc -l | tr -dc '0-9')
		if [[ $unmerged != 0 ]]; then
			echo "(git)(${branch})(inc:$unmerged)"
		else
			echo "(git)(${branch})"
		fi
		return 0
	fi

	if is_scm_dir hg "$(pwd)"; then
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

	if is_scm_dir bzr "$(pwd)"; then
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
	id -R
}
function python_venv {
	if [ -z "$VIRTUAL_ENV" ]; then
		return
	fi
	echo -n "$(basename "$VIRTUAL_ENV")"
}
function port_flavor {
	if [ -z "$FLAVOR" ]; then
		return
	fi
	echo -n "$FLAVOR"
}
function color {
	if [ "$TERM" == "vt100" ]; then
		shift 2
		echo $@
		return
	fi

	# background, then foreground
	echo -n ""
	if [ "$1" != "00" ]; then
		echo -n "[48;5;${1}m"
	fi
	if [ "$2" != "00" ]; then
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
# C_BLACK=$(rgb 0 0 0)
function airline {
	typeset oldifs=$IFS
	IFS="
"
	typeset cprev=
	typeset orignum=$#
	while [ $# -gt 0 ]; do
		typeset num=$((orignum - $#))
		typeset cnow=$1
		typeset txt=$(echo "$2" | sed -Ee 's/^[[:blank:]]+//' -e 's/[[:blank:]]+$//')
		if [ $num -gt 0 ]; then
			color "$cnow" "$cprev" 
		fi

		if [ "x$txt" != "x" ]; then
			color "$cnow" "$C_WHITE" " $txt "
		fi

		if [ $# -lt 3 ]; then
			color "$C_WHITE" "$cnow" 
			IFS=$oldifs
			return
		fi

		cprev=$cnow
		shift 2
	done
}

function prompt {
	typeset laststatus=$?
	if ! echo "$TERM" | grep -q 256color; then
		neatpwd
		return
	fi

	typeset branch=$(scm_branch)
	typeset venv=$(python_venv)
	typeset flavor=$(port_flavor)

	oldifs=$IFS
	IFS="
"

	set -A elems
	if [ $laststatus -ne 0 ]; then
		elems[${#elems[*]}]=$(rgb 4 0 0)
		elems[${#elems[*]}]="◊ $laststatus"
		elems[${#elems[*]}]=$(rgb 3 0 0)
		elems[${#elems[*]}]=" "
	fi

	elems[${#elems[*]}]=$(rgb 0 2 4)
	elems[${#elems[*]}]="$(hostname -s)"
	elems[${#elems[*]}]=$(rgb 0 1 3)
	elems[${#elems[*]}]=" "

	elems[${#elems[*]}]=$(rgb 3 0 3)
	elems[${#elems[*]}]="$(date '+%d %H%MJ %b%y')"
	elems[${#elems[*]}]=$(rgb 2 0 2)
	elems[${#elems[*]}]=" "

	if [ "$(uname)" = "OpenBSD" ]; then
		elems[${#elems[*]}]=$(rgb 4 2 0)
		elems[${#elems[*]}]="$(rtable)"
		elems[${#elems[*]}]=$(rgb 3 1 0)
		elems[${#elems[*]}]=" "

		if [ ! -z "$flavor" ]; then
			elems[${#elems[*]}]=$(rgb 2 2 2)
			elems[${#elems[*]}]="$flavor"
			elems[${#elems[*]}]=$(rgb 1 1 1)
			elems[${#elems[*]}]=" "
		fi
	fi

	if [ ! -z "$venv" ]; then
		elems[${#elems[*]}]=$(rgb 2 2 2)
		elems[${#elems[*]}]="$venv"
		elems[${#elems[*]}]=$(rgb 1 1 1)
		elems[${#elems[*]}]=" "
	fi

	elems[${#elems[*]}]=$(rgb 0 3 0)
	elems[${#elems[*]}]="$(neatpwd)"
	elems[${#elems[*]}]=$(rgb 0 2 0)
	elems[${#elems[*]}]=" "

	if [ ! -z "$branch" ]; then
		elems[${#elems[*]}]=$(rgb 4 0 0)
		elems[${#elems[*]}]=" $branch"
		elems[${#elems[*]}]=$(rgb 3 0 0)
		elems[${#elems[*]}]=" "
	fi

	airline ${elems[*]}
	IFS=$oldifs
}

function userchar {
	typeset chr="#"

	if [ "$USER" != "root" ]; then
		chr="|"
	fi

	if ! echo TERM | grep -q 256color; then
		echo $chr
		return
	fi

	color 00 "$(rgb 1 1 2)" "$chr"
}

PS1='$(prompt)
$(color 00 $(rgb 1 1 2) "$(userchar)") '
function dpwd {
	# Lol
	pwd | sed -e 's,/,\\,g'
}
# Powershell style prompt. Just for shits & giggles
# PS1='PS C:$(dpwd)$(scm_branch)> '
# }}}

# aliases {{{
export RSYNC_COMMON='rsync -hPr'
# alias rm='rm -rf'
alias cp="\$RSYNC_COMMON"
alias xmv="\$RSYNC_COMMON --remove-source-files --delete-delay"
alias rsync="\$RSYNC_COMMON"
alias ..='cd ..'
alias ls='ls -F'
alias sudo='sudo -E'
alias m=mimehandler
alias cvs='cvs -q'
alias ed='rlwrap -pgreen -n -c ed -p">" '
if [ "$(uname)" == "OpenBSD" ]; then
	alias top='top -CHSs1'
	alias sudo=doas
	alias watch=iwatch
fi
function dtop {
	typeset container=$1
	shift
	docker exec -it "$container" sh -c "env TERM=vt220 top $@"
}
alias dadjoke='curl https://icanhazdadjoke.com; echo'
# }}}

# history {{{
export HISTSIZE=200000
export HISTFILE=~/.history
export HISTCONTROL="ignoredups"
# }}}

# env vars {{{
# Rust
if [[ -e "${HOME}/.cargo/env" ]]; then
	. "${HOME}/.cargo/env"
fi

LUA_PATH="${HOME}/.lua/?.lua;${HOME}/sourcecode/lunajson/src/?.lua;;"
export LUA_PATH

GOPATH=${HOME}/go
export GOPATH

PATH=${PATH}:"/Applications/VMware Fusion.app/Contents/Library"
PATH=${HOME}/bin:/sbin:/usr/sbin:/usr/local/sbin
PATH=${PATH}:/usr/local/bin:/bin:/usr/bin
PATH=${PATH}:/usr/X11R6/bin
PATH=${PATH}:/usr/local/games
PATH=${PATH}:/usr/games
PATH=${PATH}:/usr/local/jdk-1.8.0/bin
PATH=${PATH}:${GOPATH}/bin
PATH=${PATH}:/Users/gbe/Library/Android/sdk/platform-tools
PATH=${PATH}:${HOME}/.cargo/bin
PATH=${PATH}:/usr/local/texlive/2015/bin/universal-darwin
PATH=${PATH}:/Library/Frameworks/Mono.framework/Commands/
PATH=${PATH}:~/.local/bin
export PATH

export LIMPRUNTIME=$HOME/.vim/limp/latest/
export BROWSER=$HOME/bin/mimehandler
export EDITOR="nvim"
export FCEDIT=$EDITOR

export DOOMWADDIR=~/doom/iwads

export GROFF_TMAC_PATH=~/.groff/tmac
export GROFF_FONT_PATH=~/.groff/fonts

export AUTOMAKE_VERSION=1.15
export AUTOCONF_VERSION=2.69

export AUTOSSH_LOGLEVEL=0

export MTR_OPTIONS="-zbe"

if which opam 2>/dev/null >/dev/null; then
	eval $(opam config env)
fi

export LESS='-RIMS -F -X'

export PYTHONPATH=~/sourcecode/HyREPL
export VIRTUAL_ENV_DISABLE_PROMPT=yes

# export JAVA_HOME=/usr/lib/jvm/java-1.7.0-openjdk-amd64
export MAVEN_OPTS='-Xmx1048m -XX:MaxPermSize=512m'

export LANG=en_US.UTF-8

export GPG_TTY=$(tty)

export GUILE_LOAD_PATH="...:${HOME}/.guile"

if [ "$(uname)" == "Darwin" ]; then
	export GIT_SSL_CAINFO=/etc/ssl/certs.pem
fi

if [ -e ~/perl5 ]; then
	eval $(perl -I ~/perl5/lib/perl5/ -Mlocal::lib)
fi

# Fool XDG applications into not creating Downloads/Desktops/Documents folders
export XDG_DOWNLOAD_DIR="${HOME}/downloads"
export XDG_DESKTOP_DIR="${HOME}/.cache/Desktop"
export XDG_DOCUMENTS_DIR="${HOME}"
# }}}

# shell options {{{
set -o emacs
# }}}

bind ^D=eot
bind ^Y=beginning-of-line
bind '[1~'=beginning-of-line
bind '[4~'=end-of-line
stty -ixon -ixoff ixany
if [ "$(uname)" = "OpenBSD" ]; then
	stty status ^T
fi
# ulimit -c 0

# Completions
# set -A complete_kill_1 -- -9 -HUP -INFO -KILL -TERM

# set -A complete_vmctl_1 -- console load reload start stop reset status
# set -A complete_vmctl_2 -- $(vmctl status 2>/dev/null | awk '!/NAME/{print $NF}')

# set -A complete_mtr -- heise.de unobtanium.de 8.8.8.8 8.8.4.4
# set -A complete_ping -- heise.de unobtanium.de 8.8.8.8 8.8.4.4

function gen_complete_ifconfig {
    ifconfig | awk '/^[a-z]/{ print $1 } /groups:/{ for(i=2; i<=NF; i++) { print $i }}' | tr -d : | sort -u
}
set -A complete_ifconfig_1 -- $(gen_complete_ifconfig)
set -A complete_ifconfig_2 -- up down inet nwid create scan join

# set -A complete_doas -- ifconfig route vi kill dhclient

# set -A complete_git_1 -- $(find /usr/local/libexec/git -type f 2>/dev/null | xargs -n1 basename | grep -v '^git$' | sed -e 's/^git-//')
