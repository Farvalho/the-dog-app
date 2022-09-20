//
//  BreedsDataSource.swift
//  Dog
//
//  Created by Fábio Carvalho on 15/09/2022.
//

import SwiftUI

protocol BreedsDataSource {
    func getImages(limit: Int, page: Int, ordered: Bool) async -> Result<[ImageEntity]?, Error>
    func searchBreeds(_ query: String) async -> Result<[BreedEntity]?, Error>
}

class DefaultBreedsDataSource: BreedsDataSource {
    @AppStorage("isOfflineMode") var isOfflineMode: Bool = false
    let networkEngine: NetworkEngine
    let localDataSource: LocalBreedsDataSource
    
    init() {
        // Initialize network configs with API key
        var networkConfigs = NetworkConfigs(baseURL: "https://api.thedogapi.com/v1")
        networkConfigs.headers = [
            "x-api-key" : "live_UmCB5Y1ZIiD6jKKmB6w7XH565wy7udYT11TsrI9hP2XvKuEjy0Nc2n1LVmz4Gnwk" // this should be retrieved from the server
        ]
        
        networkEngine = NetworkEngine(networkConfig: networkConfigs)
        localDataSource = LocalBreedsDataSource()
    }
    
    private func getOfflineImages(limit: Int, page: Int, ordered: Bool) async -> Result<[ImageEntity]?, Error> {
        return await localDataSource.getImages(limit: limit, page: page, ordered: ordered)
    }
    
    private func searchOfflineBreeds(_ query: String) async -> Result<[BreedEntity]?, Error> {
        return await localDataSource.searchBreeds(query)
    }
    
    func getImages(limit: Int, page: Int, ordered: Bool) async -> Result<[ImageEntity]?, Error> {
        // Check offline mode
        if isOfflineMode == true {
            return await getOfflineImages(limit: limit, page: page, ordered: ordered)
        }
        
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
        // Check offline mode
        if isOfflineMode == true {
            return await searchOfflineBreeds(query)
        }
        
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
