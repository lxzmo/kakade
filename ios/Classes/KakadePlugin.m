#import "KakadePlugin.h"

#if __has_include(<kakade/kakade-Swift.h>)
#import <kakade/kakade-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "kakade-Swift.h"
#endif

@implementation KakadePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftKakadePlugin registerWithRegistrar:registrar];
}

// @implementation KakadePlugin
// + (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
//   FlutterMethodChannel* channel = [FlutterMethodChannel
//       methodChannelWithName:@"kakade"
//             binaryMessenger:[registrar messenger]];
//   KakadePlugin* instance = [[KakadePlugin alloc] init];
//   [registrar addMethodCallDelegate:instance channel:channel];
// }

// - (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
//   if ([@"getPlatformVersion" isEqualToString:call.method]) {
//     result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
//   } else {
//     result(FlutterMethodNotImplemented);
//   }
// }

@end
