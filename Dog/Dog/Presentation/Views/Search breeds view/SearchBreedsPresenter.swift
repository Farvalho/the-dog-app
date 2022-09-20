//
//  SearchBreedsPresenter.swift
//  Dog
//
//  Created by Fábio Carvalho on 16/09/2022.
//

import SwiftUI

class SearchBreedsPresenter: ObservableObject {
    @AppStorage("isOfflineMode") var isOfflineMode: Bool = false
    @Published var breeds: [Breed] = []
    @Published var searchQuery: String = ""
    @Published var loadingState: LoadingState = .idle
    @Published var errorMessage: String?
    @Published var isOfflineAlertPresenting = false
    private let searchBreedsUseCase: SearchBreedsUseCase
    private var askedForOffline = false
    
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
            self.breeds = breeds ?? []
            
            // Control "no results" error state
            if self.breeds.count == 0 {
                errorMessage = "We couldn't find any breeds by that name."
            } else {
                errorMessage = nil
            }
            
        case .failure(let error):
            // Check for no connection error
            if let networkError = error as? NetworkError, networkError == .connectionError {
                // Only ask for offline mode once
                if !askedForOffline {
                    askedForOffline = true
                    isOfflineAlertPresenting = true
                    return
                }
                
                self.errorMessage = "Couldn't load your data. Please check your internet connection."
                return
            }
            
            self.errorMessage = error.localizedDescription
        }
    }
}
