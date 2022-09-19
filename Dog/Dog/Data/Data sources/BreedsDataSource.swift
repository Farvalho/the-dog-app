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
    let localDataSource: LocalBreedsDataSource
    
    init() {
        // Initialize network configs with API key
        var networkConfigs = NetworkConfigs(baseURL: "https://api.thedogapi.com/v1")
        networkConfigs.headers = [
            "x-api-key" : "API KEY HERE"
        ]
        
        networkEngine = NetworkEngine(networkConfig: networkConfigs)
        localDataSource = LocalBreedsDataSource()
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
        
        // Perform request and save to local data source
        let result = await networkEngine.perform(request: request) as Result<[ImageEntity]?, Error>
        switch result {
        case .success(let images):
            if images != nil {
                _ = localDataSource.saveImages(images!) // not handling success/failure
            }
            
        case .failure(_):
            break
        }
        
        // Then return the result
        return result
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
        
        // Perform request and save to local data source
        let result = await networkEngine.perform(request: request) as Result<[BreedEntity]?, Error>
        switch result {
        case .success(let breeds):
            if breeds != nil {
                _ = localDataSource.saveBreeds(breeds!) // not handling success/failure
            }
            
        case .failure(_):
            break
        }
        
        // Then return the result
        return result
    }
    
}
