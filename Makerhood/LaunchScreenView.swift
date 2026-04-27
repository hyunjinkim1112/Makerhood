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
        // Create a timer that cycles through images 1-7
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            currentImageIndex += 1
            
            // Stop at the last image
            if currentImageIndex > numOfImages {
                timer.invalidate()
                onComplete()
            }
        }
    }
}

#Preview {
    LaunchScreenView {
        print("Launch screen completed")
    }
}
