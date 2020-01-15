//
//  RegisterResponse.swift
//  PreTest
//
//  Created by alpiopio on 15/01/20.
//  Copyright © 2020 alpiopio. All rights reserved.
//

import Foundation

struct RegisterResponse: Codable {
    struct Data: Codable {
        struct User: Codable {
            struct UserDevice: Codable {
                let deviceToken: String?
                let deviceType: String?
                let deviceStatus: String?
                
                private enum CodingKeys: String, CodingKey {
                    case deviceToken = "device_token"
                    case deviceType = "device_type"
                    case deviceStatus = "device_status"
                }
            }
            
            let id: String?
            let phone: String?
            let userStatus: String?
            let userType: String?
            let sugarId: String?
            let country: String?
            let latlong: String?
            let userDevice: UserDevice
            
            private enum CodingKeys: String, CodingKey {
                case id
                case phone
                case userStatus = "user_status"
                case userType = "user_type"
                case sugarId = "sugar_id"
                case country
                case latlong
                case userDevice = "user_device"
            }
        }
        
        let user: User
    }
    
    let data: Data
}
