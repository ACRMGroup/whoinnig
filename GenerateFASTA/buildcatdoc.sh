#!/bin/bash

cd GenerateFASTA
SHARE=`pwd`/share
cd packages
tar zxvf catdoc-0.95.tar.gz
cd catdoc-0.95
./configure --prefix=$SHARE
make
make install

