//
//  SearchBreedsPresenter.swift
//  Dog
//
//  Created by Fábio Carvalho on 16/09/2022.
//

import SwiftUI

class SearchBreedsPresenter: ObservableObject {
    @Published var breeds: [Breed] = []
    @Published var searchQuery: String = ""
    @Published var loadingState: LoadingState = .idle
    @Published var errorMessage: String?
    private let searchBreedsUseCase: SearchBreedsUseCase
    
    init(searchBreedsUseCase: SearchBreedsUseCase) {
        self.searchBreedsUseCase = searchBreedsUseCase
    }
    
    @MainActor
    func searchBreeds() async {
        withAnimation { loadingState = .loading }
        let result = await searchBreedsUseCase.perform(searchQuery)
        withAnimation { loadingState = .idle }
        
        // Handle result and update published vars
        switch result {
        case .success(let breeds):
            self.breeds.append(contentsOf: breeds ?? [])
            
            // Control "no results" error state
            if self.breeds.count == 0 {
                errorMessage = "We couldn't find any breeds by that name."
            } else {
                errorMessage = nil
            }
            
        case .failure(let error):
            print(error)
            self.errorMessage = error.localizedDescription
        }
    }
}
