#!/bin/bash
#
# description; #### currently only for debian based distros ####
#    automates the compilation & installation of three essential wifi cracking tools; hcxtools, hcxdumptool, & aircrack-ng
#
# usage;
#    sudo ./install_wificracktools.sh
#
# notes;
#    tested on ubuntu 20.04; should work on most debian based distros
#
# todo;
#    add other distro support & implement failsafe distro checks
#

if [ "$EUID" -ne 0 ]; then
	echo "Please run as root"
	exit
fi

apt update && apt install -y zlib1g-dev libcurl4-openssl-dev libssl-dev build-essential autoconf automake libtool pkg-config libnl-3-dev libnl-genl-3-dev libssl-dev ethtool shtool rfkill zlib1g-dev libpcap-dev libsqlite3-dev libpcre3-dev libhwloc-dev libcmocka-dev hostapd wpasupplicant tcpdump screen iw usbutils git

git clone https://github.com/ZerBea/hcxtools.git
cd hcxtools/
make
make install

cd ..
git clone https://github.com/ZerBea/hcxdumptool.git
cd hcxdumptool/
make
make install

cd ..
git clone https://github.com/aircrack-ng/aircrack-ng.git
cd aircrack-ng/
autoreconf -i
./configure
make
make install

cd ..
rm -R hcxtools/
rm -R hcxdumptool/
rm -R aircrack-ng/

ldconfig
