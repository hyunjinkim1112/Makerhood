//
//  InspirationalQuoteCard.swift
//  Makerhood
//
//  Created by Hyunjin Kim on 24/4/26.
//

import SwiftUI

struct InspirationalQuoteCard: View {
    let imageName: String
    @State private var isVisible = false
    
    var body: some View {
        VStack(spacing: 0) {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 360, height: 340)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        }
        .padding(.horizontal)
        .opacity(isVisible ? 1 : 0)
        .scaleEffect(isVisible ? 1 : 0.9)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                isVisible = true
            }
        }
    }
}

// MARK: - Preview

#Preview {
    InspirationalQuoteCard(imageName: "quote1")
        .padding()
}
