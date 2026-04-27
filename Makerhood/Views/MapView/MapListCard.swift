//
//  MapListCard.swift
//  Makerhood
//
//  Created by Hyunjin Kim on 21/4/26.
//

import SwiftUI

struct MapListCard: View {
    let makerspace: Makerspace
    
    var body: some View {
        HStack(spacing: 12) {
            // Icon
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(LinearGradient(
                        colors: [.makerYellow.opacity(0.3), .makerYellow.opacity(0.3)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(width: 60, height: 60)
                
                Image(systemName: "hammer.circle.fill")
                    .font(.system(size: 28))
                    .foregroundStyle(.white.opacity(0.8))
            }
            
            // Info
            VStack(alignment: .leading, spacing: 4) {
                Text(makerspace.name)
                    .font(.headline)
                    .lineLimit(1)
                
                Text(makerspace.address)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
            
            Spacer()
        
        }
        .padding(12)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}
