//
//  SearchBreedsListRow.swift
//  Dog
//
//  Created by Fábio Carvalho on 18/09/2022.
//

import SwiftUI

struct SearchBreedsListRow: View {
    var breed: Breed
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(breed.name)
                .font(.headline)
                .fontWeight(.semibold)
                .padding(.bottom, 4)
            
            HStack {
                Text("Group:")
                    .foregroundColor(.gray)
                
                Text(breed.group ?? "N/A")
            } //:HStack
            
            HStack {
                Text("Origin:")
                    .foregroundColor(.gray)
                
                Text(breed.origin ?? "N/A")
            } //:HStack
            
        } //:VStack
    }
}

struct SearchBreedsListRow_Previews: PreviewProvider {
    static var previews: some View {
        SearchBreedsListRow(breed: Breed(id: 1,
                                         name: "Breed Number One",
                                         imageLink: "https://cdn2.thedogapi.com/images/H6UCIZJsc.jpg",
                                         group: "Working",
                                         category: "Coding",
                                         origin: "Egypt",
                                         temperament: "Docile, Alert, Responsive, Dignified, Composed, Friendly, Receptive, Faithful, Courageous"))
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
