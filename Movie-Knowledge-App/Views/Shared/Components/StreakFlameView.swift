//
//  StreakFlameView.swift
//  Movie-Knowledge-App
//
//  Created by Ben Simpson on 29/1/2026.
//  Minimal, static streak display
//

import SwiftUI

struct StreakFlameView: View {
    let streak: Int

    var body: some View {
        HStack(spacing: DesignSystem.Spacing.sm) {
            // Static flame icon - no animation
            Image(systemName: "flame")
                .font(.system(size: 24, weight: .regular))
                .foregroundStyle(DesignSystem.Colors.textSecondary)

            // Streak number
            VStack(alignment: .leading, spacing: 2) {
                Text("\(streak)")
                    .font(.system(size: 22, weight: .semibold, design: .default))
                    .foregroundStyle(DesignSystem.Colors.textPrimary)

                Text(streak == 1 ? "day" : "days")
                    .font(DesignSystem.Typography.caption())
                    .foregroundStyle(DesignSystem.Colors.textTertiary)
            }
        }
    }
}

// MARK: - Compact Streak Badge (for headers)

struct StreakBadge: View {
    let streak: Int

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "flame")
                .font(.system(size: 13, weight: .medium))

            Text("\(streak)")
                .font(.system(size: 13, weight: .medium, design: .default))
        }
        .foregroundStyle(DesignSystem.Colors.textSecondary)
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(DesignSystem.Colors.surfaceSecondary)
        .clipShape(Capsule())
    }
}

#Preview {
    VStack(spacing: 40) {
        StreakFlameView(streak: 1)
        StreakFlameView(streak: 7)
        StreakFlameView(streak: 30)

        Divider()

        HStack(spacing: 16) {
            StreakBadge(streak: 3)
            StreakBadge(streak: 15)
            StreakBadge(streak: 100)
        }
    }
    .padding()
    .background(DesignSystem.Colors.screenBackground)
}
