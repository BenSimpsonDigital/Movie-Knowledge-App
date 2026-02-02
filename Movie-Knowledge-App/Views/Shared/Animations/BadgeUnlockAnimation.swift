//
//  BadgeUnlockAnimation.swift
//  Movie-Knowledge-App
//
//  Created by Ben Simpson on 29/1/2026.
//  Minimal, clean badge notification
//

import SwiftUI
import SwiftData

struct BadgeUnlockAnimation: View {
    let badge: Badge
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
                // Badge icon
                Circle()
                    .fill(DesignSystem.Colors.surfaceSecondary)
                    .frame(width: 80, height: 80)
                    .overlay {
                        Image(systemName: badge.iconName)
                            .font(.system(size: 32, weight: .light))
                            .foregroundStyle(DesignSystem.Colors.textSecondary)
                    }

                // Badge info
                VStack(spacing: 8) {
                    Text("Badge Earned")
                        .font(DesignSystem.Typography.caption(.medium))
                        .foregroundStyle(DesignSystem.Colors.textTertiary)
                        .textCase(.uppercase)
                        .tracking(1)

                    Text(badge.title)
                        .font(DesignSystem.Typography.heading())
                        .foregroundStyle(DesignSystem.Colors.textPrimary)
                        .multilineTextAlignment(.center)

                    Text(badge.descriptionText)
                        .font(DesignSystem.Typography.body())
                        .foregroundStyle(DesignSystem.Colors.textSecondary)
                        .multilineTextAlignment(.center)
                }

                // Continue button
                Button(action: onDismiss) {
                    Text("Continue")
                        .font(DesignSystem.Typography.body(.medium))
                        .foregroundStyle(DesignSystem.Colors.primaryButton)
                }
                .padding(.top, 8)
            }
            .padding(32)
            .frame(maxWidth: 300)
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
    BadgeUnlockAnimation(
        badge: Badge(
            id: UUID(),
            title: "Classic Cinema Expert",
            descriptionText: "Completed all Classic Cinema lessons",
            iconName: "film.stack.fill",
            categoryId: UUID(),
            earnedDate: Date()
        )
    ) {
        print("Dismissed")
    }
}
