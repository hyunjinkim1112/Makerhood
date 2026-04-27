//
//  NearbySection.swift
//  Makerhood
//
//  Created by Hyunjin Kim on 21/4/26.
//

import SwiftUI

struct NearbySection: View {
    let makerspaces: [Makerspace]
    let onSeeAllTapped: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "location.fill")
                    .foregroundStyle(.makerYellow)
                Text("Nearby Spaces")
                    .font(.headline)
                
                Spacer()
                
                Button("See All") {
                    onSeeAllTapped()
                }
                .font(.subheadline)
                .foregroundStyle(.makerYellow)
            }
            .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(makerspaces) { makerspace in
                        MakerspaceCard(makerspace: makerspace)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

#Preview {
    NearbySection(
        makerspaces: Makerspace.samples,
        onSeeAllTapped: {}
    )
}
