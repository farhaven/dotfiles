#!/usr/bin/perl

use strict;
use POSIX qw(strftime);

sub dwm_mpd {
	my $artist = qx(mpc -qf "%artist%" current);
	my $title  = qx(mpc -qf "%title%" current);
	my @info;
	open(FH, "mpc|");
	while(<FH>) {
		push @info, $_;
	}
	close(FH);
	if (scalar(@info) lt 3) {
		return "";
	}
	my $artist = substr($artist, 0, 30);
	$artist =~ s/[\t\n]//g;
	my $title = substr($title, 0, 35);
	$title =~ s/[\t\n]//g;
	my @state = split(' ', $info[1]);
	chomp($title);
	if ($state[0] eq "[playing]") {
		return $artist . " - " . $title . " " . $state[3] . "  ";
	}
	# return $state[0] . " " . $title . " " . $state[3] . "  ";
	return "";
}

sub dwm_apm { # {{{
	my $charge = int(qx(apm -l));
	my $ac = int(qx(apm -a));
	my $desc = int(qx(apm -b));
	my $time = qx(apm -m);

	return "" if (($charge >= 94) and ($ac == 1));

	my $rv = "$charge%";
	if (($desc eq 2) && ($ac eq 0)) {
		$rv .= " /!\\";
	} elsif ($ac eq 1) {
		$rv .= " ▴";
	} else {
		$rv .= " ▾";
	}

	if ($time ne "unknown\n") {
		$time = int($time);
		$rv .= sprintf(" %d:%02d", $time / 60, $time % 60);
	}

	return $rv . "  ";
} # }}}

# network {{{
sub device_status {
	my $dev = shift();
	open(FH, "ifconfig " . $dev . "|");
	while (<FH>) {
		if (m/^[[:space:]]status: (.+)/) {
			close(FH);
			return $1;
		}
	}
	close(FH);
}

sub addrfam_available {
	my $fams = "";

	foreach my $f (("inet6", "inet")) {
		open(FH, "route -n show -$f 2>&1|");
		while (<FH>) {
			if (m/^default/) {
				$fams .= "4" if ($f eq "inet");
				$fams .= "6" if ($f eq "inet6");
				last;
			}
		}
		close(FH);
	}

	return $fams;
}

sub dwm_net {
	my $trunk_active = "none";

	open(FH, "ifconfig trunk0|");
	while (<FH>) {
		if (m/trunkport ([a-z0-9]+).*active/) {
			$trunk_active = $1;
		}
	}
	close(FH);

	if ($trunk_active eq "iwn0") {
		open(FH, "ifconfig iwn0|");
		while (<FH>) {
			if (m/nwid ([`a-zA-Z0-9 "!-\._]+) chan/) {
				$trunk_active = $1;
				$trunk_active =~ s/^"//g;
				$trunk_active =~ s/"$//g;
			}
		}
		close(FH);

		$trunk_active = " " . $trunk_active;
	}
	if ($trunk_active ne "none") {
		$trunk_active .= " " . addrfam_available();
	}
	return $trunk_active . "  ";
}
# }}}

sub dwm_date { # {{{
	return strftime("%H:%M %d-%m", localtime);
}
# }}}

sub dwm_fmt { # {{{
	my $file = shift;
	return "" if not -e $file;

	open(FH, $file);
	my $rv = <FH>;
	close(FH);

	chomp($rv);

	return $rv . "  ";
} # }}}

my $dbus_notification = ""; # {{{
if ($#ARGV == 0) {
	$dbus_notification = $ARGV[0];
	chomp($dbus_notification);
	$dbus_notification =~ s/\<[^<>]*\>//g;
	$dbus_notification =~ s/\<[^>]*$//g;
	$dbus_notification .= "  ";
}
print $dbus_notification;
# }}}

print dwm_mpd();
print dwm_apm();
print dwm_net();
print dwm_date();
print "\n";
