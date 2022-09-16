//
//  BreedImagesView.swift
//  Dog
//
//  Created by Fábio Carvalho on 15/09/2022.
//

import SwiftUI

struct BreedImagesView: View {
    @StateObject var presenter = BreedImagesPresenter(getBreedsUseCase: DefaultGetBreedsUseCase())
    @State var loadData: Bool = true
    
    // LazyVGrid column array
    let vGridColumns = [
        GridItem(.adaptive(minimum: 150, maximum: 300), spacing: 20, alignment: .center),
        GridItem(.adaptive(minimum: 150, maximum: 300), spacing: 20, alignment: .center)
    ]
    
    func onAppear() {
        // Helper conditional to prevent onAppear being called twice (https://openradar.appspot.com/FB8820127)
        if loadData == true {
            loadData.toggle()
            
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
                        ScrollView(.vertical, showsIndicators: false) {
                            LazyVGrid(columns: vGridColumns) {
                                ForEach(presenter.breeds) { breed in
                                    BreedImageGridItem(breed: breed)
                                        .padding(.bottom, 10)
                                    
                                } //:ForEach
                            } //:LazyVGrid
                        } //:ScrollView
                        
                    } else {
                        List {
                            ForEach(presenter.breeds) { breed in
                                BreedImageListRow(breed: breed)
                                    .padding(.vertical, 4)
                                
                            } //:ForEach
                        } //:List
                    }
                    
                case .loading:
                    LoadingView()
                }
            } //:VStack
            .navigationBarTitle("The Dog App")
            .onAppear() {
                onAppear()
            }
            .onChange(of: presenter.isOrdered, perform: { newValue in
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
