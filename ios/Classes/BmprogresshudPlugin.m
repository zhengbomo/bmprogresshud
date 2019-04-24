#import "BmprogresshudPlugin.h"
#import <bmprogresshud/bmprogresshud-Swift.h>

@implementation BmprogresshudPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftBmprogresshudPlugin registerWithRegistrar:registrar];
}
@end
