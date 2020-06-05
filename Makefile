export TARGET=iphone:clang::10.0
export ARCHS=arm64 arm64e
export DEBUG=0

include $(THEOS)/makefiles/common.mk

TOOL_NAME = revealloader

$(TOOL_NAME)_FILES = revealloader.m
$(TOOL_NAME)_CFLAGS = -fobjc-arc
$(TOOL_NAME)_CODESIGN_FLAGS = -S

include $(THEOS_MAKE_PATH)/tool.mk