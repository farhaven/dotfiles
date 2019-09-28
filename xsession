#!/bin/ksh

date
export ENV=~/.kshrc

# shellcheck disable=SC1090
[ -e $ENV ] && . $ENV

# shellcheck disable=SC2046
eval $(gpg-agent -s --daemon --pinentry-program $(which pinentry-gtk-2))

env | grep ^SSH > /tmp/ssh-agent

# shellcheck disable=SC1117
mount | grep -q "^mfs.*\.cache" || doas mount -t mfs -o -s2G swap ~/.cache

# change the desktop wallpaper every two hours
# while true; do
# 	bdselect
# 	sleep $((60 * 120))
# done &

# xcompmgr -c -f -D 4 2>/dev/null &
compton -b
xsettingsd &
for d in /usr/local/share/fonts/mscorefonts /usr/local/lib/X11/fonts/*; do
	xset +fp "$d"
done
xset b off
xset fp rehash
# xset r rate 240 20
xset dpms 120 180 240

syndaemon -i 0.2 -d
synclient PalmDetect=1
synclient PalmMinWidth=4
synclient PalmMinZ=100
synclient TapButton1=1
synclient TapButton2=3
synclient TapButton3=2
synclient VertScrollDelta=-100
synclient HorizScrollDelta=-100
synclient HorizTwoFingerScroll=1
synclient LockedDrags=1
synclient LockedDragTimeout=2500

xrdb -load ~/.Xdefaults
setxkbmap us intl-unicode
xmodmap ~/.xmodmap
xhost +localhost
autocutsel -fork

xscreensaver &
/usr/local/lib/xfce4/notifyd/xfce4-notifyd &
xsetroot -name "$(status)"
(while sleep 5; do xsetroot -name "$(status)"; done) &

xterm -t neomutt -e neomutt &
xterm -t irrsi -e mosh unobtanium.de &
xterm -t localhost -e tmux attach &

firefox &

wmname LG3D

# shellcheck disable=SC2039
xfce4-power-manager &

while true; do
	if [ -O /tmp/wm.gbe ]; then
		# shellcheck disable=SC2091
		$(cat /tmp/wm.gbe)
	else
		dwm-gbe
		# ctwm
	fi
	sleep 1
done
