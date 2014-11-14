#!/bin/ksh

date
export ENV=~/.kshrc

[ -e $ENV ] && . $ENV

export LC_CTYPE=en_US.UTF-8
export LC_MESSAGES=$LC_CTYPE
export WEBKIT_IGNORE_SSL_ERRORS="1"

eval $(gpg-agent -s --daemon --pinentry-program `which pinentry-gtk-2`)

# eval $(ssh-agent -s)
# ssh-add </dev/null

env | grep ^SSH > /tmp/ssh-agent

# set up SSH tunnel to university's mailserver
while true; do
	(ping -c1 -w1 unobtanium.de && ssh -fNL 2525:mail.upb.de:25 unobtanium.de) >/dev/null 2>&1
	sleep 5
done &

while true; do
	fetch-remote-maildir
	sleep $((60 * 10))
done &

# change the desktop wallpaper every two hours
while true; do
	bdselect
	sleep $((60 * 120))
done &

fetchmail &

# nice -n 20 bitcoind -dns -irc -upnp -daemon

redshift-gtk &
xsettingsd &
for d in /usr/local/lib/X11/fonts/*; do
	xset +fp $d
done
xset b off
xset fp rehash
xset r rate 240 20
xset dpms 120 180 240

xinput --set-prop Touchpad0 "Synaptics Palm Detection" 1
xinput --set-prop Touchpad0 "Synaptics Two-Finger Scrolling" 0 0

# syndaemon -i 0.75 -Rd
# synclient TapButton1=1 TapButton2=2 TapButton3=3 VertEdgeScroll=1 VertScrollDelta=45 HorizEdgeScroll=0 PalmMinZ=10
synclient TouchpadOff=1

xrdb -load ~/.Xdefaults
setxkbmap us intl-unicode
xmodmap ~/.xmodmap
xhost +localhost
# xidle -program "/usr/X11R6/bin/xlock -mode random" -timeout 300 &
xscreensaver &
# xcompmgr -n &
# compton -f -i 0.8 -b

if [ $(xrandr | grep connected | wc -l) == 2 ]; then
	xrandr --output VGA1 --auto
	xrandr --output LVDS1 --auto
	xrandr --output VGA1 --right-of LVDS1
fi

# real display DPI is 128, but that's just too big
xrandr --dpi 96

while sleep 1; do
	( echo "\tGregor Best\n--\n";
	fortune -s) > ~/.signature
done &

st -c mutt -e mutt &

# akonaditray &
# korganizer &
tkremind &
# tabbed -n surf > /tmp/tabbed.xid &
firefox &

statnot &
wmname LG3D
while true; do
	dwm
	sleep 1
done
