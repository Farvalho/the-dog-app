//
//  BreedEntity.swift
//  Dog
//
//  Created by Fábio Carvalho on 15/09/2022.
//

import Foundation

struct BreedEntity: Decodable {
    var id: Int
    var name: String
    var group: String
    var origin: String
    var temperament: String
    
    enum CodingKeys: String, CodingKey {
        case group = "breed_group"
        case id, name, origin, temperament
    }
}
