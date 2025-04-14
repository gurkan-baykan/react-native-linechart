import Foundation
import DGCharts
import React

@objc(LineChartSpecViewManager)
class LineChartSpecViewManager: RCTViewManager {
   override public func view() -> UIView! {
       return LineChartSpecView()
   }

   override static func requiresMainQueueSetup() -> Bool {
       return true
   }
}
