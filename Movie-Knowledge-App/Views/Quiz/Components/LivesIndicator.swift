//
//  LivesIndicator.swift
//  Movie-Knowledge-App
//
//  Created by Ben Simpson on 29/1/2026.
//

import SwiftUI

struct LivesIndicator: View {
    let livesRemaining: Int
    let maxLives: Int

    init(livesRemaining: Int, maxLives: Int = 3) {
        self.livesRemaining = livesRemaining
        self.maxLives = maxLives
    }

    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<maxLives, id: \.self) { index in
                Image(systemName: index < livesRemaining ? "heart.fill" : "heart")
                    .font(.system(size: 16))
                    .foregroundStyle(index < livesRemaining ? .red : .gray.opacity(0.4))
                    .scaleEffect(index < livesRemaining ? 1.0 : 0.9)
                    .animation(.spring(response: 0.3, dampingFraction: 0.6), value: livesRemaining)
            }
        }
    }
}

// MARK: - Animated Life Lost

struct AnimatedLifeLost: View {
    @State private var scale: CGFloat = 1.0
    @State private var opacity: Double = 1.0
    @State private var offset: CGFloat = 0

    var body: some View {
        Image(systemName: "heart.slash.fill")
            .font(.system(size: 24))
            .foregroundStyle(.red)
            .scaleEffect(scale)
            .opacity(opacity)
            .offset(y: offset)
            .onAppear {
                withAnimation(.easeOut(duration: 0.3)) {
                    scale = 1.5
                }
                withAnimation(.easeIn(duration: 0.5).delay(0.2)) {
                    opacity = 0
                    offset = -30
                }
            }
    }
}

#Preview {
    VStack(spacing: 20) {
        LivesIndicator(livesRemaining: 3)
        LivesIndicator(livesRemaining: 2)
        LivesIndicator(livesRemaining: 1)
        LivesIndicator(livesRemaining: 0)
    }
    .padding()
}
