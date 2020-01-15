//
//  MultipartFormData.swift
//  PreTest
//
//  Created by alpiopio on 15/01/20.
//  Copyright © 2020 alpiopio. All rights reserved.
//

import Foundation

struct MultipartFormData {
    enum Provider {
        case text(String)
        case data(Data)
        case number(Int)
    }
    
    let provider: Provider
    let name: String
    let filename: String?
    let mimeType: String?
    
    init (provider: Provider, name: String, filename: String? = nil, mimeType: String? = nil) {
        self.provider = provider
        self.name = name
        self.filename = filename
        self.mimeType = mimeType
    }
}
