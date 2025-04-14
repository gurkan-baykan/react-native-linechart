import type { HostComponent, ViewProps } from 'react-native';
import codegenNativeComponent from 'react-native/Libraries/Utilities/codegenNativeComponent';
import type { Int32, Float } from 'react-native/Libraries/Types/CodegenTypes';

export interface DataSetEntry {
  x: Int32;
  y: Int32;
}

export type Mode = 'cubicBezier' | 'stepped' | 'linear' | 'horizontalBezier';

export const enum ChartEasingOptionProps {
  Linear = 'linear',
  EaseInQuad = 'easeInQuad',
  EaseOutQuad = 'easeOutQuad',
  EaseInOutQuad = 'easeInOutQuad',
  EaseInCubic = 'easeInCubic',
  EaseOutCubic = 'easeOutCubic',
  EaseInOutCubic = 'easeInOutCubic',
  EaseInQuart = 'easeInQuart',
  EaseOutQuart = 'easeOutQuart',
  EaseInOutQuart = 'easeInOutQuart',
  EaseInQuint = 'easeInQuint',
  EaseOutQuint = 'easeOutQuint',
  EaseInOutQuint = 'easeInOutQuint',
  EaseInSine = 'easeInSine',
  EaseOutSine = 'easeOutSine',
  EaseInOutSine = 'easeInOutSine',
  EaseInExpo = 'easeInExpo',
  EaseOutExpo = 'easeOutExpo',
  EaseInOutExpo = 'easeInOutExpo',
  EaseInCirc = 'easeInCirc',
  EaseOutCirc = 'easeOutCirc',
  EaseInOutCirc = 'easeInOutCirc',
  EaseInElastic = 'easeInElastic',
  EaseOutElastic = 'easeOutElastic',
  EaseInOutElastic = 'easeInOutElastic',
  EaseInBack = 'easeInBack',
  EaseOutBack = 'easeOutBack',
  EaseInOutBack = 'easeInOutBack',
  EaseInBounce = 'easeInBounce',
  EaseOutBounce = 'easeOutBounce',
  EaseInOutBounce = 'easeInOutBounce',
}

export interface DataSet {
  values: DataSetEntry[];
  limitLineEntity: LimitLineEntity;
  label: string;
  gradientColorsData: { from: string; to: string };
  drawVerticalHighlightIndicatorEnabled: boolean;
  drawHorizontalHighlightIndicatorEnabled: boolean;
  drawValuesEnabled: boolean;
  mode: string; //Mode
}
export interface LineData {
  dataSets: DataSet[];
}

export interface AnimationEntity {
  xAxisDuration: Float;
  yAxisDuration: Float;
  xAxisEasing: string; // you can look ChartEasingOptionProps type here
  yAxisEasing: string; // you can look ChartEasingOptionProps type here
}
export type MarkerEntity = {
  bgColor: string;
  color: string;
  fontSize: Float;
  position: {
    left: Float;
    top: Float;
    bottom: Float;
    right: Float;
  };
  circleEntity: CircleEntity | undefined;
};
export type CircleEntity = {
  size: Float | undefined;
  color: string | undefined;
};

export interface LabelFont {
  size: Float;
  weight: string;
}
export type LabelPositionX = 'top' | 'bottom' | 'topInside' | 'bottomInside';
export type LabelPositionY = 'outside' | 'inside';
export type LimitLabelPositionX =
  | 'topLeft'
  | 'leftBottom'
  | 'rightTop'
  | 'rightBottom';
export interface XAxisEntity {
  drawLabelsEnabled: boolean;
  labelPosition: string; // LabelPosition type used to be here;
  labelFont?: LabelFont;
  labelTextColor?: string;
  yOffset?: Float;
  xOffset?: Float;
  axisMin?: Float;
  axisMax?: Float;
}

export interface YAxisEntity {
  drawLabelsEnabled: boolean;
  labelPosition: string; // LabelPositionY type used to be here;
  labelFont?: LabelFont;
  labelTextColor?: string;
  xOffset?: Float;
  yOffset?: Float;
  axisMin?: Float;
  axisMax?: Float;
}

export interface LimitLineEntity {
  lineWidth: Float;
  lineColor: string;
  lineDashLengths: Float[];
  labelPosition: string; // LimitLabelPositionX you use LimitLabelPositionX type
  fontSize: Float;
  limit?: Float;
  label?: string;
  labelValueColor?: string;
}

export interface NativeProps extends ViewProps {
  data: LineData;
  dragEnabled?: boolean;
  bgColor?: string;
  animationEntity?: AnimationEntity;
  drawGridLinesEnabled?: boolean;
  markerEntity: MarkerEntity | undefined;
  xAxisEntity?: XAxisEntity;
  yAxisEntity?: YAxisEntity;
  highlightPerTapEnabled: boolean;
  highlightPerDragEnabled: boolean;
}

export default codegenNativeComponent<NativeProps>(
  'LineChartSpecView'
) as HostComponent<NativeProps>;
