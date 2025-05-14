//
//  IntAxisValueFormatter.swift
//  ChartsDemo-iOS
//
//  Created by Jacob Christie on 2017-07-09.
//  Copyright © 2017 jc. All rights reserved.
//

import DGCharts
import Foundation

@objc public class IntAxisValueFormatter: NSObject {
    public func stringForValue(_ value: Double, axis _: AxisBase?) -> String {
        return "\(Int(value))"
    }
}
