//
//  CoverResponse.swift
//  PreTest
//
//  Created by alpiopio on 16/01/20.
//  Copyright © 2020 alpiopio. All rights reserved.
//

import Foundation

struct CoverResponse: Codable {
    struct Data: Codable {
        struct UserPicture: Codable {
            struct CoverPicture: Codable {
                let url: String?
            }
            let id: String?
            let coverPicture: CoverPicture
            
            private enum CodingKeys: String, CodingKey {
                case id
                case coverPicture = "cover_picture"
            }
        }
        let userPicture: UserPicture
        
        private enum CodingKeys: String, CodingKey {
            case userPicture = "user_picture"
        }
    }
    let data: Data
}
