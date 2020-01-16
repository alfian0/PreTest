//
//  String+Extension.swift
//  PreTest
//
//  Created by alpiopio on 16/01/20.
//  Copyright © 2020 alpiopio. All rights reserved.
//

import Foundation

extension String {
    // MARK: Convert String date from backend (UTC) to Local
    func toDate(dateFormat format: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "ID")
        return formatter.date(from: self)
    }
}
