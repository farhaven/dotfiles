#!/bin/ksh

date
export ENV=~/.kshrc

[ -e $ENV ] && . $ENV

export LC_CTYPE=en_US.UTF-8
export LC_MESSAGES=$LC_CTYPE
export WEBKIT_IGNORE_SSL_ERRORS="1"

eval $(gpg-agent -s --daemon --pinentry-program `which pinentry-gtk-2`)

env | grep ^SSH > /tmp/ssh-agent

# change the desktop wallpaper every two hours
while true; do
	bdselect
	sleep $((60 * 120))
done &

fetchmail &

hy ~/sourcecode/stats/stats.hy &

redshift-gtk &
xsettingsd &
for d in /usr/local/lib/X11/fonts/*; do
	xset +fp $d
done
xset b off
xset fp rehash
xset r rate 240 20
xset dpms 120 180 240

xrdb -load ~/.Xdefaults
setxkbmap us intl-unicode
xmodmap ~/.xmodmap
xhost +localhost
xscreensaver &
# xcompmgr -n &
compton --vsync opengl --unredir-if-possible --backend glx --glx-no-stencil --glx-swap-method buffer-age --glx-no-rebind-pixmap -b

if [ $(xrandr | grep connected | wc -l) == 2 ]; then
	xrandr --output VGA1 --auto
	xrandr --output LVDS1 --auto
	xrandr --output VGA1 --right-of LVDS1
fi

while sleep 1; do
	( echo "\tGregor Best\n--\n";
	fortune -s) > ~/.signature
done &

st -c mutt -e mutt &

tkremind &
firefox &

statnot &
wmname LG3D
while true; do
	dwm
	sleep 1
done
