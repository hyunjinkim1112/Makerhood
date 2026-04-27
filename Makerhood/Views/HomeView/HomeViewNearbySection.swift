//
//  NearbySection.swift
//  Makerhood
//
//  Created by Hyunjin Kim on 21/4/26.
//

import SwiftUI

struct NearbySection: View {
    let makerspaces: [Makerspace]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "location.fill")
                    .foregroundStyle(.makerYellow)
                Text("Nearby Spaces")
                    .font(.headline)
                
                Spacer()
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
        makerspaces: Makerspace.samples
    )
}
