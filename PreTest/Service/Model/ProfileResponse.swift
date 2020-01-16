//
//  ProfileResponse.swift
//  PreTest
//
//  Created by alpiopio on 16/01/20.
//  Copyright © 2020 alpiopio. All rights reserved.
//

import Foundation

struct ProfileResponse: Codable {
    struct Data: Codable {
        struct User: Codable {
            struct Education: Codable {
                let schoolName: String?
                let graduationTime: String?
                
                private enum CodingKeys: String, CodingKey {
                    case schoolName = "school_name"
                    case graduationTime = "graduation_time"
                }
            }
            
            struct Career: Codable {
                let companyName: String?
                let startingFrom: String?
                let endingIn: String?
                
                private enum CodingKeys: String, CodingKey {
                    case companyName = "company_name"
                    case startingFrom = "starting_from"
                    case endingIn = "ending_in"
                }
            }
            
            struct CoverPicture: Codable {
                let url: String?
            }
            
            struct Pic: Codable {
                struct Picture: Codable {
                    let url: String?
                }
                let id: String?
                let picture: Picture
            }
            
            let id: String?
            let name: String?
            let level: Int?
            let age: Int?
            let birthday: String?
            let gender: String?
            let zodiac: String?
            let hometown: String?
            let bio: String?
            let latlong: String?
            let education: Education
            let career: Career
            let userPictures: [Pic]
            let userPicture: Pic?
            let coverPicture: CoverPicture
            
            private enum CodingKeys: String, CodingKey {
                case id
                case name
                case level
                case age
                case birthday
                case gender
                case zodiac
                case hometown
                case bio
                case latlong
                case education
                case career
                case userPictures = "user_pictures"
                case userPicture = "user_picture"
                case coverPicture = "cover_picture"
            }
        }
        
        let user: User
    }
    
    let data: Data
}
