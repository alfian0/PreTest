//
//  ErrorResponse.swift
//  PreTest
//
//  Created by alpiopio on 15/01/20.
//  Copyright © 2020 alpiopio. All rights reserved.
//

import Foundation

struct ErrorResponse: Codable {
    struct Error: Codable {
        let errors: [String]
    }
    let error: Error
}
