#!/bin/bash

version=[%catdocVersion%]

cd GenerateFASTA
SHARE=`pwd`/share
cd packages
tar zxvf catdoc-$(version).tar.gz
cd catdoc-$(version)
./configure --prefix=$SHARE
make
make install

