#import <Foundation/Foundation.h>
#import <React/RCTViewManager.h>


@interface RCT_EXTERN_MODULE(LineChartSpecViewManager, RCTViewManager)
  

RCT_EXPORT_VIEW_PROPERTY(data, NSDictionary)
RCT_EXPORT_VIEW_PROPERTY(xAxisEntity, NSDictionary)
RCT_EXPORT_VIEW_PROPERTY(yAxisEntity, NSDictionary)
RCT_EXPORT_VIEW_PROPERTY(markerEntity, NSDictionary)
RCT_EXPORT_VIEW_PROPERTY(dragEnabled, BOOL) 
RCT_EXPORT_VIEW_PROPERTY(highlightPerTapEnabled, BOOL)
RCT_EXPORT_VIEW_PROPERTY(highlightPerDragEnabled, BOOL)
RCT_EXPORT_VIEW_PROPERTY(bgColor, NSString)
RCT_EXPORT_VIEW_PROPERTY(drawGridLinesEnabled, BOOL)
RCT_EXPORT_VIEW_PROPERTY(animationEntity, NSDictionary)
@end
