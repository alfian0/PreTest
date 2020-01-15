//
//  LoginResponse.swift
//  PreTest
//
//  Created by alpiopio on 15/01/20.
//  Copyright © 2020 alpiopio. All rights reserved.
//

import Foundation

struct LoginResponse: Codable {
    struct Data: Codable {
        struct User: Codable {
            let accessToken: String?
            let tokenType: String?
            
            private enum CodingKeys: String, CodingKey {
                case accessToken = "access_token"
                case tokenType = "token_type"
            }
        }
        
        let user: User
    }
    
    let data: Data
}
