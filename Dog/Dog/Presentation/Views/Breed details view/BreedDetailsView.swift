//
//  BreedDetailsView.swift
//  Dog
//
//  Created by Fábio Carvalho on 17/09/2022.
//

import SwiftUI

struct BreedDetailsView: View {
    var breed: Breed
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .center, spacing: 10) {
                VStack(alignment: .center, spacing: 10) {
                    if breed.imageLink != nil {
                        BreedAsyncImage(imageLink: breed.imageLink)
                        
                    } else {
                        Image(systemName: "pawprint")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150, alignment: .center)
                            .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                    
                    Text(breed.name.uppercased())
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.accentColor)
                        .multilineTextAlignment(.center)
                    
                } //:VStack
                .padding()
                
                GroupBox {
                    BreedDetailFormRow(title: "Breed name", content: breed.name)
                    BreedDetailFormRow(title: "Breed category", content: breed.category)
                    BreedDetailFormRow(title: "Origin", content: breed.origin)
                    BreedDetailFormRow(title: "Temperament", content: breed.temperament)
                    
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "info.circle")
                        Text("Information".uppercased())
                            .fontWeight(.bold)
                        
                    } //:HStack
                } //: GroupBox
            } //:VStack
        } //:ScrollView
    }
}

struct BreedDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        BreedDetailsView(breed: Breed(id: 1,
                                      name: "Breed Number One",
                                      imageLink: "https://cdn2.thedogapi.com/images/H6UCIZJsc.jpg",
                                      group: "Working",
                                      category: "Coding",
                                      origin: "Egypt",
                                      temperament: "Docile, Alert, Responsive, Dignified, Composed, Friendly, Receptive, Faithful, Courageous"))
    }
}
