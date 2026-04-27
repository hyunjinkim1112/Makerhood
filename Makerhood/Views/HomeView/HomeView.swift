//
//  HomeView.swift
//  Makerhood
//
//  Created by Hyunjin Kim on 20/4/26.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var mapViewModel = MapViewModel()
    @State private var selectedQuoteImage: String = InspirationalQuoteHelper.randomQuote()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Welcome Header
                    WelcomeHeader(user: authViewModel.currentUser)
                    
                    // Inspirational Quote Image
                    InspirationalQuoteCard(imageName: selectedQuoteImage)
                        .frame(maxWidth: .infinity)
                    
                    
                    // Nearby Spaces Section
                    NearbySection(
                        makerspaces: mapViewModel.makerspaces
                    )

                }
                .padding(.vertical)
            }
            .refreshable {
                await refreshData()
            }
            .task {
                // Fetch makerspaces when view appears
                await mapViewModel.fetchMakerspaces()
            }
            .navigationTitle("Makerhood")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        authViewModel.signOut()
                    }) {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .foregroundStyle(.makerYellow)
                    }
                }
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func refreshData() async {
        await mapViewModel.fetchMakerspaces()
    }
}

// MARK: - Preview

#Preview {
    HomeView()
        .environmentObject(AuthViewModel())
}
