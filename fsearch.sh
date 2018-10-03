#!/bin/bash

yum  install -y automake autoconf intltool libtool autoconf-archive pkgconfig glib2-devel gtk3-devel
git clone https://github.com/cboxdoerfer/fsearch.git
cd fsearch
./autogen.sh
./configure
make && sudo make install
rm -rf fsearch
