//
//  SearchBreedsUseCase.swift
//  Dog
//
//  Created by Fábio Carvalho on 15/09/2022.
//

import Foundation

protocol SearchBreedsUseCase {
    func perform(_ query: String) async -> Result<[Breed]?, Error>
}

class DefaultSearchBreedsUseCase: SearchBreedsUseCase {
    private let repo: BreedsRepository
    
    init() {
        self.repo = DefaultBreedsRepository()
    }

    init(repository: BreedsRepository) {
        self.repo = repository
    }
    
    func perform(_ query: String) async -> Result<[Breed]?, Error> {
        return await repo.searchBreeds(query)
    }
}
