import DGCharts
import Foundation

public class DateValueFormatter: NSObject {
    private let dateFormatter = DateFormatter()

    override init() {
        super.init()
        dateFormatter.dateFormat = "dd MMM HH:mm"
    }

    public func stringForValue(_ value: Double, axis _: AxisBase?) -> String {
        return dateFormatter.string(from: Date(timeIntervalSince1970: value))
    }
}
