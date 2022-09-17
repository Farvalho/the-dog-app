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
                case .idle:
                    // Check if presentation mode is grid or list
                    if presenter.isGrid == true {
                        BreedImageGrid(items: $presenter.breeds,
                                       loadsMore: $presenter.hasMorePages) {
                            Task {
                                await presenter.getBreeds()
                            }
                        }
                        
                    } else {
                        BreedImageList(items: $presenter.breeds,
                                       loadsMore: $presenter.hasMorePages) {
                            Task {
                                await presenter.getBreeds()
                            }
                        }
                    }
                    
                case .loading:
                    LoadingView()
                }
            } //:VStack
            .navigationBarTitle("The Dog App")
            .onAppear {
                onAppear()
            }
            .onChange(of: presenter.isOrdered, perform: { _ in
                Task {
                    await presenter.getOrderedBreeds()
                }
            })
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
    }
}

struct BreedImagesView_Previews: PreviewProvider {
    static var previews: some View {
        BreedImagesView(presenter: BreedImagesPresenter(getBreedsUseCase: FakeGetBreedsUseCase()))
    }
}
