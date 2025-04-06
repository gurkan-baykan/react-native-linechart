import Foundation
import DGCharts
import React

@objcMembers
public class LineChartViewManager: RCTViewManager {
   override public func view() -> UIView! {
       return LineChartSpecView()
   }

   override public static func requiresMainQueueSetup() -> Bool {
       return true
   }
}
