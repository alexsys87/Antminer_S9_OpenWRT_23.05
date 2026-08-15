#
# U-Boot for the Bitmain Antminer S9 control board (Zynq-7010).
#
# boot.bin (SPL/FSBL) is installed as a pre-built binary confirmed working
# on real S9 hardware by the maintainer of this package, rather than being
# built from board/bitmain/antminer_s9/.../ps7_init_gpl.c in this source
# tree - see README.md for why. u-boot.img and uboot_env.bin are built
# normally from the pinned Xilinx u-boot-xlnx source below.
#
# ./files/system.bit.gz is the gzip-compressed FPGA bitstream, staged and
# copied onto the SD card exactly like uboot_env.bin - it must be dropped
# into ./files/ before building (Build/InstallDev fails loudly if missing).
# It's loaded by uEnv.txt's uenvcmd via "load mmc 0 ... system.bit.gz"
# before the "fpga loadb" step, ahead of booting the kernel.
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=uboot-antminer-s9-verified
PKG_VERSION:=xilinx-v2025.1
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/Xilinx/u-boot-xlnx.git
PKG_SOURCE_VERSION:=cb52646e468c5d4ab73672b003dbdeb7f859275e
PKG_SOURCE_DATE:=2025-05-16
PKG_MIRROR_HASH:=d9b167a523bfc0f86749ef20af76b02611ac8573eb7dd12f81e1b09906c9e93d
PKG_SOURCE_SUBMODULES:=skip

include $(INCLUDE_DIR)/u-boot.mk
include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/kernel.mk

define U-Boot/antminer-s9-xlnx-verified
  BUILD_TARGET:=zynq
  BUILD_SUBTARGET:=s9
  BUILD_DEVICES:=antminer_s9
  NAME:=Bitmain Antminer S9 control board (Zynq-7010, verified boot.bin + Xilinx u-boot-xlnx u-boot.img)
  UBOOT_CONFIG:=bitmain_antminer_s9
  UBOOT_IMAGE:=spl/boot.bin u-boot.img
endef

UBOOT_TARGETS:=antminer-s9-xlnx-verified

define Build/Prepare
	$(call Build/Prepare/Default)
	$(CP) ./files/bitmain_antminer_s9_defconfig \
		$(PKG_BUILD_DIR)/configs/bitmain_antminer_s9_defconfig
endef

# u-boot.img and uboot_env.bin are real cross-compiled/generated output.
# spl/boot.bin is also produced as a side effect of this same `make`
# invocation (U-Boot's build system has no clean way to build u-boot.img
# without also building SPL) but is never copied anywhere below - see
# README.md for why boot.bin comes from ./files/ instead.
define Build/Compile
	$(call Build/Compile/U-Boot)
	+$(MAKE) -C $(PKG_BUILD_DIR) tools-only $(UBOOT_MAKE_FLAGS)
	$(PKG_BUILD_DIR)/tools/mkenvimage \
		-s 0x80000 \
		-o $(PKG_BUILD_DIR)/uboot_env.bin \
		./files/antminer-s9-env.txt
endef

define Build/InstallDev
	$(INSTALL_DIR) $(STAGING_DIR_IMAGE)
	$(CP) ./files/verified-boot.bin $(STAGING_DIR_IMAGE)/antminer_s9-boot.bin
	$(CP) $(PKG_BUILD_DIR)/u-boot.img $(STAGING_DIR_IMAGE)/antminer_s9-u-boot.img
	$(CP) $(PKG_BUILD_DIR)/uboot_env.bin $(STAGING_DIR_IMAGE)/antminer_s9-uboot_env.bin
	$(CP) ./files/antminer_s9-uEnv.txt $(STAGING_DIR_IMAGE)/antminer_s9-uEnv.txt
	$(CP) ./files/system.bit.gz $(STAGING_DIR_IMAGE)/antminer_s9-system.bit.gz
endef

# Installs onto the target filesystem too (a normal opkg package), so the
# files are available at a known path, e.g. for luci-app-nand_update.
# NOTE: this must override Package/u-boot/install/default (not
# Package/u-boot-<type>/install directly) - BuildPackage/U-Boot below
# generates its own Package/u-boot-<type>/install that just calls
# $(Package/u-boot/install), which is a lazily-evaluated alias for
# Package/u-boot/install/default. Overriding the wrapper directly would
# get silently clobbered by that later $(eval), since plain `define...endef`
# assignment in make is last-one-wins, and BuildPackage/U-Boot's own
# generated definition comes after this point in the file.
define Package/u-boot/install/default
	$(INSTALL_DIR) $(1)/usr/lib/uboot-antminer-s9-verified
	$(INSTALL_DATA) ./files/verified-boot.bin $(1)/usr/lib/uboot-antminer-s9-verified/boot.bin
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/u-boot.img $(1)/usr/lib/uboot-antminer-s9-verified/u-boot.img
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/uboot_env.bin $(1)/usr/lib/uboot-antminer-s9-verified/uboot_env.bin
	$(INSTALL_DATA) ./files/system.bit.gz $(1)/usr/lib/uboot-antminer-s9-verified/system.bit.gz
endef

$(eval $(call BuildPackage/U-Boot))
