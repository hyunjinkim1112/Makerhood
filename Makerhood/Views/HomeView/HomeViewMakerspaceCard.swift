//
//  MakerspaceCard.swift
//  Makerhood
//
//  Created by Hyunjin Kim on 21/4/26.
//

import SwiftUI

struct MakerspaceCard: View {
    let makerspace: Makerspace
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Image Placeholder
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(LinearGradient(
                        colors: [.makerYellow.opacity(0.3), .makerYellow.opacity(0.3)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(width: 280, height: 160)
                
                Image(systemName: "hammer.circle.fill")
                    .font(.system(size: 50))
                    .foregroundStyle(.white.opacity(0.8))
            }
            
            // Info
            VStack(alignment: .leading, spacing: 4) {
                Text(makerspace.name)
                    .font(.headline)
                    .lineLimit(1)
                
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
                
                HStack {
                    Text("$\(Int(makerspace.pricePerHour))/hr")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.makerYellow)
                    
                    Spacer()
                    
                    if makerspace.isPopular {
                        HStack(spacing: 2) {
                            Image(systemName: "flame.fill")
                                .font(.caption2)
                            Text("Popular")
                                .font(.caption2)
                        }
                        .foregroundStyle(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.makerYellow)
                        .cornerRadius(8)
                    }
                }
            }
            .padding(.horizontal, 8)
        }
        .frame(width: 280)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}

#Preview {
    MakerspaceCard(makerspace: Makerspace.samples[0])
}
