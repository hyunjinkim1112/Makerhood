//
//  MapMarkerView.swift
//  Makerhood
//
//  Created by Hyunjin Kim on 21/4/26.
//

import SwiftUI

struct MapMarkerView: View {
    let makerspace: Makerspace
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 4) {
            ZStack {
                Circle()
                    .fill(isSelected ? Color.makerYellow : Color.makerYellow)
                    .frame(width: isSelected ? 50 : 40, height: isSelected ? 50 : 40)
                    .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
                
                Image(systemName: "hammer.fill")
                    .foregroundStyle(.white)
                    .font(.system(size: isSelected ? 20 : 16))
            }
            
            if isSelected {
                Text(makerspace.name)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color(.systemBackground))
                    .cornerRadius(8)
                    .shadow(color: .black.opacity(0.1), radius: 2)
            }
        }
        .animation(.spring(response: 0.3), value: isSelected)
    }
}
