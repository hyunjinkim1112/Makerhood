//
//  MakerspaceCard.swift
//  Makerhood
//
//  Created by Hyunjin Kim on 21/4/26.
//

import SwiftUI

struct MakerspaceCard: View {
    let makerspace: Makerspace
    @Environment(\.openURL) private var openURL
    
    // Open URL in Safari
    private func openWebsite() {
        guard let websiteURL = makerspace.websiteURL,
              let url = URL(string: websiteURL) else {
            print("❌ No valid website URL found")
            return
        }
        
        print("🌐 Opening website: \(url.absoluteString)")
        openURL(url)
    }
    
    // Placeholder view for loading or error states
    private var placeholderView: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(LinearGradient(
                colors: [.makerYellow.opacity(0.3), .makerYellow.opacity(0.5)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ))
            .frame(width: 280, height: 160)
            .overlay {
                Image(systemName: "building.2.fill")
                    .font(.system(size: 50))
                    .foregroundStyle(.white.opacity(0.8))
            }
    }
    
    var body: some View {
        Button {
            openWebsite()
        } label: {
            VStack(alignment: .leading, spacing: 8) {
                // Image
                AsyncImage(url: URL(string: makerspace.imageURL ?? "")) { phase in
                    switch phase {
                    case .empty:
                        // Loading state
                        placeholderView
                            .overlay {
                                ProgressView()
                                    .tint(.white)
                            }
                        
                    case .success(let image):
                        // Successfully loaded image
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 280, height: 160)
                            .clipped()
                        
                    case .failure:
                        // Failed to load - show placeholder
                        placeholderView
                        
                    @unknown default:
                        placeholderView
                    }
                }
                .frame(width: 280, height: 160)
                .cornerRadius(12)
                
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
                .padding(8)
            }
            .frame(width: 280)
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    MakerspaceCard(makerspace: Makerspace.samples[0])
}
