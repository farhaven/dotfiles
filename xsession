#!/bin/ksh

date
export ENV=~/.kshrc

[ -e $ENV ] && . $ENV

eval $(gpg-agent -s --daemon --pinentry-program `which pinentry-gtk-2`)

env | grep ^SSH > /tmp/ssh-agent

mount | grep -q "^tmpfs.*\.cache" || mount -t tmpfs tmpfs ~/.cache

# change the desktop wallpaper every two hours
while true; do
	bdselect
	sleep $((60 * 120))
done &

hy ~/sourcecode/stats/timestamps.hy &

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

# stalonetray --geometry 1x1-0-0 --grow-gravity W &
autocutsel -fork
xscreensaver &
compton -b
dunst -follow keyboard -geometry 0x5-0+0 -fn "PragmataPro for Powerline 10" -nb "#666666" -nf "#ffffff" &
# redshift-gtk &
# sct > /dev/null &
# (while sleep 5; do status; done | dzen2 -p -ta r -e 'onstart=lower' -fn "PragmataPro for Powerline:size=9") &
(while sleep 5; do xsetroot -name "`status`"; done) &

while sleep 1; do
	( echo "\tGregor\n--\n";
	fortune -sa) > ~/.signature
done &

st -c mutt -e mutt &

tkremind &
# firefox &
chrome &

wmname LG3D

while true; do
	if [ -O /tmp/wm.gbe ]; then
		`cat /tmp/wm.gbe`
	else
		dwm-gbe
	fi
	# twm-tweaked
	# fvwm
	sleep 1
done
