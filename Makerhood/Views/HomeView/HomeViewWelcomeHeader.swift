//
//  WelcomeHeader.swift
//  Makerhood
//
//  Created by Hyunjin Kim on 21/4/26.
//

import SwiftUI

struct WelcomeHeader: View {
    let userName: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("👋 Hey \(userName?.components(separatedBy: " ").first ?? "there")")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Find your Makerspace")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal)
    }
}

#Preview {
    WelcomeHeader(userName: "John Doe")
}
