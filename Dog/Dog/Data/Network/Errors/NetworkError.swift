//
//  NetworkError.swift
//  Dog
//
//  Created by Fábio Carvalho on 15/09/2022.
//

import Foundation

enum NetworkError: Error {
    case badUrl
    case badInput
    case badOutput
    case decodingError
    case networkError
}
