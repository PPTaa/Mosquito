//
//  DateValueFormatter.swift
//  Mosquito
//
//  Created by leejungchul on 2023/03/13.
//

import Foundation
import Charts

public class DateValueFormatter: NSObject, AxisValueFormatter {
    private let dateFormatter = DateFormatter()
    
    override init() {
        super.init()
        dateFormatter.timeZone = TimeZone(identifier: "ko_kr")
        dateFormatter.locale = Locale(identifier: "ko_kr")
        dateFormatter.dateFormat = "MM.dd"
    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return dateFormatter.string(from: Date(timeIntervalSince1970: value))
    }
}
