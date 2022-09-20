//
//  BreedImageListRow.swift
//  Dog
//
//  Created by Fábio Carvalho on 16/09/2022.
//

import SwiftUI

struct BreedImageListRow: View {
    var breed: Breed
    
    var body: some View {
        HStack(spacing: 10) {
            BreedAsyncImage(imageLink: breed.imageLink)
            
            Text(breed.name)
                .font(.headline)
                .fontWeight(.semibold)
                .multilineTextAlignment(.leading)
                .frame(minHeight: 150)
                .padding(.horizontal)
            
        } //:HStack
    }
}

struct BreedImageListRow_Previews: PreviewProvider {
    static var previews: some View {
        BreedImageListRow(breed: BreedImagesPresenter(getBreedsUseCase: FakeGetBreedsUseCase()).breeds[0])
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
