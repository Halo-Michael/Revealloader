TARGET = revealloader
VERSION = 0.1.0
CC = xcrun -sdk iphoneos clang -arch armv7 -arch arm64 -arch arm64e -miphoneos-version-min=9.0
LDID = ldid

.PHONY: all clean

all: postinst revealloader
	mkdir com.michael.revealloader_$(VERSION)_iphoneos-arm
	mkdir com.michael.revealloader_$(VERSION)_iphoneos-arm/DEBIAN
	cp control com.michael.revealloader_$(VERSION)_iphoneos-arm/DEBIAN
	mv postinst com.michael.revealloader_$(VERSION)_iphoneos-arm/DEBIAN
	mkdir com.michael.revealloader_$(VERSION)_iphoneos-arm/usr
	mkdir com.michael.revealloader_$(VERSION)_iphoneos-arm/usr/bin
	mv revealloader com.michael.revealloader_$(VERSION)_iphoneos-arm/usr/bin
	dpkg -b com.michael.revealloader_$(VERSION)_iphoneos-arm

postinst: clean
	$(CC) postinst.c -o postinst
	strip postinst
	$(LDID) -Sentitlements.xml postinst

revealloader: clean
	$(CC) -fobjc-arc revealloader.m -o revealloader
	strip revealloader
	$(LDID) -Sentitlements.xml revealloader

clean:
	rm -rf com.michael.revealloader_* revealloader
