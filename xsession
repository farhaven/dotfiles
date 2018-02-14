#!/bin/ksh

date
export ENV=~/.kshrc

[ -e $ENV ] && . $ENV

eval $(gpg-agent -s --daemon --pinentry-program `which pinentry-gtk-2`)

env | grep ^SSH > /tmp/ssh-agent

mount | grep -q "^mfs.*\.cache" || doas mount -t mfs -o -s300M swap ~/.cache

# change the desktop wallpaper every two hours
while true; do
	bdselect
	sleep $((60 * 120))
done &

hy ~/sourcecode/stats/timestamps.hy &

compton -b
xsettingsd &
for d in /usr/local/share/fonts/mscorefonts /usr/local/lib/X11/fonts/*; do
	xset +fp $d
done
xset b off
xset fp rehash
xset r rate 240 20
xset dpms 120 180 240

syndaemon -i 0.2 -d
synclient TapButton1=1
synclient TapButton2=3
synclient TapButton3=2
synclient VertScrollDelta=-100
synclient HorizScrollDelta=-100
synclient HorizTwoFingerScroll=1
synclient LockedDrags=1
synclient LockedDragTimeout=2500

keynav &

mpd

xrdb -load ~/.Xdefaults
setxkbmap us intl-unicode
xmodmap ~/.xmodmap
xhost +localhost
autocutsel -fork

xscreensaver &
dunst -follow keyboard -geometry 0x5-0+16 -fn "PragmataPro for Powerline 10" -nb "#666666" -nf "#ffffff" &
xsetroot -name "`status`"
(while sleep 5; do xsetroot -name "`status`"; done) &

st -c mutt -e mutt &

chrome &

# QSyncthingTray &

(cd ~/projects/powersnap; sh powersnap.sh 2>/dev/null) &

wmname LG3D

while true; do
	if [ -O /tmp/wm.gbe ]; then
		`cat /tmp/wm.gbe`
	else
		dwm-gbe
	fi
done
