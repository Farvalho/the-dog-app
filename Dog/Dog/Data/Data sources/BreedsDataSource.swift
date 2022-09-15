//
//  BreedsDataSource.swift
//  Dog
//
//  Created by Fábio Carvalho on 15/09/2022.
//

import Foundation

protocol BreedsDataSource {
    func getImages(limit: Int, page: Int, ordered: Bool) async -> Result<[ImageEntity], Error>
    func searchBreeds(_ query: String) async -> Result<[BreedEntity]?, Error>
}
