#!/data/data/com.termux/files/usr/bin/sh

# oldstable, stable, testing, unstable
BRANCH=stable
# base(258M), minbase(217M), buildd, fakechroot
VAR=minbase

if [ ! -d ~/debian-$BRANCH ] ; then
	ARCH=$(uname -m)
	case $ARCH in
		aarch64) ARCH=arm64 ;;
		x86_64) ARCH=amd64 ;;
		armv7l|arm81) ARCH=armhf ;;
		*) echo "Unsupported architecture $ARCH"; exit ;;
	esac
	pkg install -y debootstrap proot wget
	debootstrap \
		--variant=$VAR \
		--exclude=systemd \
		--arch=$ARCH \
		$BRANCH \
		debian-$BRANCH \
		http://ftp.debian.org/debian/
fi
unset LD_PRELOAD
proot \
	-0 \
	--link2symlink \
	-r ~/debian-$BRANCH \
	-w /root \
	-b /dev/ \
	-b /sys/ \
	-b /proc/ \
	-b /data/data/com.termux/files/home \
	/usr/bin/env -i \
	HOME=/root \
	TERM="xterm-256color" \
	PATH=/bin:/usr/bin:/sbin:/usr/sbin \
	/bin/bash --login
