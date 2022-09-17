//
//  BreedImageList.swift
//  Dog
//
//  Created by Fábio Carvalho on 17/09/2022.
//

import SwiftUI

struct BreedImageList: View {
    @Binding var items: [Breed]
    @Binding var loadsMore: Bool
    var loadTask: (() -> Void)?
    
    var body: some View {
        List {
            ForEach(items) { item in
                BreedImageListRow(breed: item)
                    .padding(.vertical, 4)
    
            } //:ForEach
            
            if items.count > 0 {
                if loadsMore {
                    HStack(alignment: .center) {
                        Spacer()
                        ProgressView()
                            .onAppear {
                                loadTask?()
                            }
                        Spacer()
                    } //:HStack
                    .padding(.vertical, 4)
                        
                } else {
                    Text("That's all the dogs you'll get!")
                        .font(.caption)
                }
            }
        } //:List
    }
}

struct BreedImageList_Previews: PreviewProvider {
    static var previews: some View {
        BreedImageList(items: .constant(
            BreedImagesPresenter(getBreedsUseCase: FakeGetBreedsUseCase()).breeds), loadsMore: .constant(true))
    }
}
