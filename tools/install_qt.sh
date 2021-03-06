#!/bin/bash

[ -f "/usr/lib/x86_64-linux-gnu/libLLVM-4.0.so" ]
LLVM_ALREADY_INSTALLED=$?
[ -d "/usr/lib/x86_64-linux-gnu/perl/" ]
PERL_ALREADY_INSTALLED=$?

apt-get update

apt install -y -qq --no-install-recommends libqt5core5a libqt5gui5 libqt5widgets5 qt5-qmake qtbase5-dev-tools

mkdir qt_pkg
cd qt_pkg
apt download qtbase5-dev
dpkg --force-all -i qtbase5-dev*.deb
cd ..

# We dont need gl... but qt wants it.which 
mkdir -p /usr/include/libdrm/GL/
touch /usr/include/libdrm/GL/gl.h

rm -r \
  qt_pkg \
  /usr/share/qt5 \
  /usr/lib/x86_64-linux-gnu/dri/*

if (( PERL_ALREADY_INSTALLED != 0 )); then
  echo "Removing installed perl modules"
  rm -r /usr/lib/x86_64-linux-gnu/perl/*
fi

if (( LLVM_ALREADY_INSTALLED != 0 )); then
  echo "Removing installed llvm modules"
  rm -r /usr/lib/x86_64-linux-gnu/libLLVM-4.0.so*
fi


rm -rf /var/lib/apt/lists/*