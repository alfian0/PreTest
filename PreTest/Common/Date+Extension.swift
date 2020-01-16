//
//  Date+Extension.swift
//  PreTest
//
//  Created by alpiopio on 16/01/20.
//  Copyright © 2020 alpiopio. All rights reserved.
//

import Foundation

extension Date {
    // MARK: Default date format is use UTC we need convert to local to make sure date use local timezone
    func toString(dateFormat format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = TimeZone.current
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "ID")
        return formatter.string(from: self)
    }
}
