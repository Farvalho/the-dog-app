//
//  FakeSearchBreedsUseCase.swift
//  Dog
//
//  Created by Fábio Carvalho on 18/09/2022.
//

import Foundation

class FakeSearchBreedsUseCase: SearchBreedsUseCase {
    let breeds = [
    Breed(id: 1,
          name: "Breed Number One",
          imageLink: "https://cdn2.thedogapi.com/images/H6UCIZJsc.jpg",
          group: "Working",
          category: "Coding",
          origin: "Egypt",
          temperament: "Docile, Alert, Responsive, Dignified, Composed, Friendly, Receptive, Faithful, Courageous"),
    
    Breed(id: 2,
          name: "Breed Number Two",
          imageLink: "https://cdn2.thedogapi.com/images/H6UCIZJsc.jpg",
          group: "Working",
          category: "Coding",
          origin: "Egypt",
          temperament: "Docile, Alert, Responsive, Dignified, Composed, Friendly, Receptive, Faithful, Courageous"),
    
    Breed(id: 3,
          name: "Breed Number Three",
          imageLink: "https://cdn2.thedogapi.com/images/H6UCIZJsc.jpg",
          group: "Working",
          category: "Coding",
          origin: "Egypt",
          temperament: "Docile, Alert, Responsive, Dignified, Composed, Friendly, Receptive, Faithful, Courageous"),
    
    Breed(id: 4,
          name: "Breed Number Four",
          imageLink: "https://cdn2.thedogapi.com/images/H6UCIZJsc.jpg",
          group: "Working",
          category: "Coding",
          origin: "Egypt",
          temperament: "Docile, Alert, Responsive, Dignified, Composed, Friendly, Receptive, Faithful, Courageous"),
    
    Breed(id: 5,
          name: "Breed Number Five",
          imageLink: "https://cdn2.thedogapi.com/images/H6UCIZJsc.jpg",
          group: "Working",
          category: "Coding",
          origin: "Egypt",
          temperament: "Docile, Alert, Responsive, Dignified, Composed, Friendly, Receptive, Faithful, Courageous")
    ]

    func perform(_ query: String) async -> Result<[Breed]?, Error> {
        return .success(breeds)
    }
}
