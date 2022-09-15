//
//  BreedsRepository.swift
//  Dog
//
//  Created by Fábio Carvalho on 15/09/2022.
//

import Foundation

protocol BreedsRepository {
    func getBreeds(limit: Int, page: Int, ordered: Bool) async -> Result<[Breed], Error>
    func searchBreeds(_ query: String) async -> Result<[Breed]?, Error>
}
