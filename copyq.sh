#!/bin/bash

# https://copyq.readthedocs.io/en/latest/build-source-code.html
yum install -y \
  gcc-c++ git cmake \
  libXtst-devel libXfixes-devel \
  qt5-qtbase-devel \
  qt5-qtsvg-devel \
  qt5-qttools-devel \
  qt5-qtscript-devel \
  qt5-qtx11extras-devel
cd /root/Downloads/CopyQ-3.6.1
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local .
make
make install
