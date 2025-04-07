import Foundation
import DGCharts
import React

@objc(LineChartViewManager)
class LineChartViewManager: RCTViewManager {
   override public func view() -> UIView! {
       return LineChartSpecView()
   }

   override static func requiresMainQueueSetup() -> Bool {
       return true
   }
}
