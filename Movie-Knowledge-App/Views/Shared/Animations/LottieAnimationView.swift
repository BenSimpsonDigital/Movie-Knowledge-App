//
//  LottieAnimationView.swift
//  Movie-Knowledge-App
//
//  Created by Claude on 2/2/2026.
//

import SwiftUI
import Lottie

struct LottieAnimationView: View {
    let animationName: String
    var size: CGFloat = 100

    @State private var playbackMode: LottiePlaybackMode = .paused(at: .frame(0))

    var body: some View {
        LottieView(animation: .named(animationName))
            .configure { animationView in
                animationView.backgroundColor = .clear
                // Use Core Animation for smoother, hardware-accelerated rendering
                animationView.configuration = LottieConfiguration(renderingEngine: .coreAnimation)
            }
            .playbackMode(playbackMode)
            .animationDidFinish { _ in
                // Freeze on last frame after completion
                playbackMode = .paused(at: .progress(1))
            }
            .frame(width: size, height: size)
            .onAppear {
                // Play animation once from the beginning
                playbackMode = .playing(.fromProgress(0, toProgress: 1, loopMode: .playOnce))
            }
    }
}

#Preview {
    VStack(spacing: 40) {
        LottieAnimationView(animationName: "popcorn-animation-1", size: 100)
        LottieAnimationView(animationName: "popcorn-animation-1", size: 80)
    }
    .padding()
    .background(Color.gray.opacity(0.1))
}
