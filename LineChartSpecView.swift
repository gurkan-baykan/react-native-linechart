import DGCharts
import React
import UIKit

struct CircleEntityStruct {
  let size: CGFloat
  let color: CGColor
  var isEmpty: Bool {
    return size == nil && color == nil
  }
}


struct AnimationEntity {
  let xAxisDuration:CGFloat
  let yAxisDuration:CGFloat
  let xAxisEasing: String
  let yAxisEasing:String
  }

@objc(LineChartSpecView)
class LineChartSpecView: UIView, ChartViewDelegate {
  private var chartView: LineChartView!
  private var lineChartData: LineChartData!
  private var limitLabel: UILabel!
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupChartView()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    
    setupChartView()
  }
  
  private func setupChartView() {
    chartView = LineChartView(frame: bounds)
    chartView.delegate = self
    chartView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    addSubview(chartView)
    
    chartView.dragEnabled = true
    chartView.setScaleEnabled(false)
    chartView.pinchZoomEnabled = false
    
    chartView.dragXEnabled = false;
    chartView.dragYEnabled = false;
    chartView.scaleXEnabled = false;
    chartView.scaleYEnabled = false;
    chartView.backgroundColor = .white
    
    let xAxis = chartView.xAxis
    xAxis.labelPosition = .topInside
    xAxis.labelFont = .systemFont(ofSize: 15, weight: .light)
    xAxis.labelTextColor = UIColor.black
    xAxis.drawAxisLineEnabled = false
    xAxis.drawGridLinesEnabled = false
    xAxis.centerAxisLabelsEnabled = false
    xAxis.yOffset = 0
    xAxis.drawLabelsEnabled = false
    
    let leftAxis = chartView.leftAxis
    leftAxis.labelPosition = .insideChart
    leftAxis.labelFont = .systemFont(ofSize: 15, weight: .light)
    leftAxis.drawGridLinesEnabled = true
    leftAxis.granularityEnabled = false
    leftAxis.axisMinimum = 0
    leftAxis.axisMaximum = 120
    leftAxis.yOffset = 30
    leftAxis.xOffset = -10
    leftAxis.labelTextColor = UIColor.red
    leftAxis.drawLabelsEnabled = true
    
    limitLabel = UILabel()
    limitLabel.backgroundColor = UIColor.white.withAlphaComponent(0.8)
    limitLabel.textColor = .black
    limitLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
    limitLabel.textAlignment = .center
    limitLabel.layer.cornerRadius = 5
    limitLabel.text = "deheemmemem"
    limitLabel.layer.masksToBounds = true
    limitLabel.isHidden = true
    
    addSubview(limitLabel)
    
    chartView.data?.setDrawValues(false)
    chartView.notifyDataSetChanged()
    chartView.legend.form = .line
    chartView.highlightPerTapEnabled = false
    chartView.highlightPerDragEnabled = false
    chartView.animate(xAxisDuration: 0.8,easingOption: ChartEasingOption.linear)
    chartView.animate(yAxisDuration: 1,easingOption: ChartEasingOption.linear)
    chartView.rightAxis.enabled = false
    chartView.legend.form = .line
    chartView.extraTopOffset = 25
    let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
    longPressGesture.minimumPressDuration = 0 // Dokunur dokunmaz algılasın
    chartView.addGestureRecognizer(longPressGesture)
    
  }
  @objc func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
    let location = gesture.location(in: chartView) // Dokunulan noktayı al
    
    switch gesture.state {
    case .began, .changed:
      if let highlight = chartView.getHighlightByTouchPoint(location) {
        chartView.highlightValue(highlight) // Highlight'ı göster
      }
    case .ended, .cancelled:
      chartView.highlightValue(nil) // Parmağını kaldırınca highlight'ı kaldır
    default:
      break
    }
  }
  
  
  
  @objc func setData(_ data: NSDictionary) {
    guard let dataSetsArray = data["dataSets"] as? [[String: Any]] else {
      print("Invalid data format for dataSets")
      return
    }
    
    var chartDataSets: [LineChartDataSet] = []
    chartView.leftAxis.removeAllLimitLines()
    for (index, dataSetDict) in dataSetsArray.enumerated() {
      guard let valuesArray = dataSetDict["values"] as? [[String: Any]],
            let label = dataSetDict["label"] as? String
      else {
        continue
      }
      
      let limitLines = dataSetDict["limitLineEntity"] as? [String: Any]
      let gradientData = dataSetDict["gradientColorsData"] as? NSDictionary
      let drawHorizontalHighlightIndicatorEnabled = (dataSetDict["drawHorizontalHighlightIndicatorEnabled"] as? Int == 1)
      let drawVerticalHighlightIndicatorEnabled = (dataSetDict["drawVerticalHighlightIndicatorEnabled"] as? Int == 1)
      let fromColor = (gradientData?["from"] as? String) ?? "#FFFFFF"
      let toColor = (gradientData?["to"] as? String) ?? "#000000"
      let drawValuesEnabled =  (dataSetDict["drawValuesEnabled"] as? Int == 1)
      
      let gradientColors = [
        ChartColorTemplates.colorFromString(fromColor).cgColor,
        ChartColorTemplates.colorFromString(toColor).cgColor
      ]
      
      let entries = valuesArray.compactMap { valueDict -> ChartDataEntry? in
        guard let x = valueDict["x"] as? Double,
              let y = valueDict["y"] as? Double
        else {
          return nil
        }
        return ChartDataEntry(x: x, y: y)
      }
      
      let dataSet = LineChartDataSet(entries: entries, label: label)
      
      if let mode = dataSetDict["mode"] as? String {
        
        let chartMode: LineChartDataSet.Mode
        
        switch mode {
        case "cubicBezier":
          chartMode = .cubicBezier
        case "stepped":
          chartMode = .stepped
        case "linear":
          chartMode = .linear
        case "horizontalBezier":
          chartMode = .horizontalBezier
        default:
          chartMode = .linear
        }
        
        dataSet.mode = chartMode
      }
      
      dataSet.axisDependency = .left
      dataSet.setColor(UIColor.black)
      dataSet.colors = [NSUIColor.red]
      dataSet.circleRadius = 5.0
      dataSet.circleHoleRadius = 2.0
      dataSet.setCircleColor(.blue)
      dataSet.drawCirclesEnabled = true
      
      let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors as CFArray, locations: nil)
      dataSet.fill = LinearGradientFill(gradient: gradient!, angle: 90)
      dataSet.lineDashLengths = nil
      dataSet.highlightLineDashLengths = [5, 2.5]
      dataSet.fillAlpha = 1
      dataSet.drawFilledEnabled = true
      dataSet.setColor(.black)
      dataSet.highlightLineWidth = 2.0
      dataSet.drawVerticalHighlightIndicatorEnabled =  drawVerticalHighlightIndicatorEnabled
      dataSet.drawHorizontalHighlightIndicatorEnabled = drawHorizontalHighlightIndicatorEnabled
      dataSet.valueFont = .systemFont(ofSize: 13)
      dataSet.highlightColor = UIColor.black
      dataSet.drawCircleHoleEnabled = false
      dataSet.fillFormatter = DefaultFillFormatter { _, dataProvider -> CGFloat in
        return dataProvider.chartYMin ?? 0.0 // Grafik alanının alt sınırını doldurma referansı olarak al
      }
      
      dataSet.lineWidth = 2.0
      dataSet.circleRadius = 4.0
      dataSet.drawCirclesEnabled = false
      dataSet.drawValuesEnabled = drawValuesEnabled
      
      if let limitLineEntity = limitLines, !limitLineEntity.isEmpty {
        configureLimitLine(with: limitLineEntity, dataSet: dataSet)
      }
      chartDataSets.append(dataSet)
    }
    
    let chartData = LineChartData(dataSets: chartDataSets)
    chartView.data = chartData
    chartView.notifyDataSetChanged()
  }
  
  
  private func configureLimitLine(with limitLineEntity: [String: Any], dataSet: LineChartDataSet) {
    let lineWidth = limitLineEntity["lineWidth"] as? CGFloat ?? 1.0
    let lineColor = limitLineEntity["lineColor"] as? String ?? "#FF0000"
    let lineDashLengths = limitLineEntity["lineDashLengths"] as? [CGFloat] ?? [5, 5]
    let fontSize = limitLineEntity["fontSize"] as? CGFloat ?? 10.0
    let labelPosition = limitLineEntity["labelPosition"] as? String ?? "rightTop"
    let labelValueColor = limitLineEntity["labelValueColor"] as? String ?? "#FF0000"
    
    if let lastEntry = dataSet.entries.last {
      let limit = lastEntry.y
      let labelText = limitLineEntity["label"] as? String ?? String(limit)
      
      let limitLine = ChartLimitLine(limit: limit)
      
      limitLine.lineWidth = lineWidth
      limitLine.lineColor = UIColor(hex: lineColor) ?? UIColor.black
      limitLine.lineDashLengths = lineDashLengths
      limitLine.drawLabelEnabled = true
      limitLine.label = labelText
      
      switch labelPosition {
      case "leftTop":
        limitLine.labelPosition = .leftTop
      case "leftBottom":
        limitLine.labelPosition = .leftBottom
      case "rightBottom":
        limitLine.labelPosition = .rightBottom
      default:
        limitLine.labelPosition = .rightTop
      }
      
      limitLine.valueFont = .systemFont(ofSize: fontSize)
      limitLine.valueTextColor = UIColor(hex: labelValueColor) ?? UIColor.clear
      
      chartView.leftAxis.addLimitLine(limitLine)
    } else {
      print("Son giriş bulunamadı!")
    }
  }
  
  
  @objc public func setXAxisEntity(_ xAxisEntity: NSDictionary) {
    
    guard
      // let size = xAxisEntity["size"] as? CGFloat,
      let drawLabelsEnabled = xAxisEntity["drawLabelsEnabled"] as? NSNumber,
      let labelPositionString = xAxisEntity["labelPosition"] as? String,
      let colorString = xAxisEntity["labelTextColor"] as? String,
      let labelTextColor = UIColor(hex: colorString),
      let yOffset = xAxisEntity["yOffset"] as? CGFloat,
      let labelFont = xAxisEntity["labelFont"] as? [String: Any],
      let fontSize = labelFont["size"] as? CGFloat
        
    else {
      return
    }
    
    
    if let labelPositionString = xAxisEntity["labelPosition"] as? String {
      let labelPosition: XAxis.LabelPosition
      
      switch labelPositionString {
      case "top":
        labelPosition = .top
      case "bottom":
        labelPosition = .bottom
      case "topInside":
        labelPosition = .topInside
      case "bottomInside":
        labelPosition = .bottomInside
      default:
        labelPosition = .bottom
      }
      
      chartView.xAxis.labelPosition = labelPosition
    }
    chartView.xAxis.labelFont = .systemFont(ofSize: fontSize, weight: .light)
    chartView.xAxis.drawLabelsEnabled = drawLabelsEnabled == 1
    chartView.xAxis.labelTextColor = labelTextColor
    chartView.xAxis.yOffset = yOffset
    chartView.xAxis.xOffset = xAxisEntity["xOffset"] as? CGFloat ?? 0
    chartView.xAxis.axisMinimum = xAxisEntity["axisMin"] as? CGFloat ?? 0
    if let axisMax = xAxisEntity["axisMax"] as? CGFloat {
      chartView.xAxis.axisMaximum = axisMax
    }
  }
  
  @objc public func setYAxisEntity(_ yAxisEntity: NSDictionary) {
    
    guard
      let drawLabelsEnabled = yAxisEntity["drawLabelsEnabled"] as? NSNumber,
      let labelPositionString = yAxisEntity["labelPosition"] as? String,
      let colorString = yAxisEntity["labelTextColor"] as? String,
      let labelTextColor = UIColor(hex: colorString),
      let xOffset = yAxisEntity["xOffset"] as? CGFloat,
      let labelFont = yAxisEntity["labelFont"] as? [String: Any],
      let fontSize = labelFont["size"] as? CGFloat
        
    else {
      print(yAxisEntity,"yyyy")
      return
    }
    
    
    if let labelPositionString = yAxisEntity["labelPosition"] as? String {
      
      let labelPosition: YAxis.LabelPosition
      
      switch labelPositionString {
      case "outside":
        labelPosition = .outsideChart
      case "inside":
        labelPosition = .insideChart
      default:
        labelPosition = .insideChart
      }
      
      chartView.leftAxis.labelPosition = labelPosition
    }
    chartView.leftAxis.labelFont = .systemFont(ofSize: fontSize, weight: .light)
    chartView.leftAxis.drawLabelsEnabled = drawLabelsEnabled == 1
    chartView.leftAxis.labelTextColor = labelTextColor
    chartView.leftAxis.xOffset = xOffset
    chartView.leftAxis.yOffset = yAxisEntity["yOffset"] as? CGFloat ?? 0
    chartView.leftAxis.axisMinimum = yAxisEntity["axisMin"] as? CGFloat ?? 0
    
    if let axisMax = yAxisEntity["axisMax"] as? CGFloat {
      chartView.leftAxis.axisMaximum = axisMax
    }
    
  }
  
  @objc public func setMarkerEntity(_ markerEntity: NSDictionary) {
    var markerColor: UIColor?
    var markerTextColor: UIColor?
    var markerFontSize: CGFloat?
    var circleColor: UIColor?
    var size: CGFloat?
    var top, bottom, left, right: CGFloat?
    
    if let markerBgColorString = markerEntity["bgColor"] as? String,
       let markerTextColorString = markerEntity["color"] as? String,
       let fontSize = markerEntity["fontSize"] as? CGFloat {
      markerColor = UIColor(hex: markerBgColorString)
      markerTextColor = UIColor(hex: markerTextColorString)
      markerFontSize = fontSize
    } else {
      print("❌ Marker renk veya font boyutu eksik!")
    }
    
    if let circleData = markerEntity["circleEntity"] as? [String: Any],
       let circleSize = circleData["size"] as? CGFloat,
       let colorString = circleData["color"] as? String {
      circleColor = UIColor(hex: colorString)
      size = circleSize
    } else {
      print("❌ Circle size veya color eksik!")
    }
    
    if let positionData = markerEntity["position"] as? [String: Any],
       let pTop = positionData["top"] as? CGFloat,
       let pBottom = positionData["bottom"] as? CGFloat,
       let pLeft = positionData["left"] as? CGFloat,
       let pRight = positionData["right"] as? CGFloat {
      top = pTop
      bottom = pBottom
      left = pLeft
      right = pRight
    } else {
      print("❌ Position değerlerinden biri eksik!")
    }
    
    let finalSize: CGFloat = size ?? 0
    let finalCircleColor: UIColor = circleColor ?? UIColor.black
    let circleEntity = CircleEntityStruct(size: finalSize, color: finalCircleColor.cgColor)
    let finalMarkerColor: UIColor = markerColor ?? UIColor.clear
    let finalMarkerTextColor = markerTextColor ?? UIColor.black
    let finalMarkerFontSize = markerFontSize ?? 15
    let finalTop: CGFloat = top ?? 8
    let finalBottom:CGFloat = bottom ?? 20
    let finalLeft = left ?? 8
    let finalRight = right ?? 8
    
    let marker = BalloonMarker(
      circleEntity: circleEntity,
      color: finalMarkerColor,
      font: .systemFont(ofSize: finalMarkerFontSize),
      textColor: finalMarkerTextColor,
      insets: UIEdgeInsets(top: finalTop, left: finalLeft, bottom: finalBottom, right: finalRight)
    )
    
    marker.layer.zPosition = 9999
    marker.chartView = chartView
    chartView.marker = marker
    
  }
  
  @objc public func setDragEnabled(_ dragEnabled: Bool) {
    chartView.dragEnabled = dragEnabled
  }
  
  
  @objc public func setHighlightPerTapEnabled(_ highlightPerTapEnabled: Bool) {
    chartView.highlightPerTapEnabled = highlightPerTapEnabled
  }
  
  @objc public func setHighlightPerDragEnabled(_ highlightPerDragEnabled: Bool) {
    chartView.highlightPerDragEnabled = highlightPerDragEnabled
  }
  
  @objc public func setBgColor(_ bgColor: NSString?) {
    
    guard let bgColorString = bgColor as? String else {
      print("bgColor is nil or not a String")
      return
    }
    
    chartView.backgroundColor = UIColor(hex: bgColorString as String)
  }
  
  @objc public func setDrawGridLinesEnabled(_ drawGridLinesEnabled: Bool) {
    chartView.leftAxis.drawGridLinesEnabled = drawGridLinesEnabled
  }
  
  @objc public func setAnimationEntity(_ animationEntity: [String: Any]) {
    let xAxisDuration = animationEntity["xAxisDuration"] as? CGFloat ?? 0.8
    let yAxisDuration = animationEntity["yAxisDuration"] as? CGFloat ?? 1
    let xAxisEasing = animationEntity["xAxisEasing"] as? ChartEasingOption ?? ChartEasingOption.linear
    let yAxisEasing = animationEntity["yAxisEasing"] as? ChartEasingOption ?? ChartEasingOption.linear
    
    chartView.animate(xAxisDuration: xAxisDuration,easingOption: xAxisEasing)
    chartView.animate(yAxisDuration: yAxisDuration, easingOption: yAxisEasing)
  }
  
}

