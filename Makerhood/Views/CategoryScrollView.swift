//
//  CategoryScrollView.swift
//  Makerhood
//
//  Created by Hyunjin Kim on 21/4/26.
//

import SwiftUI

struct CategoryScrollView: View {
    @Binding var selectedCategory: WorkshopCategory?
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                // All Categories
                CategoryChip(
                    title: "All",
                    icon: "square.grid.2x2",
                    isSelected: selectedCategory == nil,
                    action: { selectedCategory = nil }
                )
                
                // Individual Categories
                ForEach(WorkshopCategory.allCases, id: \.self) { category in
                    CategoryChip(
                        title: category.rawValue,
                        icon: category.icon,
                        isSelected: selectedCategory == category,
                        action: { selectedCategory = category }
                    )
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 8)
        .background(Color(.systemBackground))
    }
}

// MARK: - Category Chip

struct CategoryChip: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.caption)
                Text(title)
                    .font(.subheadline)
                    .fontWeight(isSelected ? .semibold : .regular)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .foregroundStyle(isSelected ? .white : .primary)
            .background(isSelected ? Color.makerYellow : Color(.systemGray6))
            .cornerRadius(20)
        }
    }
}

// MARK: - Preview

#Preview {
    VStack {
        CategoryScrollView(selectedCategory: .constant(nil))
        
        Spacer()
        
        CategoryScrollView(selectedCategory: .constant(.printing3D))
    }
}
