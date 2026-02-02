//
//  LevelUpAnimation.swift
//  Movie-Knowledge-App
//
//  Created by Ben Simpson on 29/1/2026.
//  Minimal, clean level-up notification
//

import SwiftUI

struct LevelUpAnimation: View {
    let newLevel: Int
    let onDismiss: () -> Void

    @State private var opacity: Double = 0
    @State private var scale: CGFloat = 0.95

    var body: some View {
        ZStack {
            // Subtle overlay
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    onDismiss()
                }

            // Content card
            VStack(spacing: 24) {
                // Level number
                VStack(spacing: 4) {
                    Text("Level")
                        .font(DesignSystem.Typography.caption(.medium))
                        .foregroundStyle(DesignSystem.Colors.textTertiary)
                        .textCase(.uppercase)
                        .tracking(1)

                    Text("\(newLevel)")
                        .font(.system(size: 56, weight: .bold, design: .default))
                        .foregroundStyle(DesignSystem.Colors.textPrimary)
                }

                // Message
                Text("Keep going!")
                    .font(DesignSystem.Typography.body())
                    .foregroundStyle(DesignSystem.Colors.textSecondary)

                // Continue button
                Button(action: onDismiss) {
                    Text("Continue")
                        .font(DesignSystem.Typography.body(.medium))
                        .foregroundStyle(DesignSystem.Colors.primaryButton)
                }
                .padding(.top, 8)
            }
            .padding(32)
            .background(DesignSystem.Colors.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Effects.radiusLarge, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: DesignSystem.Effects.radiusLarge, style: .continuous)
                    .strokeBorder(DesignSystem.Colors.borderDefault, lineWidth: DesignSystem.Effects.borderWidth)
            )
            .opacity(opacity)
            .scaleEffect(scale)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.2)) {
                opacity = 1
                scale = 1
            }
        }
    }
}

#Preview {
    LevelUpAnimation(newLevel: 5) {
        print("Dismissed")
    }
}
