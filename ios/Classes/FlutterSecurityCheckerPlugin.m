#import "FlutterSecurityCheckerPlugin.h"
#import "security/IntegrityChecker.h"
#if __has_include(<coruscant_security_checker/coruscant_security_checker-Swift.h>)
#import <coruscant_security_checker/coruscant_security_checker-Swift.h>
#else
#import "coruscant_security_checker-Swift.h"
#endif

@implementation FlutterSecurityCheckerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
                                   methodChannelWithName:@"coruscant_security_checker"
                                   binaryMessenger:[registrar messenger]];
  FlutterSecurityCheckerPlugin* instance = [[FlutterSecurityCheckerPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"isRooted" isEqualToString:call.method]) {
        result([NSNumber numberWithBool:[JailBreakChecker isJailBroken]]);
    } else if ([@"isRealDevice" isEqualToString:call.method]) {
    result([NSNumber numberWithBool:!TARGET_OS_SIMULATOR]);
  } else if ([@"hasCorrectlyInstalled" isEqualToString:call.method]) {
    result([NSNumber numberWithBool:[IntegrityChecker isBinaryEncrypted]]);
  } else {
    result(FlutterMethodNotImplemented);
  }
}
@end
