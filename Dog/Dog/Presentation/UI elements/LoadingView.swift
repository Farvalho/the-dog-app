//
//  LoadingView.swift
//  Dog
//
//  Created by Fábio Carvalho on 16/09/2022.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack {
            Color.gray.opacity(0.5)
            
            ProgressView()
                .progressViewStyle(.circular)
        }
    }
}
