//
//  NetworkEngine.swift
//  Dog
//
//  Created by Fábio Carvalho on 15/09/2022.
//

import Foundation

final class NetworkEngine {
    fileprivate let networkConfig: NetworkConfigs
    fileprivate let session: URLSession

    required init(networkConfig: NetworkConfigs) {
        self.networkConfig = networkConfig
        self.session = URLSession(configuration: URLSessionConfiguration.default)
    }
    
    func perform<T: Decodable>(request: NetworkRequest) async throws -> Result<T, Error> {
        let request = try! self.prepareURLRequest(for: request)
        
        // Try session data task and catch/return raw error
        do {
            // Ignoring returned URLResponse, might be needed in future implementations
            let (data, _) = try await session.data(for: request)
            
            // Try decoding JSON data response and catch error
            do {
                let decoder = JSONDecoder()
                let object = try decoder.decode(T.self, from: data)
                return .success(object)
                
            } catch let jsonError {
                // Print raw error and return proprietary type
                print(jsonError)
                return .failure(NetworkError.decodingError)
            }
            
        } catch {
            return .failure(error)
        }
    }
    
    private func prepareURLRequest(for request: NetworkRequest) throws -> URLRequest {
        // Check URL validity
        let urlString = "\(networkConfig.baseURL)/\(request.endpoint)"
        guard let url = URL(string:  urlString) else {
            throw NetworkError.badUrl
        }
        
        var urlRequest = URLRequest(url: url)
        
        // Prepare parameters
        switch request.parameters {
        
            // in request body
        case .body(let params)?:
            if let params = params as? [String: String] {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params, options: .init(rawValue: 0))

            } else {
                throw NetworkError.badInput
            }

            // as URL query parameters
        case .url(let params)?:
            if let params = params {
                let queryParams = params.map({ (element) -> URLQueryItem in
                    return URLQueryItem(name: element.key, value: element.value)
                })

                guard var components = URLComponents(string: urlString) else {
                    throw NetworkError.badInput
                }

                components.queryItems = queryParams
                urlRequest.url = components.url

            } else {
                throw NetworkError.badInput
            }
            
        case .none:
            break
        }
        
        // Set defined cache policy
        urlRequest.cachePolicy = networkConfig.cachePolicy
        
        // Add headers to request
        networkConfig.headers.forEach { urlRequest.addValue($0.value, forHTTPHeaderField: $0.key) }
        request.headers?.forEach { urlRequest.addValue($0.value, forHTTPHeaderField: $0.key) }
        
        // Set defined HTTP method
        urlRequest.httpMethod = request.method.rawValue

        return urlRequest
    }
}
