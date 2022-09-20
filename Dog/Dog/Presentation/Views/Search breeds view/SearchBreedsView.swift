//
//  SearchBreedsView.swift
//  Dog
//
//  Created by Fábio Carvalho on 15/09/2022.
//

import SwiftUI

struct SearchBreedsView: View {
    @StateObject var presenter = SearchBreedsPresenter(searchBreedsUseCase: DefaultSearchBreedsUseCase())
    
    var body: some View {
        NavigationView {
            VStack {
                // Check presenter loading state
                switch presenter.loadingState {
                case .loading:
                    LoadingView()
                    
                case .idle:
                    // Check for error state and present error view
                    if presenter.errorMessage != nil {
                        Text(presenter.errorMessage!)
                            .padding(.top, 50)
                        Spacer()
                        
                    } else {
                        // Placeholder if empty list
                        if presenter.breeds.count == 0 {
                            Text("This is where results will show!")
                                .font(.caption)
                                .foregroundColor(.gray)
                            
                        } else {
                            List {
                                ForEach(presenter.breeds) { item in
                                    NavigationLink(destination: BreedDetailsView(breed: item)) {
                                        SearchBreedsListRow(breed: item)
                                            .padding(.vertical, 4)
                                    } //:NavigationLink
                                } //:ForEach
                            } //:List
                        }
                    }
                }
            } //:VStack
            .navigationTitle("The Dog App")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $presenter.searchQuery, placement: .navigationBarDrawer, prompt: "Search a breed by its name...")
            .onSubmit(of: .search) {
                Task {
                    await presenter.searchBreeds()
                }
            }
            // Offline mode alert
            .alert("You appear to be offline", isPresented: $presenter.isOfflineAlertPresenting, actions: {
                Button("Cancel") {
                    // Try to load the data without offline mode
                    presenter.isOfflineAlertPresenting.toggle()
                    presenter.isOfflineMode = false
                    
                    Task {
                        await presenter.searchBreeds()
                    }
                }
                
                Button("Offline mode") {
                    // Initiate offline mode and load data
                    presenter.isOfflineAlertPresenting.toggle()
                    presenter.isOfflineMode = true
                    
                    Task {
                        await presenter.searchBreeds()
                    }
                }
            }, message: {
                Text("Would you like to continue with any available outdated data?")
            })
            
        } //:NavigationView
    }
}

struct SearchBreedsView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBreedsView(presenter: SearchBreedsPresenter(searchBreedsUseCase: FakeSearchBreedsUseCase()))
    }
}
