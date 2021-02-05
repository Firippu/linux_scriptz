#!/bin/bash
#
#	description;
#		seamlessly automates the installation for MakeMKV from www.makemkv.com
#
#	maintenance; 
#		check for version updates at www.makemkv.com & replace the version variable accordingly
#
#	usage;
#		sudo ./install_makemkv.sh
#
#	notes; tested on ubuntu 19.10, 20.04; should work on most debian based distros
#
if [ "$EUID" -ne 0 ]; then
	echo "Please run as root"
	exit
fi

## package requirements based from official installation page
apt update && apt install -y build-essential pkg-config libc6-dev libssl-dev libexpat1-dev libavcodec-dev libgl1-mesa-dev qtbase5-dev zlib1g-dev

version="1.15.4"
dir=$(pwd)

wget https://www.makemkv.com/download/makemkv-bin-$version.tar.gz
wget https://www.makemkv.com/download/makemkv-oss-$version.tar.gz

if [[(! -f $dir/makemkv-bin-$version.tar.gz) || (! -f $dir/makemkv-oss-$version.tar.gz)]]; then
	echo "Files not downloaded; verify version number or network status"
	exit
fi

tar xvzf $dir/makemkv-bin-$version.tar.gz
tar xvzf $dir/makemkv-oss-$version.tar.gz

cd $dir/makemkv-oss-$version/
./configure
make
make install

## skips eula confirmation
sed '2iexit 0' $dir/makemkv-bin-$version/src/ask_eula.sh > $dir/makemkv-bin-$version/src/ask_eula.sh

cd $dir/makemkv-bin-$version/
make
make install

rm $dir/makemkv-bin-$version.tar.gz
rm $dir/makemkv-oss-$version.tar.gz
rm -R $dir/makemkv-oss-$version/
rm -R $dir/makemkv-bin-$version/
