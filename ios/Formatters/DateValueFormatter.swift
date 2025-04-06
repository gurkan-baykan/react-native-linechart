import DGCharts
import Foundation

@objc public class DateValueFormatter: NSObject, AxisValueFormatter {
    private let dateFormatter = DateFormatter()

    override init() {
        super.init()
        dateFormatter.dateFormat = "dd MMM HH:mm"
    }

    @objc public func stringForValue(_ value: Double, axis _: AxisBase?) -> String {
        return dateFormatter.string(from: Date(timeIntervalSince1970: value))
    }
}
