//
//  BreedImagesPresenter.swift
//  Dog
//
//  Created by Fábio Carvalho on 16/09/2022.
//

import SwiftUI

class BreedImagesPresenter: ObservableObject {
    @Published var breeds: [Breed] = []
    @Published var isGrid: Bool = false
    @Published var isOrdered: Bool = false
    @Published var loadingState: LoadingState = .idle
    private var page: Int = -1
    private let limit: Int = 5
    private let getBreedsUseCase: GetBreedsUseCase
    
    init(getBreedsUseCase: GetBreedsUseCase) {
        self.getBreedsUseCase = getBreedsUseCase
    }
    
    @MainActor
    func getBreeds() async {
        page += 1
        
        // Perform the use case wrapped in loading start/end
        withAnimation { loadingState = .loading }
        let result = await getBreedsUseCase.perform(limit: limit, page: page, ordered: isOrdered)
        withAnimation { loadingState = .idle }
        
        switch result {
        case .success(let breeds):
            self.breeds.append(contentsOf: breeds ?? [])
            
        case .failure(let error):
            print(error)
        }
    }
    
    @MainActor
    func getOrderedBreeds() async {
        // Reset result array and page control var
        breeds = []
        page = -1
        
        await getBreeds()
    }
}
