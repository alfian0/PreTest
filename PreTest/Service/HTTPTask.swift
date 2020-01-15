//
//  HTTPTask.swift
//  PreTest
//
//  Created by alpiopio on 15/01/20.
//  Copyright © 2020 alpiopio. All rights reserved.
//

import Foundation

enum HTTPTask {
    case request
    case requestParameters(parameters: [String: Any], encoding: ParameterEncoding)
    case requestCompositeParameters(bodyParameters: [String: Any], bodyEncoding: ParameterEncoding, urlParameters: [String: Any])
    case uploadMultipart(multipartFormData: [MultipartFormData])
    case uploadCompositeMultipart(multipartFormData: [MultipartFormData], urlParameters: [String:Any])
}
