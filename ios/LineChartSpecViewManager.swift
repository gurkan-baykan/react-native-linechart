 
import Foundation

@objc(LineChartSpecViewManager)
public class LineChartSpecViewManager: RCTViewManager {
    override func view() -> UIView! {
        return LineChartSpecView()
    }

    override static func requiresMainQueueSetup() -> Bool {
        return true
    }
}
