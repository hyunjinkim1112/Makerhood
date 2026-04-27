//
//  ContentView.swift
//  Makerspace
//
//  Created by Hyunjin Kim on 20/4/26.
//

import SwiftUI

struct ContentView: View {
    @State private var showLaunchScreen = true
    @State private var isLoggedIn = false
    
    var body: some View {
        ZStack {
            if isLoggedIn {
                // Main app content after login
                VStack {
                    Image(systemName: "globe")
                        .imageScale(.large)
                        .foregroundStyle(.tint)
                    Text("Hello, world!")
                }
                .padding()
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

#Preview {
    ContentView()
}
