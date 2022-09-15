//
//  SearchBreedsUseCase.swift
//  Dog
//
//  Created by Fábio Carvalho on 15/09/2022.
//

import Foundation

protocol SearchBreedsUseCase {
    func perform(query: String) async -> Result<[Breed]?, Error>
}
