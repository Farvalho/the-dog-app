//
//  BreedImagesView.swift
//  Dog
//
//  Created by Fábio Carvalho on 15/09/2022.
//

import SwiftUI

struct BreedImagesView: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject var presenter = BreedImagesPresenter(getBreedsUseCase: DefaultGetBreedsUseCase())
    @State var loadData: Bool = true
    
    func onAppear() {
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
                List {
                    ForEach(presenter.breeds) { breed in
                        HStack(spacing: 10) {
                            AsyncImage(url: URL(string: breed.imageLink ?? ""),
                                       transaction: Transaction(animation: .easeInOut)) { phase in
                                switch phase {
                                case .empty:
                                    // Loading placeholder view
                                    ProgressView()
                                        .frame(width: 150, height: 150)
                                        .background(colorScheme == .dark ? .black : .white)
                                        .cornerRadius(8)
                                    
                                case .failure:
                                    // Error view
                                    Rectangle()
                                        .frame(width: 150, height: 150)
                                        .background(.red)
                                        .cornerRadius(8)
                                    
                                case .success(let image):
                                    // Image has been loaded successfully
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 150, height: 150, alignment: .center)
                                        .cornerRadius(8)
                                        .transition(.scale(scale: 0.1, anchor: .center))
                                    
                                @unknown default:
                                    EmptyView()
                                }
                            } //:AsyncImage
                            
                            Text(breed.name)
                                .font(.headline)
                                .fontWeight(.semibold)
                                .multilineTextAlignment(.leading)
                                .frame(minHeight: 150)
                                .padding(.horizontal)
                            
                        } //: HStack
                        .padding(.vertical, 4)
                        
                    } //:ForEach
                } //:List
            } //:VStack
            .navigationBarTitle("The Dog App")
            .onAppear() {
                onAppear()
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: {
                        presenter.isOrdered.toggle()
                        
                    }, label: {
                        Image(systemName: presenter.isOrdered ? "a.circle.fill" : "a.circle")
                    })
                    
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
