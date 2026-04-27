//
//  WorkshopsView.swift
//  Makerhood
//
//  Created by Hyunjin Kim on 21/4/26.
//

import SwiftUI

struct WorkshopsView: View {
    @StateObject private var viewModel = WorkshopsViewModel()
    @State private var selectedCategory: WorkshopCategory?
    @State private var searchText = ""
    @State private var showFilters = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Search Bar
                WorkshopSearchBar(searchText: $searchText)
                    .padding()
                
                // Category Filter
                CategoryScrollView(selectedCategory: $selectedCategory)
                
                // Workshops List
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(filteredWorkshops) { workshop in
                            WorkshopCard(workshop: workshop)
                        }
                    }
                    .padding()
                }
                .refreshable {
                    await viewModel.fetchWorkshops()
                }
            }
            .navigationTitle("Workshops")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { showFilters.toggle() }) {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .foregroundStyle(.makerYellow)
                    }
                }
            }
            .sheet(isPresented: $showFilters) {
                WorkshopFiltersView(viewModel: viewModel)
            }
        }
        .task {
            await viewModel.fetchWorkshops()
        }
    }
    
    private var filteredWorkshops: [Workshop] {
        viewModel.filteredWorkshops(searchText: searchText, selectedCategory: selectedCategory)
    }
}

// MARK: - Preview

#Preview {
    WorkshopsView()
}
