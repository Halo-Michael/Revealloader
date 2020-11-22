export TARGET := iphone:clang:latest:7.0
export ARCH := armv7 arm64 arm64e
export DEBUG = no
export FINALPACKAGE = yes
INSTALL_TARGET_PROCESSES = UIKit

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = RevealLoader

RevealLoader_FILES = Tweak.xm
RevealLoader_CFLAGS = -fobjc-arc

SUBPROJECTS += revealloaderprefs

include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS_MAKE_PATH)/aggregate.mk
