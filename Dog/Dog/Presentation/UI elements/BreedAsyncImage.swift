//
//  BreedAsyncImage.swift
//  Dog
//
//  Created by Fábio Carvalho on 17/09/2022.
//

import SwiftUI

struct BreedAsyncImage: View {
    var imageLink: String?
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        AsyncImage(url: URL(string: imageLink ?? ""),
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
    }
}

struct BreedAsyncImage_Previews: PreviewProvider {
    static var previews: some View {
        BreedAsyncImage()
    }
}
