#import "Auth0GuardianFlutterPlugin.h"
#if __has_include(<auth0_guardian_ios/auth0_guardian_ios-Swift.h>)
#import <auth0_guardian_ios/auth0_guardian_ios-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "auth0_guardian_ios-Swift.h"
#endif

@implementation Auth0GuardianFlutterPlugin : NSObject
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    [SwiftFlutterPlugin registerWithRegistrar:registrar];
}
@end