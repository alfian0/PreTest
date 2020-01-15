//
//  EndPointType.swift
//  PreTest
//
//  Created by alpiopio on 15/01/20.
//  Copyright © 2020 alpiopio. All rights reserved.
//

import Foundation

protocol EndPointType {
    var baseURL: URL { get }
    var path: String { get }
    var parameters: [String:Any]? { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
    var header: [String:String]? { get }
}
