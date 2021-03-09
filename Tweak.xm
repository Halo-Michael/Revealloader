#import <Foundation/Foundation.h>

%ctor {
    NSUserDefaults *prefs = [[NSUserDefaults alloc] _initWithSuiteName:@"com.michael.revealloader" container:[NSURL URLWithString:@"file:///private/var/mobile"]];
    if ([[prefs objectForKey:@"enabled"] isEqual:@YES]) {
        NSDictionary *apps = [[NSDictionary alloc] initWithContentsOfFile:@"/private/var/mobile/Library/Preferences/com.michael.revealloader.plist"];
        if ([apps[[[NSBundle mainBundle] bundleIdentifier]] isEqual:@YES]) {
            for (NSBundle *bundle in [NSBundle allFrameworks]) {
                if ([[[bundle executableURL] lastPathComponent] isEqual:@"RevealServer"]) {
                    return;
                }
            }
            id exec = [[NSDictionary alloc] initWithContentsOfFile:@"/Library/Frameworks/RevealServer.framework/Info.plist"][@"CFBundleExecutable"];
            if ([exec isKindOfClass:[NSString class]] && [[NSFileManager defaultManager] fileExistsAtPath:[@"/Library/Frameworks/RevealServer.framework/" stringByAppendingString:exec]]) {
                [[NSBundle bundleWithPath:@"/Library/Frameworks/RevealServer.framework"] load];
            }
        }
    }
}
