//
//  HeaderIconButton.swift
//  Movie-Knowledge-App
//
//  Created by Ben Simpson on 4/2/2026.
//

import SwiftUI

struct HeaderIconButton: View {
    let systemName: String
    let showsBadge: Bool
    let badgeText: String?
    let action: () -> Void

    init(
        systemName: String,
        showsBadge: Bool = false,
        badgeText: String? = nil,
        action: @escaping () -> Void
    ) {
        self.systemName = systemName
        self.showsBadge = showsBadge
        self.badgeText = badgeText
        self.action = action
    }

    var body: some View {
        Button(action: {
            action()
            HapticManager.shared.light()
        }) {
            ZStack(alignment: .topTrailing) {
                Image(systemName: systemName)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(DesignSystem.Colors.textPrimary)
                    .frame(width: 36, height: 36)
                    .background(DesignSystem.Colors.cardBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .strokeBorder(DesignSystem.Colors.borderDefault, lineWidth: 1)
                    )

                if showsBadge, let badgeText {
                    Text(badgeText)
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(width: 18, height: 18)
                        .background(DesignSystem.Colors.textPrimary)
                        .clipShape(Circle())
                        .offset(x: 6, y: -6)
                }
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    HStack(spacing: 12) {
        HeaderIconButton(systemName: "magnifyingglass", action: {})
        HeaderIconButton(systemName: "line.3.horizontal.decrease", showsBadge: true, badgeText: "2", action: {})
    }
    .padding()
    .background(DesignSystem.Colors.screenBackground)
}
