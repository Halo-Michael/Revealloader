#import <Foundation/Foundation.h>

%ctor {
    NSDictionary *prefs = [[NSDictionary alloc] initWithContentsOfFile:@"/private/var/mobile/Library/Preferences/com.michael.revealloader.plist"];
    if ([prefs[@"enabled"] isEqual:@YES] && [prefs[[[NSBundle mainBundle] bundleIdentifier]] isEqual:@YES]) {
        id exec = [[NSDictionary alloc] initWithContentsOfFile:@"/Library/Frameworks/RevealServer.framework/Info.plist"][@"CFBundleExecutable"];
        if ([exec isKindOfClass:[NSString class]] && [[NSFileManager defaultManager] fileExistsAtPath:[@"/Library/Frameworks/RevealServer.framework/" stringByAppendingString:exec]]) {
            [[NSBundle bundleWithPath:@"/Library/Frameworks/RevealServer.framework"] load];
        }
    }
}
