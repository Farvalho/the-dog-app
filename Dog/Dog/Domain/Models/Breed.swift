//
//  Breed.swift
//  Dog
//
//  Created by Fábio Carvalho on 15/09/2022.
//

import Foundation

struct Breed: Identifiable {
    var id: Int
    var name: String
    var imageLink: String?
    var group: String?
    var category: String?
    var origin: String?
    var temperament: String?
}
