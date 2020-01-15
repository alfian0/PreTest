//
//  NetworkRouter.swift
//  PreTest
//
//  Created by alpiopio on 15/01/20.
//  Copyright © 2020 alpiopio. All rights reserved.
//

import Foundation

typealias NetworkRouterCompletion = (_ data: Data?,_ response: URLResponse?,_ error: Error?)->()

protocol NetworkRouter {
    associatedtype EndPoint: EndPointType
    func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion)
    func cancel()
}

class Router<EndPoint: EndPointType>: NetworkRouter {
    private var task: URLSessionTask?
    
    func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion) {
        let session = URLSession.shared
        do {
            let request = try self.buildRequest(from: route)
            task = session.dataTask(with: request, completionHandler: { (data, response, error) in
                completion(data, response, error)
                if let response = (response as? HTTPURLResponse) {
                    NetworkLogger.log(response: response)
                }
            })
        } catch {
            completion(nil, nil, error)
        }
        self.task?.resume()
    }
    
    func cancel() {
        task?.cancel()
    }
    
    fileprivate func buildRequest(from route: EndPoint) throws -> URLRequest {
        var request = URLRequest(url: route.baseURL.appendingPathComponent(route.path),
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 10.0)
        request.httpMethod = route.httpMethod.rawValue
        do {
            self.addAdditionalHeaders(route.header, request: &request)
            switch route.task {
            case .request:
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            case .requestParameters(let (parameters, encoding)):
                try self.configureParameters(bodyParameters: parameters, bodyEncoding: encoding, urlParameters: nil, request: &request)
            case .requestCompositeParameters(let (bodyParameters, bodyEncoding, urlParameters)):
                try self.configureParameters(bodyParameters: bodyParameters, bodyEncoding: bodyEncoding, urlParameters: urlParameters, request: &request)
            case .uploadMultipart(let multipartFormData):
                try self.configureParameters(multipartFormData: multipartFormData, urlParameters: nil, request: &request)
            case .uploadCompositeMultipart(let (multipartFormData, urlParameters)):
                try self.configureParameters(multipartFormData: multipartFormData, urlParameters: urlParameters, request: &request)
            }
            NetworkLogger.log(request: request)
            return request
        } catch {
            throw error
        }
    }
    
    fileprivate func configureParameters(multipartFormData: [MultipartFormData],
                                         urlParameters: [String:Any]?,
                                         request: inout URLRequest) throws {
        let boundary = "Boundary-\(UUID().uuidString)"
        var httpBody = Data()
        let linebreak = "\r\n"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        do {
            try ParameterEncoding.urlEncoding.encode(urlRequest: &request, bodyParameters: nil, urlParameters: urlParameters)
            for media in multipartFormData {
                httpBody.append(Data("--\(boundary + linebreak)".utf8))
                if let filename = media.filename {
                    httpBody.append(Data("Content-Disposition: form-data; name=\"\(media.name)\"; filename=\"\(filename)\"\(linebreak)".utf8))
                } else {
                    httpBody.append(Data("Content-Disposition: form-data; name=\"\(media.name)\"\(linebreak + linebreak)".utf8))
                }
                if let mimeType = media.mimeType {
                    httpBody.append(Data("Content-Type: \(mimeType + linebreak + linebreak)".utf8))
                }
                switch media.provider {
                case .data(let data):
                    httpBody.append(data)
                    httpBody.append(Data(linebreak.utf8))
                case .text(let text):
                    httpBody.append(Data("\(text + linebreak)".utf8))
                case .number(let int):
                    httpBody.append(Data("\(String(int) + linebreak)".utf8))
                }
            }
            httpBody.append(Data("--\(boundary)--\(linebreak)".utf8))
            request.httpBody = httpBody
        } catch {
            throw error
        }
    }
    
    fileprivate func configureParameters(bodyParameters: [String:Any]?,
                                         bodyEncoding: ParameterEncoding,
                                         urlParameters: [String:Any]?,
                                         request: inout URLRequest) throws {
        do {
            try bodyEncoding.encode(urlRequest: &request,
                                    bodyParameters: bodyParameters, urlParameters: urlParameters)
        } catch {
            throw error
        }
    }
    
    fileprivate func addAdditionalHeaders(_ additionalHeaders: [String:String]?, request: inout URLRequest) {
        guard let headers = additionalHeaders else { return }
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
}
