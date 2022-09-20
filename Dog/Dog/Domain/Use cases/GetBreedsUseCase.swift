//
//  GetBreedsUseCase.swift
//  Dog
//
//  Created by Fábio Carvalho on 15/09/2022.
//

import Foundation

protocol GetBreedsUseCase {
    func perform(limit: Int, page: Int, ordered: Bool) async -> Result<[Breed]?, Error>
}

class DefaultGetBreedsUseCase: GetBreedsUseCase {
    private let repo: BreedsRepository
    
    init() {
        self.repo = DefaultBreedsRepository()
    }

    init(repository: BreedsRepository) {
        self.repo = repository
    }

    func perform(limit: Int, page: Int, ordered: Bool) async -> Result<[Breed]?, Error> {
        return await repo.getBreeds(limit: limit, page: page, ordered: ordered)
    }
}
