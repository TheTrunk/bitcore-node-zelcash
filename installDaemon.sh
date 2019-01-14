#!/bin/bash

# install needed dependencies
sudo apt-get update
sudo apt-get install \
      build-essential pkg-config libc6-dev m4 g++-multilib \
      autoconf libtool ncurses-dev unzip git python \
      zlib1g-dev wget bsdmainutils automake curl

# hushBitcore
cd
git clone -b Bitcore https://github.com/myhush/hush.git hushBitcore
cd hushBitcore
./zcutil/fetch-params.sh
./zcutil/build.sh -j$(nproc)
cd
echo "Hushd with extended RPC functionalities is prepared. Please run following command to install insight explorer for hush"
echo "wget -qO- https://raw.githubusercontent.com/TheTrunk/bitcore-node-zelcash/master/installExplorer.sh | bash"