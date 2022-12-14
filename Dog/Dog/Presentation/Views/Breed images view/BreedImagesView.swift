//
//  BreedImagesView.swift
//  Dog
//
//  Created by Fábio Carvalho on 15/09/2022.
//

import SwiftUI

struct BreedImagesView: View {
    @StateObject var presenter = BreedImagesPresenter(getBreedsUseCase: DefaultGetBreedsUseCase())
    @State var initialLoad: Bool = true
    
    func onAppear() {
        // Helper conditional to prevent onAppear being called twice when using tab bar (https://openradar.appspot.com/FB8820127)
        if initialLoad == true {
            initialLoad.toggle()
            Task {
                await presenter.getBreeds()
            }
        }
    }
    
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
                            .padding(.horizontal, 20)
                            .multilineTextAlignment(.center)
                        Spacer()
                        
                    } else {
                        // Check if presentation mode is grid or list
                        if presenter.isGrid == true {
                            BreedImageGrid(items: $presenter.breeds,
                                           loadsMore: $presenter.hasMorePages) {
                                Task {
                                    await presenter.getBreeds()
                                }
                            } //: BreedImageGrid
                            
                        } else {
                            BreedImageList(items: $presenter.breeds,
                                           loadsMore: $presenter.hasMorePages) {
                                Task {
                                    await presenter.getBreeds()
                                }
                            } //: BreedImageList
                        }
                    }
                }
                
            } //:VStack
            .navigationBarTitle("The Dog App")
            .onAppear {
                onAppear()
            }
            // List ordering toggle observer
            .onChange(of: presenter.isOrdered, perform: { _ in
                Task {
                    await presenter.getOrderedBreeds()
                }
            })
            // Offline mode alert
            .alert("You appear to be offline", isPresented: $presenter.isOfflineAlertPresenting, actions: {
                Button("Cancel") {
                    // Try to load the data without offline mode
                    presenter.isOfflineAlertPresenting.toggle()
                    presenter.isOfflineMode = false
                    
                    Task {
                        await presenter.getBreeds()
                    }
                }
                
                Button("Offline mode") {
                    // Initiate offline mode and load data
                    presenter.isOfflineAlertPresenting.toggle()
                    presenter.isOfflineMode = true
                    
                    Task {
                        await presenter.getBreeds()
                    }
                }
            }, message: {
                Text("Would you like to continue with any available outdated data?")
            })
            // Navigation bar toolbar
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    // Order ascending button
                    Button(action: {
                        presenter.isOrdered.toggle()
                        
                    }, label: {
                        Image(systemName: presenter.isOrdered ? "a.circle.fill" : "a.circle")
                    })
                    
                    // Toggle list/grid button
                    Button(action: {
                        presenter.isGrid.toggle()
                        
                    }, label: {
                        Image(systemName: presenter.isGrid ? "list.bullet" : "square.grid.2x2")
                    })
                } //:ToolbarItemGroup
            } //:toolbar
        } //:NavigationView
        .navigationViewStyle(.stack)
    }
}

struct BreedImagesView_Previews: PreviewProvider {
    static var previews: some View {
        BreedImagesView(presenter: BreedImagesPresenter(getBreedsUseCase: FakeGetBreedsUseCase()))
    }
}
