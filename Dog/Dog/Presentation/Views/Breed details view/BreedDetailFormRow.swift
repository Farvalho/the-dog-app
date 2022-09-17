//
//  BreedDetailFormRow.swift
//  Dog
//
//  Created by Fábio Carvalho on 17/09/2022.
//

import SwiftUI

struct BreedDetailFormRow: View {
    var title: String
    var content: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Divider()
            Text(title)
                .foregroundColor(.gray)
            
            Text(content ?? "N/A")
        } //:VStack
        .padding(.vertical, 4)
    }
}

struct BreedDetailFormRow_Previews: PreviewProvider {
    static var previews: some View {
        BreedDetailFormRow(title: "Title", content: "This is some content")
        .previewLayout(.fixed(width: 300, height: 100))
        .padding()
    }
}
