#import "FContactsPlugin.h"
#import <fcontacts/fcontacts-Swift.h>

@implementation FContactsPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFContactsPlugin registerWithRegistrar:registrar];
}
@end
