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
                HStack {
                    Text(makerspace.name)
                        .font(.headline)
                        .lineLimit(1)
                    
                    if makerspace.isPopular {
                        Image(systemName: "flame.fill")
                            .font(.caption)
                            .foregroundStyle(.makerYellow)
                    }
                }
                
                HStack {
                    Image(systemName: "star.fill")
                        .font(.caption)
                        .foregroundStyle(.makerYellow)
                    Text(String(format: "%.1f", makerspace.rating))
                        .font(.caption)
                    Text("(\(makerspace.reviewCount))")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Text(makerspace.address)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
            
            Spacer()
            
            // Price
            VStack(alignment: .trailing, spacing: 2) {
                Text("$\(Int(makerspace.pricePerHour))")
                    .font(.headline)
                    .foregroundStyle(.makerYellow)
                Text("per hour")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(12)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}
