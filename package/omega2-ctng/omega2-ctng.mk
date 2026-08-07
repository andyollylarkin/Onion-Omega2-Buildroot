################################################################################
#
# omega2-ctng
#
# Builds the mipsel-unknown-linux-musl GCC 11.2.0 toolchain from source
# using crosstool-NG, and installs it into board/omega2/toolchain/, where
# BR2_TOOLCHAIN_EXTERNAL_PATH expects to find it.
#
################################################################################

OMEGA2_CTNG_URL = $(call qstrip,$(BR2_OMEGA2_CTNG_URL))
OMEGA2_CTNG_SOURCE = $(notdir $(OMEGA2_CTNG_URL))
OMEGA2_CTNG_SITE = $(patsubst %/,%,$(dir $(OMEGA2_CTNG_URL)))
OMEGA2_CTNG_VERSION = $(patsubst crosstool-ng-%.tar.xz,%,$(patsubst crosstool-ng-%.tar.bz2,%,$(OMEGA2_CTNG_SOURCE)))

OMEGA2_CTNG_TARGET = mipsel-unknown-linux-musl
OMEGA2_CTNG_INSTALL_DIR = $(TOPDIR)/board/omega2/toolchain/$(OMEGA2_CTNG_TARGET)

define HOST_OMEGA2_CTNG_CONFIGURE_CMDS
	cd $(@D) && ./configure --enable-local
	$(MAKE) -C $(@D)
endef

define HOST_OMEGA2_CTNG_BUILD_CMDS
	cp $(TOPDIR)/board/omega2/toolchain-ctng/crosstool-ng.config $(@D)/.config
	cd $(@D) && ./ct-ng oldconfig
	cd $(@D) && ./ct-ng build
endef

define HOST_OMEGA2_CTNG_INSTALL_CMDS
	rm -rf $(OMEGA2_CTNG_INSTALL_DIR)
	mkdir -p $(dir $(OMEGA2_CTNG_INSTALL_DIR))
	cp -a $(@D)/.output/$(OMEGA2_CTNG_TARGET) $(OMEGA2_CTNG_INSTALL_DIR)
	chmod -R u+w $(OMEGA2_CTNG_INSTALL_DIR)
endef

$(eval $(host-generic-package))
