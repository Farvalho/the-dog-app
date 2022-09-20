//
//  ImageEntity.swift
//  Dog
//
//  Created by Fábio Carvalho on 15/09/2022.
//

import Foundation

struct ImageEntity: Decodable {
    var categories: [CategoryEntity]?
    var breeds: [BreedEntity]
    var url: String
}
