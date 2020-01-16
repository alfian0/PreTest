//
//  Media.swift
//  PreTest
//
//  Created by alpiopio on 16/01/20.
//  Copyright © 2020 alpiopio. All rights reserved.
//

import UIKit

public struct Media {
    let key: String
    let filename: String
    let data: Data
    let mimeType: String
    
    init(key: String, filename: String, data: Data, mimeType: String) {
        self.key = key
        self.filename = filename
        self.data = data
        self.mimeType = mimeType
    }
    
    init?(withImage image: UIImage, forKey key: String) {
        self.key = key
        self.mimeType = "image/jpeg"
        self.filename = "\(arc4random()).jpeg"
        guard let data = image.jpegData(compressionQuality: 0.1) else { return nil }
        self.data = data
    }
}
