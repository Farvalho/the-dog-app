//
//  BreedsRepository.swift
//  Dog
//
//  Created by Fábio Carvalho on 15/09/2022.
//

import Foundation

protocol BreedsRepository {
    func getBreeds(limit: Int, page: Int, ordered: Bool) async -> Result<[Breed]?, Error>
    func searchBreeds(_ query: String) async -> Result<[Breed]?, Error>
}

class DefaultBreedsRepository: BreedsRepository {
    private let dataSource: BreedsDataSource
        
    init() {
        self.dataSource = DefaultBreedsDataSource()
    }
    
    init(dataSource: BreedsDataSource) {
        self.dataSource = dataSource
    }
    
    func mapImageToBreed(_ image: ImageEntity) -> Breed {
        let imageBreed = image.breeds[0]
        
        return Breed(id: imageBreed.id,
                     name: imageBreed.name,
                     imageLink: image.url,
                     group: imageBreed.group,
                     category: image.categories?[0].name,
                     origin: imageBreed.origin,
                     temperament: imageBreed.temperament)
    }
    
    func mapBreedEntityToModel(_ entity: BreedEntity) -> Breed {
        return Breed(id: entity.id,
                     name: entity.name,
                     group: entity.group,
                     origin: entity.origin,
                     temperament: entity.temperament)
    }
    
    func getBreeds(limit: Int, page: Int, ordered: Bool) async -> Result<[Breed]?, Error> {
        let data = await dataSource.getImages(limit: limit, page: page, ordered: ordered)
        switch data {
        case .success(let response):
            // Initialize result array and map each image entity to breed model
            var result: [Breed] = []
            for image in response ?? [] {
                let breed = mapImageToBreed(image)
                result.append(breed)
            }
            
            return .success(result)
            
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func searchBreeds(_ query: String) async -> Result<[Breed]?, Error> {
        let data = await dataSource.searchBreeds(query)
        switch data {
        case .success(let response):
            // Initialize result array and map each breed entity to breed model
            var result: [Breed] = []
            for entity in response ?? [] {
                let breed = mapBreedEntityToModel(entity)
                result.append(breed)
            }
            
            return .success(result)
            
        case .failure(let error):
            return .failure(error)
        }
    }
    
}
