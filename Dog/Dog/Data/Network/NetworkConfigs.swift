//
//  NetworkConfigs.swift
//  Dog
//
//  Created by Fábio Carvalho on 15/09/2022.
//

import Foundation

struct NetworkConfigs {
    let baseURL: String
    var headers: [String: String] = [:]
    var cachePolicy: URLRequest.CachePolicy

    init(baseURL: String) {
        self.baseURL = baseURL
        self.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
    }
}
