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
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(.indigo.opacity(0.15))
                .padding(.vertical, 5)
                .padding(.horizontal, 20)
            
            ProgressView()
                .progressViewStyle(.circular)
        }
    }
}
