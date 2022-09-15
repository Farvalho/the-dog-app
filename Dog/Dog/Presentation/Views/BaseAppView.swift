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
            BreedsView()
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
        .tint(.accentColor)
    }
}

struct BaseAppView_Previews: PreviewProvider {
    static var previews: some View {
        BaseAppView()
    }
}
