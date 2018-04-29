#!/bin/bash

#we need to make sure that we have some required tools and if we dont we need to install them
echo "installing required programs"
sudo apt-get install build-essential libssl-dev swig bison flex python3 python-dev python3-pip libusb-1.0-0-dev
sudo pip3 install pyusb==1.0.0

echo
echo
echo
#create a new directory for us to work in
mkdir ./test
cd ./test 
# set up a build enviroment by downloading the cross-compiling tools
echo "setting up build env"
mkdir ./build-tool
cd build-tool
wget "https://releases.linaro.org/components/toolchain/binaries/latest-7/aarch64-linux-gnu/gcc-linaro-7.2.1-2017.11-x86_64_aarch64-linux-gnu.tar.xz"
wget "https://releases.linaro.org/components/toolchain/binaries/latest-7/arm-linux-gnueabi/gcc-linaro-7.2.1-2017.11-x86_64_arm-linux-gnueabi.tar.xz"
#now lets extract them into their own folders
for filename in *.tar.xz
do
  tar xvfJ $filename
done
cd ../
#now lets set up our path so that we can use the tools 
export PATH=$PATH:./build-tool/gcc-linaro-7.2.1-2017.11-x86_64_aarch64-linux-gnu/bin
echo "Let's test to see if the tools work" 
aarch64-linux-gnu-gcc

#Time to Download the repo's for loading switch linux
echo "Downloading repo's" 
#git clone https://github.com/fail0verflow/shofel2.git
#git clone --recursive --depth=1 https://github.com/fail0verflow/switch-coreboot.git coreboot
#git clone https://github.com/fail0verflow/switch-u-boot.git u-boot4
#git clone --depth=1 https://github.com/fail0verflow/switch-linux.git linux
#git clone https://github.com/boundarydevices/imx_usb_loader.git
cd shofel2/exploit
make -j8
cd ../
cd u-boot
export CROSS_COMPILE=aarch64-linux-gnu-
make nintendo-switch_defconfig 
make -j8
cd ../
cd coreboot
make nintendo_switch_defconfig
make iasl
make -j8
