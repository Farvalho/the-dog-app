//
//  BreedImageGridItem.swift
//  Dog
//
//  Created by Fábio Carvalho on 16/09/2022.
//

import SwiftUI

struct BreedImageGridItem: View {
    @Environment(\.colorScheme) var colorScheme
    var breed: Breed
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
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
                .multilineTextAlignment(.center)
                .frame(minHeight: 40)
                .frame(maxWidth: 150)
            
        } //:VStack
    }
}

struct BreedImageGridItem_Previews: PreviewProvider {
    static var previews: some View {
        BreedImageGridItem(breed: BreedImagesPresenter(getBreedsUseCase: FakeGetBreedsUseCase()).breeds[0])
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
