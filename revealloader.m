#include <CoreFoundation/CoreFoundation.h>

void usage() {
    printf("Usage:\trevealloader <app bundle id>\n");
    printf("\trevealloader [OPTIONS...]\n");
    printf("\t-h\tPrint this help.\n");
    printf("\t-d\tDisable reveal inject.\n");
    printf("\t-s\tShow current bundle id.\n");
}

bool modifyPlist(NSString *filename, void (^function)(id)) {
    NSData *data = [NSData dataWithContentsOfFile:filename];
    if (data == nil) {
        return false;
    }
    NSPropertyListFormat format = 0;
    NSError *error = nil;
    id plist = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListMutableContainersAndLeaves format:&format error:&error];
    if (plist == nil) {
        return false;
    }
    if (function) {
        function(plist);
    }
    NSData *newData = [NSPropertyListSerialization dataWithPropertyList:plist format:format options:0 error:&error];
    if (newData == nil) {
        return false;
    }
    if (![data isEqual:newData]) {
        if (![newData writeToFile:filename atomically:YES]) {
            return false;
        }
    }
    return true;
}

int main(int argc, char **argv) {
    if (getuid() != 0) {
        setuid(0);
    }

    if (getuid() != 0) {
        printf("Can't set uid as 0.\n");
        return 1;
    }

    if (access("/Library/Frameworks/RevealServer.framework/RevealServer", F_OK) != 0) {
        printf("Framework RevealServer.framework doesn't exist in /Library/Frameworks!\n");
        return 2;
    }

    NSMutableArray *args = [[[NSProcessInfo processInfo] arguments] mutableCopy];
    if ([args count] == 1) {
        usage();
        return 1;
    }
    [args removeObjectAtIndex:0];
    for (NSString *argument in args) {
        if (![argument caseInsensitiveCompare:@"-h"]) {
            usage();
            return 1;
        }
        if (![argument caseInsensitiveCompare:@"-d"]) {
            if (access("/Library/MobileSubstrate/DynamicLibraries/RevealServer.dylib", F_OK) == 0) {
                remove("/Library/MobileSubstrate/DynamicLibraries/RevealServer.dylib");
            }
            if (access("/Library/MobileSubstrate/DynamicLibraries/RevealServer.plist", F_OK) == 0) {
                remove("/Library/MobileSubstrate/DynamicLibraries/RevealServer.plist");
            }
            printf("Disable reveal inject successfully.\n");
            return 0;
        }
        if (![argument caseInsensitiveCompare:@"-s"]) {
            if (access("/Library/MobileSubstrate/DynamicLibraries/RevealServer.plist", F_OK) != 0) {
                printf("File /Library/MobileSubstrate/DynamicLibraries/RevealServer.plist doesn't exist!\n");
                return 3;
            }
            NSString *const plist = @"/Library/MobileSubstrate/DynamicLibraries/RevealServer.plist";
            NSDictionary *const dict = [NSDictionary dictionaryWithContentsOfFile:plist];
            NSArray *Bundles = dict[@"Filter"][@"Bundles"];
            printf("Reveal has been injected into");
            for (NSString *bundle in Bundles) {
                printf(" %s", [bundle UTF8String]);
            }
            printf(".\n");
            return 0;
        }
    }

    if (access("/Library/MobileSubstrate/DynamicLibraries/RevealServer.dylib", F_OK) != 0) {
        symlink("../../Frameworks/RevealServer.framework/RevealServer", "/Library/MobileSubstrate/DynamicLibraries/RevealServer.dylib");
    }

    NSString *const plist = @"/Library/MobileSubstrate/DynamicLibraries/RevealServer.plist";

    if (access("/Library/MobileSubstrate/DynamicLibraries/RevealServer.plist", F_OK) != 0) {
        [[NSDictionary dictionary] writeToFile:plist atomically:NO];
        modifyPlist(plist, ^(id plist) {
            plist[@"Filter"] = [NSDictionary dictionary];
        });
    }

    modifyPlist(plist, ^(id plist) {
        plist[@"Filter"][@"Bundles"] = args;
    });

    printf("Injected reveal into");
    for (NSString *bundle in args) {
        printf(" %s", [bundle UTF8String]);
    }
    printf(" successfully.\n");

    return 0;
}
