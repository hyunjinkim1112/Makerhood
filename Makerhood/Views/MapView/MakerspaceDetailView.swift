//
//  MakerspaceDetailView.swift
//  Makerhood
//
//  Created by Hyunjin Kim on 21/4/26.
//

import SwiftUI

struct MakerspaceDetailView: View {
    let makerspace: Makerspace
    let geometry: GeometryProxy
    @Binding var selectedMakerspace: Makerspace?
    @Binding var bottomSheetHeight: CGFloat
    let minSheetHeight: CGFloat
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Close button
                HStack {
                    Text("Details")
                        .font(.headline)
                    
                    Spacer()
                    
                    Button(action: {
                        withAnimation(.spring(response: 0.3)) {
                            selectedMakerspace = nil
                            bottomSheetHeight = minSheetHeight
                        }
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.secondary)
                            .font(.title3)
                    }
                }
                .padding(.horizontal)
                
                // Image
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(LinearGradient(
                            colors: [.makerYellow.opacity(0.3), .makerYellow.opacity(0.3)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                        .frame(height: 200)
                    
                    Image(systemName: "hammer.circle.fill")
                        .font(.system(size: 60))
                        .foregroundStyle(.white.opacity(0.8))
                }
                .padding(.horizontal)
                
                // Info
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text(makerspace.name)
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                    }
                
                    
                    HStack {
                        Image(systemName: "location.fill")
                            .foregroundStyle(.makerYellow)
                        Text(makerspace.address)
                            .font(.subheadline)
                    }
                    
                    Divider()
                    
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
    }
}
