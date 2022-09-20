//
//  BaseAppView.swift
//  Dog
//
//  Created by Fábio Carvalho on 15/09/2022.
//

import SwiftUI

struct BaseAppView: View {
    var body: some View {
        TabView {
            BreedImagesView()
                .tabItem {
                    Image(systemName: "pawprint")
                    Text("Breeds")
                }
            
            SearchBreedsView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
            
        } //:TabView
        .edgesIgnoringSafeArea(.top)
    }
}

struct BaseAppView_Previews: PreviewProvider {
    static var previews: some View {
        BaseAppView()
    }
}
