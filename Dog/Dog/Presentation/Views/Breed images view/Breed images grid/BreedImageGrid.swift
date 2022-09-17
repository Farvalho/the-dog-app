//
//  BreedImageGrid.swift
//  Dog
//
//  Created by Fábio Carvalho on 17/09/2022.
//

import SwiftUI

struct BreedImageGrid: View {
    @Binding var items: [Breed]
    @Binding var loadsMore: Bool
    var loadTask: (() -> Void)?
    
    private let vGridColumns = [
        GridItem(.adaptive(minimum: 150), spacing: 12, alignment: .center)
    ]
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVGrid(columns: vGridColumns) {
                ForEach(items) { item in
                    BreedImageGridItem(breed: item)
                        .padding(.bottom, 10)
                    
                } //:ForEach
                
                if items.count > 0 {
                    if loadsMore {
                        ProgressView()
                            .frame(width: 150, height: 150)
                            .onAppear {
                                loadTask?()
                            }
                        
                    } else {
                        Text("That's all the dogs you'll get!")
                            .font(.caption)
                    }
                }
            } //:LazyVGrid
            .padding(.bottom, 20)
            
        } //:ScrollView
    }
}

struct BreedImageGrid_Previews: PreviewProvider {
    static var previews: some View {
        BreedImageGrid(items: .constant(
            BreedImagesPresenter(getBreedsUseCase: FakeGetBreedsUseCase()).breeds), loadsMore: .constant(true))
    }
}
