//
//  NetworkError.swift
//  PreTest
//
//  Created by alpiopio on 15/01/20.
//  Copyright © 2020 alpiopio. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case authenticationError
    case badRequest
    case outDated
    case failed
    case noData
    case unableToDecode
    case parameterNil
    case encodingFailed
    case missingURL
    case unknown
    case softError(message: String)
    
    var description: String {
        switch self {
        case .authenticationError:
            return "You need to be authenticated first"
        case .badRequest:
            return "Bad Request"
        case .outDated:
            return "The url you requested out outdated"
        case .failed:
            return "Network request failed"
        case .noData:
            return "Response returned with no data to decode"
        case .unableToDecode:
            return "We could not decode the response"
        case .parameterNil:
            return "Parameters were nil"
        case .encodingFailed:
            return "Parameter encoding failed"
        case .missingURL:
            return "URL is nil"
        case .unknown:
            return "Unknown error"
        case .softError(let message):
            return message
        }
    }
}
