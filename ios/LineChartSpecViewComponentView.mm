#ifdef RCT_NEW_ARCH_ENABLED
#import "LineChartSpecViewComponentView.h"
#import <React/RCTConversions.h>
#import <React/RCTViewManager.h>

#import <react/renderer/components/LineChartSpec/ComponentDescriptors.h>
#import <react/renderer/components/LineChartSpec/EventEmitters.h>
#import <react/renderer/components/LineChartSpec/Props.h>
#import <react/renderer/components/LineChartSpec/RCTComponentViewHelpers.h>

#import "LineChart-Swift.h"


using namespace facebook::react;

@interface LineChartSpecViewComponentView () <RCTLineChartSpecViewViewProtocol>
@end

@implementation LineChartSpecViewComponentView {
  LineChartSpecView *_lineChartView; // Swift sınıfı
}

#pragma mark - Component Descriptor Provider

+ (ComponentDescriptorProvider)componentDescriptorProvider {
  // React Native'deki `LineChartSpecViewComponentDescriptor` ile bağlantı kuruyoruz
  return concreteComponentDescriptorProvider<LineChartSpecViewComponentDescriptor>();
}

#pragma mark - Initializer

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    NSLog(@"LineChartSpecViewComponentView: Initializing view");
    _lineChartView = [[LineChartSpecView alloc] initWithFrame:frame];
    [self addSubview:_lineChartView]; // Swift bileşenini ana görünüme ekliyoruz
  }
  return self;
}

#pragma mark - Update Props

- (void)updateProps:(Props::Shared const &)props oldProps:(Props::Shared const &)oldProps {
  const auto &newViewProps = *std::static_pointer_cast<LineChartSpecViewProps const>(props);
  const auto &oldViewProps = *std::static_pointer_cast<LineChartSpecViewProps const>(oldProps);
  
  NSDictionary *newData = nil;
  NSDictionary *markerEntity = @{};
  NSDictionary *circleEntity = @{};
  NSDictionary *xAxisEntity = @{};
  NSDictionary *yAxisEntity = @{};
  NSDictionary *position = 	@{};
  NSDictionary *animationEntity = @{};
  // Veri yapısını kontrol etmek için bir yardımcı fonksiyon
  auto hasDataChanged = [](const LineChartSpecViewDataStruct &newData,
                         const LineChartSpecViewDataStruct &oldData) -> bool {
      // dataSets boyutunu kontrol et
      if (newData.dataSets.size() != oldData.dataSets.size()) {
          return true;
      }

   
      // Her bir dataSet'i karşılaştır
      for (size_t i = 0; i < newData.dataSets.size(); i++) {
          const auto &newDataSet = newData.dataSets[i];
          const auto &oldDataSet = oldData.dataSets[i];

          if (newDataSet.label != oldDataSet.label) {
              return true;
          }

          if (newDataSet.values.size() != oldDataSet.values.size()) {
              return true;
          }

          // values içindeki her bir entry'i karşılaştır
          for (size_t j = 0; j < newDataSet.values.size(); j++) {
              if (newDataSet.values[j].x != oldDataSet.values[j].x ||
                  newDataSet.values[j].y != oldDataSet.values[j].y) {
                  return true;
              }
          }
        
        if (newDataSet.gradientColorsData.from != oldDataSet.gradientColorsData.from && newDataSet.gradientColorsData.to != oldDataSet.gradientColorsData.to) {
            return true;
        }
        
      }

     
    
      return false;
  };


  // Veri değişikliğini kontrol et
  if (hasDataChanged(newViewProps.data, oldViewProps.data)) {
      NSMutableArray *newDataArray = [NSMutableArray array];

      for (const auto &dataSet : newViewProps.data.dataSets) {
          NSMutableArray *valuesArray = [NSMutableArray array];

          for (const auto &entry : dataSet.values) {
              [valuesArray addObject:@{
                  @"x": @(entry.x),
                  @"y": @(entry.y)
              }];
          }
          

          [newDataArray addObject:@{
              @"values": valuesArray,
              @"label": [NSString stringWithUTF8String:dataSet.label.c_str()]
          }];
      }


      NSDictionary *newData = @{ @"dataSets": newDataArray };
    
    if (newData) {
          [_lineChartView setData:newData];
      }
  }

  if (newViewProps.markerEntity.circleEntity.size != oldViewProps.markerEntity.circleEntity.size || newViewProps.markerEntity.circleEntity.color != oldViewProps.markerEntity.circleEntity.color) {
      circleEntity = @{
          @"size": @(newViewProps.markerEntity.circleEntity.size),
          @"color": [NSString stringWithUTF8String:newViewProps.markerEntity.circleEntity.color.c_str()]
      };
      
    position = @{
      @"top": @(newViewProps.markerEntity.position.top),
      @"bottom": @(newViewProps.markerEntity.position.bottom),
      @"left": @(newViewProps.markerEntity.position.left),
      @"right": @(newViewProps.markerEntity.position.right),
    };
    markerEntity = @{
      @"circleEntity": circleEntity,
      @"position":position,
      @"color":[NSString stringWithUTF8String:newViewProps.markerEntity.color.c_str()],
      @"bgColor":[NSString stringWithUTF8String:newViewProps.markerEntity.bgColor.c_str()],
      @"fontSize":@(newViewProps.markerEntity.fontSize)
    };
    
     // [_lineChartView setMarkerEntity:markerEntity];
  }
      
  xAxisEntity = @{
        @"drawLabelsEnabled": @(oldViewProps.xAxisEntity.drawLabelsEnabled),
        @"labelFont": @{
            @"size": @(newViewProps.xAxisEntity.labelFont.size),
            @"weight": [NSString stringWithUTF8String:newViewProps.xAxisEntity.labelFont.weight.c_str()]
        },
        @"labelPosition": [NSString stringWithUTF8String:oldViewProps.xAxisEntity.labelPosition.c_str()],
        @"labelTextColor": [NSString stringWithUTF8String:oldViewProps.xAxisEntity.labelTextColor.c_str()],
        @"yOffset": @(oldViewProps.xAxisEntity.yOffset),
        @"xOffset": @(oldViewProps.xAxisEntity.xOffset),
        @"axisMin": @(oldViewProps.xAxisEntity.axisMin),
        @"axisMax": @(oldViewProps.xAxisEntity.axisMax),
  };
   
  if (newViewProps.xAxisEntity.drawLabelsEnabled != oldViewProps.xAxisEntity.drawLabelsEnabled ) {
    xAxisEntity = @{
        @"drawLabelsEnabled": @(newViewProps.xAxisEntity.drawLabelsEnabled),
    };
  }

  if (newViewProps.xAxisEntity.labelPosition != oldViewProps.xAxisEntity.labelPosition ) {
    xAxisEntity = @{
        @"labelPosition": [NSString stringWithUTF8String:newViewProps.xAxisEntity.labelPosition.c_str()],
    };
  }
   if (newViewProps.xAxisEntity.labelFont.size != oldViewProps.xAxisEntity.labelFont.size  || newViewProps.xAxisEntity.labelFont.weight != oldViewProps.xAxisEntity.labelFont.weight) {
    
    xAxisEntity = @{
        @"labelFont": @{
            @"size": @(newViewProps.xAxisEntity.labelFont.size),
            @"weight": [NSString stringWithUTF8String:newViewProps.xAxisEntity.labelFont.weight.c_str()]
        },
    };
   }

    if (newViewProps.xAxisEntity.labelTextColor != oldViewProps.xAxisEntity.labelTextColor ) {
         xAxisEntity = @{
        @"labelTextColor": [NSString stringWithUTF8String:newViewProps.xAxisEntity.labelTextColor.c_str()],
    };

    if (newViewProps.xAxisEntity.yOffset != oldViewProps.xAxisEntity.yOffset) {
        xAxisEntity = @{
        @"yOffset": @(newViewProps.xAxisEntity.yOffset),
      };
    }
    
    yAxisEntity = @{
      @"drawLabelsEnabled": @(oldViewProps.yAxisEntity.drawLabelsEnabled),
          @"labelFont": @{
              @"size": @(newViewProps.yAxisEntity.labelFont.size),
              @"weight": [NSString stringWithUTF8String:newViewProps.yAxisEntity.labelFont.weight.c_str()]
          },
          @"labelPosition": [NSString stringWithUTF8String:oldViewProps.yAxisEntity.labelPosition.c_str()],
          @"labelTextColor": [NSString stringWithUTF8String:oldViewProps.yAxisEntity.labelTextColor.c_str()],
          @"xOffset": @(oldViewProps.yAxisEntity.xOffset),
          @"yOffset": @(oldViewProps.yAxisEntity.yOffset),
          @"axisMin": @(oldViewProps.yAxisEntity.axisMin),
          @"axisMax": @(oldViewProps.yAxisEntity.axisMax),
    };
    
    if (newViewProps.yAxisEntity.drawLabelsEnabled != oldViewProps.yAxisEntity.drawLabelsEnabled ) {
      yAxisEntity = @{
          @"drawLabelsEnabled": @(newViewProps.yAxisEntity.drawLabelsEnabled),
      };
    }

    if (newViewProps.yAxisEntity.labelPosition != oldViewProps.yAxisEntity.labelPosition ) {
      yAxisEntity = @{
          @"labelPosition": [NSString stringWithUTF8String:newViewProps.yAxisEntity.labelPosition.c_str()],
      };
    }
    if (newViewProps.yAxisEntity.labelFont.size != oldViewProps.yAxisEntity.labelFont.size  || newViewProps.yAxisEntity.labelFont.weight != oldViewProps.yAxisEntity.labelFont.weight) {
    
    yAxisEntity = @{
        @"labelFont": @{
            @"size": @(newViewProps.yAxisEntity.labelFont.size),
            @"weight": [NSString stringWithUTF8String:newViewProps.yAxisEntity.labelFont.weight.c_str()]
        },
    };
    }

    if (newViewProps.yAxisEntity.labelTextColor != oldViewProps.yAxisEntity.labelTextColor ) {
          yAxisEntity = @{
          @"labelTextColor": [NSString stringWithUTF8String:newViewProps.yAxisEntity.labelTextColor.c_str()],
        };
    };

    if (newViewProps.yAxisEntity.xOffset != oldViewProps.yAxisEntity.xOffset) {
        yAxisEntity = @{
        @"xOffset": @(newViewProps.yAxisEntity.xOffset),
      };
    }
          
      
      if (newViewProps.animationEntity.xAxisEasing != oldViewProps.animationEntity.xAxisEasing || newViewProps.animationEntity.xAxisDuration != oldViewProps.animationEntity.xAxisDuration || newViewProps.animationEntity.yAxisEasing != oldViewProps.animationEntity.yAxisEasing || newViewProps.animationEntity.yAxisDuration != oldViewProps.animationEntity.yAxisDuration) {
        animationEntity = @{
          @"xAxisDuration": @(newViewProps.animationEntity.xAxisDuration),
          @"xAxisEasing": [NSString stringWithUTF8String:newViewProps.animationEntity.xAxisEasing.c_str()],
          @"yAxisDuration":  @(newViewProps.animationEntity.yAxisDuration),
          @"yAxisEasing": [NSString stringWithUTF8String:newViewProps.animationEntity.yAxisEasing.c_str()],
        };
        
        //[_lineChartView setAnimationEntity:animationEntity];
      }

  if (newViewProps.dragEnabled != oldViewProps.dragEnabled) {
     // [_lineChartView setDragEnabled:newViewProps.dragEnabled];
  }

   if (newViewProps.highlightPerTapEnabled != oldViewProps.highlightPerTapEnabled) {
      //[_lineChartView setHighlightPerTapEnabled:newViewProps.highlightPerTapEnabled];
  }

   if (newViewProps.highlightPerDragEnabled != oldViewProps.highlightPerDragEnabled) {
      //[_lineChartView setHighlightPerDragEnabled:newViewProps.highlightPerDragEnabled];
  }
      

  if (!newViewProps.bgColor.empty()) {
      NSString *bgColor = [NSString stringWithUTF8String:newViewProps.bgColor.c_str()];
      //[_lineChartView setBgColor:bgColor];
  }
     
//  [_lineChartView setYAxisEntity:yAxisEntity];
//  [_lineChartView setXAxisEntity:xAxisEntity];
//  [_lineChartView setDrawGridLinesEnabled:newViewProps.drawGridLinesEnabled];
  [super updateProps:props oldProps:oldProps];
  }
}
@end

// React Native'in bu bileşeni tanıyabilmesi için bir sınıf referansı sağlıyoruz
Class<RCTComponentViewProtocol> LineChartSpecViewCls(void) {
  return LineChartSpecViewComponentView.class;
}
#endif
