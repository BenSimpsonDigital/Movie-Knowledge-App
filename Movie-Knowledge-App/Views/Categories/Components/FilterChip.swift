//
//  FilterChip.swift
//  Movie-Knowledge-App
//
//  Created by Ben Simpson on 4/2/2026.
//

import SwiftUI

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(DesignSystem.Typography.caption(.medium))
                .foregroundStyle(
                    isSelected
                        ? .white
                        : DesignSystem.Colors.textSecondary
                )
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(
                    isSelected
                        ? DesignSystem.Colors.accent
                        : DesignSystem.Colors.surfaceSecondary
                )
                .clipShape(Capsule())
        }
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

#Preview {
    HStack(spacing: 12) {
        FilterChip(title: "All", isSelected: true, action: {})
        FilterChip(title: "People", isSelected: false, action: {})
        FilterChip(title: "Films", isSelected: false, action: {})
    }
    .padding()
    .background(DesignSystem.Colors.screenBackground)
}
