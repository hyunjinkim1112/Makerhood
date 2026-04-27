//
//  ContentView.swift
//  Makerspace
//
//  Created by Hyunjin Kim on 20/4/26.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showLaunchScreen = true
    
    var body: some View {
        ZStack {
            if authViewModel.isAuthenticated {
                // Main app content after login
                MainTabView()
            } else {
                // Show login view
                LoginView()
            }
            
            // Launch screen overlay
            if showLaunchScreen {
                LaunchScreenView {
                    showLaunchScreen = false
                }
                .transition(.opacity)
                .zIndex(1)
            }
        }
    }
}

// Main app content with tab navigation
struct MainTabView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)
            
            MapView()
                .tabItem {
                    Label("Explore", systemImage: "map.fill")
                }
                .tag(1)
            
            DesignChallengeView()
                .tabItem {
                    Label("Challenge", systemImage: "lightbulb.fill")
                }
                .tag(2)
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
                .tag(3)
        }
        .tint(.makerYellow)
    }
}




#Preview {
    ContentView()
        .environmentObject(AuthViewModel())
}
