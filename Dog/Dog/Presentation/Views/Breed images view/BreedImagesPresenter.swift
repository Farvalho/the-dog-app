//
//  BreedImagesPresenter.swift
//  Dog
//
//  Created by Fábio Carvalho on 16/09/2022.
//

import SwiftUI

class BreedImagesPresenter: ObservableObject {
    @AppStorage("isOfflineMode") var isOfflineMode: Bool = false
    @Published var breeds: [Breed] = []
    @Published var isGrid: Bool = false
    @Published var isOrdered: Bool = false
    @Published var hasMorePages: Bool = false
    @Published var loadingState: LoadingState = .idle
    @Published var errorMessage: String?
    @Published var isOfflineAlertPresenting = false
    private let getBreedsUseCase: GetBreedsUseCase
    private let pageLimit: Int = 5 // arbitrary value, this could be API output
    private let limit: Int = 10
    private var askedForOffline = false
    private var page: Int = 0 {
        didSet {
            hasMorePages = !(page == pageLimit)
        }
    }
    
    init(getBreedsUseCase: GetBreedsUseCase) {
        self.getBreedsUseCase = getBreedsUseCase
    }
    
    @MainActor
    func getBreeds() async {
        // Perform the use case wrapped in loading start/end if page == 0
        // This is because for additional pages the loading view is embedded in the list/grid
        firstPageLoading(true)
        let result = await getBreedsUseCase.perform(limit: limit, page: page, ordered: isOrdered)
        firstPageLoading(false)
        
        // Handle result and update published vars
        switch result {
        case .success(let breeds):
            page += 1
            self.breeds.append(contentsOf: breeds ?? [])
            
            // Control "no results" error state
            if self.breeds.count == 0 {
                errorMessage = "There are no dogs here."
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
    
    @MainActor
    func getOrderedBreeds() async {
        // Reset result array and page control var
        breeds = []
        page = 0
        
        await getBreeds()
    }
    
    func firstPageLoading(_ isOn: Bool) {
        if page == 0 {
            withAnimation {
                loadingState = isOn ? .loading : .idle
            }
        }
    }
}
