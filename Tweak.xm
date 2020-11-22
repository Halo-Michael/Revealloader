#import <Foundation/Foundation.h>
#import <dlfcn.h>

%ctor {
    NSDictionary *prefs = [[NSDictionary alloc] initWithContentsOfFile:@"/private/var/mobile/Library/Preferences/com.michael.revealloader.plist"];
    if ([prefs[@"enabled"] isEqual:@YES] && [prefs[[[NSBundle mainBundle] bundleIdentifier]] isEqual:@YES]) {
        if (access("/Library/Frameworks/RevealServer.framework/RevealServer", F_OK) == 0) {
            dlopen("/Library/Frameworks/RevealServer.framework/RevealServer", RTLD_NOW);
        }
    }
}
