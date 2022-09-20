//
//  BreedImageGridItem.swift
//  Dog
//
//  Created by Fábio Carvalho on 16/09/2022.
//

import SwiftUI

struct BreedImageGridItem: View {
    var breed: Breed
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            BreedAsyncImage(imageLink: breed.imageLink)
            
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
