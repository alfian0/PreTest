//
//  PreTestAPI.swift
//  PreTest
//
//  Created by alpiopio on 15/01/20.
//  Copyright © 2020 alpiopio. All rights reserved.
//

import Foundation

enum PreTestAPI {
    case register(phone: String, password: String, country: String, latlong: String, deviceToken: String, deviceType: Int)
    case otpRequest(phone: String)
    case otpMatch(userId: String, otpCode: String)
    

}

extension PreTestAPI: EndPointType {
    var baseURL: URL {
        guard let url = URL(string: "http://pretest-qa.privydev.id/api/v1/") else { fatalError("baseURL could not be configured.")}
        return url
    }
    
    var path: String {
        switch self {
        case .register:
            return "register"
        case .otpRequest:
            return "register/otp/request"
        case .otpMatch:
            return "register/otp/match"
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .register(let (phone, password, country, latlong, deviceToken, deviceType)):
            return [
                "phone": phone,
                "password": password,
                "country": country,
                "latlong": latlong,
                "device_token": deviceToken,
                "device_type": deviceType
            ]
        case .otpRequest(let phone):
            return [
                "phone": phone
            ]
        case .otpMatch(let (userId, otpCode)):
            return [
                "user_id": userId,
                "otp_code": otpCode
            ]
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .register,
             .otpRequest,
             .otpMatch:
            return .post
        default:
            return .get
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .register,
             .otpRequest,
             .otpMatch:
            return .requestParameters(parameters: parameters ?? [:], encoding: .jsonEncoding)
        default:
            return .request
        }
    }
    
    var header: [String : String]? {
        switch self {
        default:
            return [
                HTTPHeaderField.contentType.rawValue: ContentType.json.rawValue
            ]
        }
    }
}
