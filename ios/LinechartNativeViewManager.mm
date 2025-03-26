#import <React/RCTViewManager.h>
#import <React/RCTUIManager.h>
#import "RCTBridge.h"

@interface LinechartNativeViewManager : RCTViewManager
@end

@implementation LinechartNativeViewManager

RCT_EXPORT_MODULE(LinechartNativeView)

- (UIView *)view
{
  return [[UIView alloc] init];
}

RCT_EXPORT_VIEW_PROPERTY(color, NSString)

@end
