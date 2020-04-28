#!/bin/bash

if [ "$EUID" -ne 0 ]; then
	echo "Please run as root"
	exit
fi

apt-get install -y build-essential pkg-config libc6-dev libssl-dev libexpat1-dev libavcodec-dev libgl1-mesa-dev qtbase5-dev zlib1g-dev

version="1.15.1"
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

sed '2iexit 0' $dir/makemkv-bin-$version/src/ask_eula.sh > $dir/makemkv-bin-$version/src/ask_eula.sh

cd $dir/makemkv-bin-$version/
make
make install

rm $dir/makemkv-bin-$version.tar.gz
rm $dir/makemkv-oss-$version.tar.gz
rm -R $dir/makemkv-oss-$version/
rm -R $dir/makemkv-bin-$version/
