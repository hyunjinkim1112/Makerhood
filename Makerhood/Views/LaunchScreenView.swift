//
//  LaunchScreenView.swift
//  Makerspace
//
//  Created by Hyunjin Kim on 20/4/26.
//

import SwiftUI

struct LaunchScreenView: View {
    @State private var currentImageIndex = 1
    @State private var isAnimating = true
    let numOfImages = 7
    let onComplete: () -> Void
    
    var body: some View {
        ZStack {
            Color.makerYellow
                .ignoresSafeArea()
            
            Image("\(currentImageIndex)")
                .resizable()
                .scaledToFit()
        }
        .onAppear {
            startAnimation()
        }
    }
    
    private func startAnimation() {
        // Wait 1.5 seconds before starting the animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            // Create a timer that cycles through images 2-7
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                // Check if we've reached the last image before incrementing
                if currentImageIndex >= numOfImages {
                    timer.invalidate()
                    onComplete()
                } else {
                    currentImageIndex += 1
                }
            }
        }
    }
}

#Preview {
    LaunchScreenView {
        print("Launch screen completed")
    }
}
