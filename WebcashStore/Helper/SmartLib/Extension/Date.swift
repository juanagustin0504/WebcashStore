//
//  Date.swift
//  WebcashStore
//
//  Created by God Save The King on 1/23/20.
//  Copyright © 2020 Webcash. All rights reserved.
//

import Foundation
extension Date {
    
    var yesterday: Date { return Date().dayBefore }
    var tomorrow : Date { return Date().dayAfter }
    
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var day: Int {
        return Calendar.current.component(.day,  from: self)
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var year: Int {
        return Calendar.current.component(.year,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return dayAfter.month != month
    }
    
    
    var millisecondsSince1970:Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds:Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
    
    var weekdayOrdinal: Int {
        return Calendar.current.component(.weekday, from: self) // 0-6
    }
    
    var weekdayName: String {
        return formatToString(format: "E")
    }
    
    var monthName: String {
        return formatToString(format: "MMM")
    }
    
    func formatToString(format: String) -> String {
        let dateformatter           = DateFormatter()
        dateformatter.dateFormat    = format
        dateformatter.timeZone      = Calendar.current.timeZone
        dateformatter.locale        = Calendar.current.locale
        
        return dateformatter.string(from: self)
    }
    
    /// Calculate 2 dates
    /// - Parameter comp: .month, .day, .year
    /// - Parameter date: date
    func interval(ofComponent comp: Calendar.Component, fromDate date: Date) -> Int {

        let currentCalendar = Calendar.current

        guard let start = currentCalendar.ordinality(of: comp, in: .era, for: date) else { return 0 }
        guard let end = currentCalendar.ordinality(of: comp, in: .era, for: self) else { return 0 }

        return end - start
    }
}
