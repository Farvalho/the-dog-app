//
//  BreedsDataSource.swift
//  Dog
//
//  Created by Fábio Carvalho on 15/09/2022.
//

import Foundation

protocol BreedsDataSource {
    func getImages(limit: Int, page: Int, ordered: Bool) async -> Result<[ImageEntity]?, Error>
    func searchBreeds(_ query: String) async -> Result<[BreedEntity]?, Error>
}

class DefaultBreedsDataSource: BreedsDataSource {
    let networkEngine: NetworkEngine
    
    init() {
        // Initialize network configs with API key
        var networkConfigs = NetworkConfigs(baseURL: "https://api.thedogapi.com/v1")
        networkConfigs.headers = [
            "x-api-key" : "API KEY HERE"
        ]
        
        networkEngine = NetworkEngine(networkConfig: networkConfigs)
    }
    
    func getImages(limit: Int, page: Int, ordered: Bool) async -> Result<[ImageEntity]?, Error> {
        // Prepare parameters for request
        var parameters = ["has_breeds" : "1", "limit" : String(limit),  "page" : String(page)]
        
        // Add ascending order parameter
        if ordered {
            parameters["order"] = "ASC"
        }
        
        // Prepare request
        let request = NetworkRequest(
            method: .get,
            endpoint: "images/search",
            parameters: .url(parameters)
        )
        
        // Perform request and immediately return the result
        return try! await networkEngine.perform(request: request) as Result<[ImageEntity]?, Error>
    }
    
    func searchBreeds(_ query: String) async -> Result<[BreedEntity]?, Error> {
        // Prepare parameters for request
        let parameters = ["q" : query]
        
        // Prepare request
        let request = NetworkRequest(
            method: .get,
            endpoint: "breeds/search",
            parameters: .url(parameters)
        )
        
        // Perform request and immediately return the result
        return try! await networkEngine.perform(request: request) as Result<[BreedEntity]?, Error>
    }
    
}
