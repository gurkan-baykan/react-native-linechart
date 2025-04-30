#ifdef RCT_NEW_ARCH_ENABLED

#import "LineChartSpecViewComponentView.h"
#import <React/RCTConversions.h>
#import <React/RCTViewManager.h>

#import "generated/LineChartSpec/ComponentDescriptors.h"
#import "generated/LineChartSpec/EventEmitters.h"
#import "generated/LineChartSpec/Props.h"
#import "generated/LineChartSpec/RCTComponentViewHelpers.h"

#if __has_include(<ReactNativeLineChartNative/ReactNativeLineChartNative-Swift.h>)
#import <ReactNativeLineChartNative/ReactNativeLineChartNative-Swift.h>
#else
#import "ReactNativeLineChartNative-Swift.h"
#endif

using namespace facebook::react;

@interface LineChartSpecViewComponentView () <RCTLineChartSpecViewViewProtocol>
@end

@implementation LineChartSpecViewComponentView {
  LineChartSpecView *_lineChartView; // Swift tabanlı grafik bileşeni
}

#pragma mark - Component Descriptor Provider

+ (ComponentDescriptorProvider)componentDescriptorProvider {
  // React Native ile Native bileşeni ilişkilendiriyoruz
  return concreteComponentDescriptorProvider<LineChartSpecViewComponentDescriptor>();
}

#pragma mark - Initializer

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    NSLog(@"LineChartSpecViewComponentView: Initializing view");
    _lineChartView = [[LineChartSpecView alloc] initWithFrame:frame];
    [self addSubview:_lineChartView];
  }
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];

  // React Native'den gelen boyutları kullan
  CGRect frame = self.bounds;
  _lineChartView.frame = frame;

  NSLog(@"[LineChartSpecViewComponentView] layoutSubviews - new frame: %@", NSStringFromCGRect(frame));
}

#pragma mark - Update Props

- (void)updateProps:(Props::Shared const &)props oldProps:(Props::Shared const &)oldProps {
  const auto &newViewProps = *std::static_pointer_cast<LineChartSpecViewProps const>(props);
  const auto &newDataStruct = newViewProps.data;

  
 NSMutableDictionary* circleEntity = [NSMutableDictionary dictionary];
 NSMutableDictionary* position = [NSMutableDictionary dictionary];
 NSMutableDictionary *markerEntity = [NSMutableDictionary dictionary];
 NSMutableDictionary *xAxisEntity = [NSMutableDictionary dictionary];
 NSMutableDictionary *yAxisEntity = [NSMutableDictionary dictionary];
 NSMutableDictionary *animationEntity = [NSMutableDictionary dictionary];
 position = [@{
          @"top": @(newViewProps.markerEntity.position.top),
          @"bottom": @(newViewProps.markerEntity.position.bottom),
          @"left": @(newViewProps.markerEntity.position.left),
          @"right": @(newViewProps.markerEntity.position.right),
      } mutableCopy];
       circleEntity = [@{
          @"size": @(newViewProps.markerEntity.circleEntity.size),
          @"color": [NSString stringWithUTF8String:newViewProps.markerEntity.circleEntity.color.c_str()]
       } mutableCopy];

     markerEntity = [@{
            @"circleEntity": circleEntity,
            @"position":position,
            @"color":[NSString stringWithUTF8String:newViewProps.markerEntity.color.c_str()],
            @"bgColor":[NSString stringWithUTF8String:newViewProps.markerEntity.bgColor.c_str()],
            @"fontSize":@(newViewProps.markerEntity.fontSize)
          } mutableCopy];

  // oldProps null olabilir, kontrol edip güvenli struct olarak sarıyoruz
  std::optional<LineChartSpecViewDataStruct> maybeOldDataStruct = std::nullopt;
  if (oldProps) {
    const auto &oldViewProps = *std::static_pointer_cast<LineChartSpecViewProps const>(oldProps);
 
      if (!newViewProps.bgColor.empty()) {
        NSString *bgColor = [NSString stringWithUTF8String:newViewProps.bgColor.c_str()];
      [_lineChartView setBgColor:bgColor];
    }

    if (newViewProps.xAxisEntity.drawLabelsEnabled != oldViewProps.xAxisEntity.drawLabelsEnabled ) {
        xAxisEntity[@"drawLabelsEnabled"] = @(newViewProps.xAxisEntity.drawLabelsEnabled);
    }

    if (newViewProps.xAxisEntity.labelPosition != oldViewProps.xAxisEntity.labelPosition ) {
        xAxisEntity[@"labelPosition"] =[NSString stringWithUTF8String:newViewProps.xAxisEntity.labelPosition.c_str()];
    }
    if (newViewProps.xAxisEntity.xOffset != oldViewProps.xAxisEntity.xOffset) {
      xAxisEntity[@"xOffset"] =@(newViewProps.xAxisEntity.xOffset);
    }

    if (newViewProps.xAxisEntity.labelFont.size != oldViewProps.xAxisEntity.labelFont.size  || newViewProps.xAxisEntity.labelFont.weight != oldViewProps.xAxisEntity.labelFont.weight) {
        
        NSMutableDictionary *labelFont = [xAxisEntity[@"labelFont"] mutableCopy];
        labelFont[@"size"] =@(newViewProps.xAxisEntity.labelFont.size);
        labelFont[@"weight"] =[NSString stringWithUTF8String:newViewProps.xAxisEntity.labelFont.weight.c_str()];
        xAxisEntity[@"labelFont"] = labelFont;
    }

    if (newViewProps.xAxisEntity.labelTextColor != oldViewProps.xAxisEntity.labelTextColor ) {
         xAxisEntity[@"labelTextColor"] = [NSString stringWithUTF8String:newViewProps.xAxisEntity.labelTextColor.c_str()];
    }

    if (newViewProps.xAxisEntity.yOffset != oldViewProps.xAxisEntity.yOffset) {
        xAxisEntity[@"yOffset"] =@(newViewProps.xAxisEntity.yOffset);
    }

      if (newViewProps.animationEntity.xAxisEasing != oldViewProps.animationEntity.xAxisEasing || newViewProps.animationEntity.xAxisDuration != oldViewProps.animationEntity.xAxisDuration || newViewProps.animationEntity.yAxisEasing != oldViewProps.animationEntity.yAxisEasing || newViewProps.animationEntity.yAxisDuration != oldViewProps.animationEntity.yAxisDuration) {
        animationEntity[@"xAxisDuration"] = @(newViewProps.animationEntity.xAxisDuration);
        animationEntity[@"xAxisEasing"] = [NSString stringWithUTF8String:newViewProps.animationEntity.xAxisEasing.c_str()];
        animationEntity[@"yAxisDuration"] =  @(newViewProps.animationEntity.yAxisDuration);
        animationEntity[@"yAxisEasing"] = [NSString stringWithUTF8String:newViewProps.animationEntity.yAxisEasing.c_str()];
        [_lineChartView setAnimationEntity:animationEntity];
      }

    if (newViewProps.yAxisEntity.drawLabelsEnabled != oldViewProps.yAxisEntity.drawLabelsEnabled ) {
       yAxisEntity[@"drawLabelsEnabled"] = @(newViewProps.yAxisEntity.drawLabelsEnabled);
    }

    if (newViewProps.yAxisEntity.labelPosition != oldViewProps.yAxisEntity.labelPosition ) { 
       yAxisEntity[@"labelPosition"] =[NSString stringWithUTF8String:newViewProps.yAxisEntity.labelPosition.c_str()];
    }
    if (newViewProps.yAxisEntity.labelFont.size != oldViewProps.yAxisEntity.labelFont.size  || newViewProps.yAxisEntity.labelFont.weight != oldViewProps.yAxisEntity.labelFont.weight) {
        NSMutableDictionary *labelFont = [yAxisEntity[@"labelFont"] mutableCopy];
        labelFont[@"size"] =@(newViewProps.yAxisEntity.labelFont.size);
        labelFont[@"weight"] =[NSString stringWithUTF8String:newViewProps.yAxisEntity.labelFont.weight.c_str()];
        yAxisEntity[@"labelFont"] = labelFont;
    }

    if (newViewProps.yAxisEntity.labelTextColor != oldViewProps.yAxisEntity.labelTextColor ) {
        yAxisEntity[@"labelTextColor"] = [NSString stringWithUTF8String:newViewProps.yAxisEntity.labelTextColor.c_str()];
    };

    if (newViewProps.yAxisEntity.xOffset != oldViewProps.yAxisEntity.xOffset) {
      yAxisEntity[@"xOffset"] =@(newViewProps.yAxisEntity.xOffset);
    }

    


    maybeOldDataStruct = oldViewProps.data;
    NSLog(@"oldProps mevcut, dataSet sayısı: %lu", oldViewProps.data.dataSets.size());
  }else {
  xAxisEntity = [@{
        @"drawLabelsEnabled": @(newViewProps.xAxisEntity.drawLabelsEnabled),
        @"labelFont": @{
            @"size": @(newViewProps.xAxisEntity.labelFont.size),
            @"weight": [NSString stringWithUTF8String:newViewProps.xAxisEntity.labelFont.weight.c_str()]
        },
        @"labelPosition": [NSString stringWithUTF8String:newViewProps.xAxisEntity.labelPosition.c_str()],
        @"labelTextColor": [NSString stringWithUTF8String:newViewProps.xAxisEntity.labelTextColor.c_str()],
        @"yOffset": @(newViewProps.xAxisEntity.yOffset),
        @"xOffset": @(newViewProps.xAxisEntity.xOffset),
        @"axisMin": @(newViewProps.xAxisEntity.axisMin),
        @"axisMax":newViewProps.xAxisEntity.axisMax ? @(newViewProps.xAxisEntity.axisMax) : [NSNull null],
    } mutableCopy];
  yAxisEntity = [@{
      @"drawLabelsEnabled": @(newViewProps.yAxisEntity.drawLabelsEnabled),
          @"labelFont": @{
              @"size": @(newViewProps.yAxisEntity.labelFont.size),
              @"weight": [NSString stringWithUTF8String:newViewProps.yAxisEntity.labelFont.weight.c_str()]
          },
          @"labelPosition": [NSString stringWithUTF8String:newViewProps.yAxisEntity.labelPosition.c_str()],
          @"labelTextColor": [NSString stringWithUTF8String:newViewProps.yAxisEntity.labelTextColor.c_str()],
          @"xOffset": @(newViewProps.yAxisEntity.xOffset),
          @"yOffset": @(newViewProps.yAxisEntity.yOffset),
          @"axisMin": @(newViewProps.yAxisEntity.axisMin),
          @"axisMax":newViewProps.yAxisEntity.axisMax ? @(newViewProps.yAxisEntity.axisMax) : [NSNull null],
    } mutableCopy];
  }
  animationEntity = [@{
        @"xAxisDuration": @(newViewProps.animationEntity.xAxisDuration),
        @"xAxisEasing": [NSString stringWithUTF8String:newViewProps.animationEntity.xAxisEasing.c_str()],
        @"yAxisDuration":  @(newViewProps.animationEntity.yAxisDuration),
        @"yAxisEasing": [NSString stringWithUTF8String:newViewProps.animationEntity.yAxisEasing.c_str()],
    } mutableCopy];
  // Veri değişikliğini kontrol eden yardımcı fonksiyon
  auto hasDataChanged = [](const LineChartSpecViewDataStruct &newData,
                           const std::optional<LineChartSpecViewDataStruct> &maybeOldData) -> bool {
    // Yeni ve eski veri boşsa değişiklik yok
    if (newData.dataSets.empty()) {
      if (!maybeOldData.has_value() || maybeOldData->dataSets.empty()) {
        NSLog(@"Hem yeni hem eski veri boş.");
        return false;
      }
      NSLog(@"Yeni veri boş ama eski dolu, değişiklik var.");
      return true;
    }

    // Eğer eski veri yoksa, yeni veri gelmiş demektir
    if (!maybeOldData.has_value()) {
      NSLog(@"Eski veri null, yeni veri geldi. Değişiklik var.");
      return true;
    }

    const auto &oldData = maybeOldData.value();

    // dataSets sayısı farklıysa değişiklik var
    if (newData.dataSets.size() != oldData.dataSets.size()) {
      NSLog(@"Data sets size mismatch - new: %zu, old: %zu",
            newData.dataSets.size(), oldData.dataSets.size());
      return true;
    }

    // Teker teker dataSet içeriğini karşılaştır
    for (size_t i = 0; i < newData.dataSets.size(); i++) {
      const auto &newDataSet = newData.dataSets[i];
      const auto &oldDataSet = oldData.dataSets[i];

      if (newDataSet.label != oldDataSet.label) {
        NSLog(@"Label mismatch at index %zu", i);
        return true;
      }

      if (newDataSet.values.size() != oldDataSet.values.size()) {
        NSLog(@"Values size mismatch at index %zu - new: %zu, old: %zu",
              i, newDataSet.values.size(), oldDataSet.values.size());
        return true;
      }

      // Değerleri karşılaştır
      for (size_t j = 0; j < newDataSet.values.size(); j++) {
        if (newDataSet.values[j].x != oldDataSet.values[j].x ||
            newDataSet.values[j].y != oldDataSet.values[j].y) {
          NSLog(@"Value mismatch at index %zu.%zu", i, j);
          return true;
        }
      }
    }

    // Hiçbir fark yoksa
    return false;
  };

  // Eğer data değişmişse, Swift bileşenine yeni veriyi gönder
  if (hasDataChanged(newDataStruct, maybeOldDataStruct)) {
    NSLog(@"Veri değişmiş, grafik güncelleniyor...");
    NSMutableArray *newDataArray = [NSMutableArray array];

    for (const auto &dataSet : newDataStruct.dataSets) {
      NSMutableArray *valuesArray = [NSMutableArray array];

      for (const auto &entry : dataSet.values) {
        @try {
          [valuesArray addObject:@{
            @"x": @(entry.x),
            @"y": @(entry.y)
          }];
        } @catch (NSException *exception) {
          NSLog(@"Veri eklenirken hata oluştu: %@", exception);
          continue;
        }
      }
        
        
      if (valuesArray.count > 0) {
        @try {
            
            NSMutableArray *lineDashLengthsArray = [NSMutableArray array];
            for (double val : dataSet.limitLineEntity.lineDashLengths) {
                [lineDashLengthsArray addObject:@(val)];
            }
            
          [newDataArray addObject:@{
            @"values": valuesArray,
            @"label": [NSString stringWithUTF8String:dataSet.label.c_str()],
            @"drawVerticalHighlightIndicatorEnabled": @(dataSet.drawVerticalHighlightIndicatorEnabled),
            @"drawHorizontalHighlightIndicatorEnabled": @(dataSet.drawHorizontalHighlightIndicatorEnabled),
            @"drawValuesEnabled": @(dataSet.drawValuesEnabled),
            @"mode": [NSString stringWithUTF8String:dataSet.mode.c_str()],
            @"limitLineEntity": @{
              @"lineWidth": @(dataSet.limitLineEntity.lineWidth),
              @"lineColor": [NSString stringWithUTF8String:dataSet.limitLineEntity.lineColor.c_str()],
              @"lineDashLengths": lineDashLengthsArray,
              @"labelPosition": [NSString stringWithUTF8String:dataSet.limitLineEntity.labelPosition.c_str()],
              @"fontSize":@(dataSet.limitLineEntity.fontSize),
              @"limit":@(dataSet.limitLineEntity.limit),
              @"label": [NSString stringWithUTF8String:dataSet.limitLineEntity.label.c_str()],
            },
            @"gradientColorsData": @{
              @"from": [NSString stringWithUTF8String:dataSet.gradientColorsData.from.c_str()],
              @"to": [NSString stringWithUTF8String:dataSet.gradientColorsData.to.c_str()]
            }
          }];
        } @catch (NSException *exception) {
          NSLog(@"Data set oluşturulurken hata oluştu: %@", exception);
          continue;
        }
      }
    }

    if (newDataArray.count > 0) {
      @try {
        NSDictionary *newData = @{ @"dataSets": newDataArray };
         NSLog(@"Set dataya gidiyorrrr", (unsigned long)newDataArray.count);
        [_lineChartView setData:newData];
        NSLog(@"Grafik başarılı şekilde %lu dataSet ile güncellendi.", (unsigned long)newDataArray.count);
      } @catch (NSException *exception) {
        NSLog(@"Grafik verisi set edilirken hata oluştu: %@", exception);
      }
    } else {
      NSLog(@"Güncellenecek geçerli data set bulunamadı.");
    }
  } else {
    NSLog(@"Veri değişmemiş, grafik güncellenmeyecek.");
  }

  [_lineChartView setMarkerEntity:markerEntity];
  [_lineChartView setYAxisEntity:yAxisEntity];
  [_lineChartView setAnimationEntity:animationEntity];
  [_lineChartView setXAxisEntity:xAxisEntity];
  [_lineChartView setDrawGridLinesEnabled:newViewProps.drawGridLinesEnabled];
  [_lineChartView setHighlightPerTapEnabled:newViewProps.highlightPerTapEnabled];
  [_lineChartView setHighlightPerDragEnabled:newViewProps.highlightPerDragEnabled];
   [_lineChartView setDragEnabled:newViewProps.dragEnabled];
  [super updateProps:props oldProps:oldProps];
}

@end

// React Native bu bileşeni tanıyabilsin diye sınıfı dışa aktarıyoruz
Class<RCTComponentViewProtocol> LineChartSpecViewCls(void) {
  return LineChartSpecViewComponentView.class;
}

#endif
