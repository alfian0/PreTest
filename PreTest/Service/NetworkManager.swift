//
//  NetworkManager.swift
//  PreTest
//
//  Created by alpiopio on 15/01/20.
//  Copyright © 2020 alpiopio. All rights reserved.
//

import Foundation

struct NetworkManager {
    static let instance = NetworkManager()
    private let router = Router<PreTestAPI>()
    
    private init() {}
    
    private func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<Bool, NetworkError> {
        switch response.statusCode {
        case 200...299: return .success(true)
        case 401...500: return .failure(NetworkError.authenticationError)
        case 501...599: return .failure(NetworkError.badRequest)
        case 600: return .failure(NetworkError.outDated)
        default: return .failure(NetworkError.failed)
        }
    }
    
    func requestObject<T: EndPointType, C: Decodable>(_ t: T, c: C.Type, completion: @escaping (Result<C, NetworkError>) -> Void) {
        router.request(t as! PreTestAPI) { (data, response, error) in
            guard let response = response as? HTTPURLResponse else { return }
            switch self.handleNetworkResponse(response) {
            case .success:
                if let data = data, error == nil {
                    do {
                        // MARK: We can use keyEncodingStrategy for simplify codable model
                        /**
                            let encoder = JSONEncoder()
                            encoder.keyEncodingStrategy = .convertToSnakeCase
                        */
                        let data = try JSONDecoder().decode(c, from: data)
                        completion(.success(data))
                    } catch let DecodingError.dataCorrupted(context) {
                        print(context)
                        completion(.failure(NetworkError.unableToDecode))
                    } catch let DecodingError.keyNotFound(key, context) {
                        print("Key '\(key)' not found:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                        completion(.failure(NetworkError.unableToDecode))
                   } catch let DecodingError.valueNotFound(value, context) {
                        print("Value '\(value)' not found:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                        completion(.failure(NetworkError.unableToDecode))
                   } catch let DecodingError.typeMismatch(type, context)  {
                        print("Type '\(type)' mismatch:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                        completion(.failure(NetworkError.unableToDecode))
                    } catch {
                        print("Url:", response.url?.absoluteString ?? "nil")
                        print("Status code:", response.statusCode)
                        completion(.failure(NetworkError.unknown))
                    }
                }
            case .failure(let err):
                switch err {
                case .authenticationError:
                    completion(.failure(NetworkError.authenticationError))
                default:
                    if let error = error as NSError?, error.domain == NSURLErrorDomain && error.code != NSURLErrorCancelled {
                        return
                    } else {
                        if let data = data, let response = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                            completion(.failure(NetworkError.softError(message: response.error.errors.first ?? err.description)))
                        }
                    }
                }
            }
        }
    }
}
