//
//  GetBreedsUseCase.swift
//  Dog
//
//  Created by Fábio Carvalho on 15/09/2022.
//

import Foundation

protocol GetBreedsUseCase {
    func perform(limit: Int, page: Int) async -> Result<[Breed], Error>
}
