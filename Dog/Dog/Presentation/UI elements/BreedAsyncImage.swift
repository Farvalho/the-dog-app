//
//  BreedAsyncImage.swift
//  Dog
//
//  Created by Fábio Carvalho on 17/09/2022.
//

import SwiftUI

struct BreedAsyncImage: View {
    var imageLink: String?
    var dimensions: (width: CGFloat, height: CGFloat) = (width: 150, height: 150)
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        AsyncImage(url: URL(string: imageLink ?? ""),
                   transaction: Transaction(animation: .easeInOut)) { phase in
            switch phase {
            case .empty:
                // Loading placeholder view
                ProgressView()
                    .frame(width: dimensions.width, height: dimensions.height)
                    .background(colorScheme == .dark ? .black : .white)
                    .cornerRadius(8)
                
            case .failure:
                // Error view
                Image(systemName: "pawprint")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150, alignment: .center)
                    .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
                
            case .success(let image):
                // Image has been loaded successfully
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: dimensions.width, height: dimensions.height, alignment: .center)
                    .cornerRadius(8)
                    .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
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
