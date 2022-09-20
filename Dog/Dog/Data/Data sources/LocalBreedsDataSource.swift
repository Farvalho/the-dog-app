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
        // Fetch image entity relationship data
        let categoryEntities = try! wrapper.getData(entityName: "Category", predicate: NSPredicate(format: "image.id = %@", coreData.id! as CVarArg)) as! [CategoryCoreDataEntity]
        let breedEntities = try! wrapper.getData(entityName: "Breed", predicate: NSPredicate(format: "image.id = %@", coreData.id! as CVarArg)) as! [BreedCoreDataEntity]
        
        // Map categories as optional
        var categories: [CategoryEntity]?
        if categoryEntities.count > 0 {
            categories = categoryEntities.map({ entity in
                mapCategoryEntity(entity)
            })
        }
        
        // Map breeds
        let breeds = breedEntities.map({ entity in
            mapBreedEntity(entity)
        })
        
        return ImageEntity(categories: categories, breeds: breeds, url: coreData.url!)
    }
    
    private func mapCategoryEntity(_ coreData: CategoryCoreDataEntity) -> CategoryEntity {
        return CategoryEntity(name: coreData.name ?? "")
    }
    
    private func mapBreedEntity(_ coreData: BreedCoreDataEntity) -> BreedEntity {
        return BreedEntity(id: Int(coreData.id), name: coreData.name!, group: coreData.group, origin: coreData.origin, temperament: coreData.temperament)
    }
    
    func saveImages(_ images: [ImageEntity]) -> Result<Bool, Error> {
        do {
            var newEntries: [ImageCoreDataEntity] = []
            
            // Iterate images and create a core data entity
            for image in images {
                let newEntry = ImageCoreDataEntity(context: wrapper.getContext())
                newEntry.id = UUID()
                newEntry.url = image.url
                
                // Create category entities if available
                if let _ = image.categories {
                    for category in image.categories! {
                        let newCategory = CategoryCoreDataEntity(context: wrapper.getContext())
                        newCategory.name = category.name
                        newCategory.image = newEntry
                    }
                }
                
                // Create breed entities
                for breed in image.breeds {
                    let newBreed = BreedCoreDataEntity(context: wrapper.getContext())
                    newBreed.id = Int64(breed.id)
                    newBreed.name = breed.name
                    newBreed.group = breed.group
                    newBreed.origin = breed.origin
                    newBreed.temperament = breed.temperament
                    newBreed.image = newEntry
                }
                
                // Append to final array and save
                newEntries.append(newEntry)
            }
            
            try wrapper.saveEntities(entities: newEntries)
            return .success(true)
            
        } catch {
            return .failure(error)
        }
    }
    
    func getImages(limit: Int, page: Int, ordered: Bool) async -> Result<[ImageEntity]?, Error> {
        do {
            let data = try wrapper.getData(entityName: "Image", limit: limit) as! [ImageCoreDataEntity]
            let result = data.map({ entity in
                mapImageEntity(entity)
            })
            
            return ordered ? .success(result.sorted(by: { $0.breeds[0].name < $1.breeds[0].name })) : .success(result)
            
        } catch {
            return .failure(error)
        }
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
        do {
            let data = try wrapper.getData(entityName: "Breed", predicate: NSPredicate(format: "name contains[c] %@", query)) as! [BreedCoreDataEntity]
            return .success(data.map({ entity in
                mapBreedEntity(entity)
            }))
            
        } catch {
            return .failure(error)
        }
    }
    
}
