export PATH=/usr/local/arm/4.3.2/bin:$PATH
export TOOLCHAIN=/usr/local/arm/4.3.2
export TB_CC_PREFIX=arm-linux
export PKG_CONFIG_PREFIX=$TOOLCHAIN/arm-none-linux-gnueabi
make distclean
rm -rf *.dis
make rpi_defconfig
make clean
make -j32
#arm-linux-objdump -D -b binary -m arm u-boot.bin > u-boot.asm
arm-linux-objdump -D u-boot > u-boot.dis
mv u-boot-dtb.bin /home/jon/
mv .config config.h
