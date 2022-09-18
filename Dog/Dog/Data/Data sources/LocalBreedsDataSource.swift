//
//  LocalBreedsDataSource.swift
//  Dog
//
//  Created by Fábio Carvalho on 18/09/2022.
//

import Foundation

class LocalBreedsDataSource: BreedsDataSource {
    let wrapper: CoreDataWrapper
    
    init() {
        self.wrapper = PersistenceEngine()
    }
    
    init(wrapper: CoreDataWrapper){
        self.wrapper = wrapper
    }
    
    private func mapImageEntity(_ coreData: ImageCoreDataEntity) -> ImageEntity {
        let categories = coreData.categories?.allObjects as? [CategoryEntity]
        let breeds = coreData.breeds?.allObjects as? [BreedEntity] ?? []
        
        return ImageEntity(categories: categories, breeds: breeds, url: coreData.url!)
    }
    
    private func mapBreedEntity(_ coreData: BreedCoreDataEntity) -> BreedEntity {
        return BreedEntity(id: Int(coreData.id), name: coreData.name!, group: coreData.group, origin: coreData.origin, temperament: coreData.temperament)
    }
    
    func saveImages(_ images: [ImageEntity]) -> Result<Bool, Error> {
        do {
            var newEntries: [ImageCoreDataEntity] = []
            for image in images {
                let newEntry = ImageCoreDataEntity(context: wrapper.getContext())
                newEntry.url = image.url
                newEntry.categories?.addingObjects(from: image.categories ?? [])
                newEntry.breeds?.addingObjects(from: image.breeds)
                newEntries.append(newEntry)
            }
            
            try wrapper.saveEntities(entities: newEntries)
            
            return .success(true)
            
        } catch {
            return .failure(error)
        }
    }
    
    func getImages(limit: Int, page: Int, ordered: Bool) async -> Result<[ImageEntity]?, Error> {
        return .success([])
    }
    
    func saveBreeds(_ breeds: [BreedEntity])  -> Result<Bool, Error> {
        do {
            var newEntries: [BreedCoreDataEntity] = []
            for breed in breeds {
                let newEntry = BreedCoreDataEntity(context: wrapper.getContext())
                newEntry.id = Int64(breed.id)
                newEntry.name = breed.name
                newEntry.group = breed.group
                newEntry.origin = breed.origin
                newEntry.temperament = breed.temperament
                newEntries.append(newEntry)
            }
            
            try wrapper.saveEntities(entities: newEntries)
            
            return .success(true)
            
        } catch {
            return .failure(error)
        }
    }
    
    func searchBreeds(_ query: String) async -> Result<[BreedEntity]?, Error> {
        return .success([])
    }
    
}
