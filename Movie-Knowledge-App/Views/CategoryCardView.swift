//
//  CategoryCardView.swift
//  Movie-Knowledge-App
//
//  Created by Ben Simpson on 29/1/2026.
//

import SwiftUI
import SwiftData

struct CategoryCardView: View {
    let category: CategoryModel
    let progress: Double? // Optional: 0.0 to 1.0

    init(category: CategoryModel, progress: Double? = nil) {
        self.category = category
        self.progress = progress
    }

    var body: some View {
        VStack(spacing: 20) {
            // Optional SF Symbol icon
            if let iconName = category.iconName {
                Image(systemName: iconName)
                    .font(.system(size: 60))
                    .foregroundStyle(category.accentColor)
                    .symbolRenderingMode(.hierarchical)
            }

            // Title (big, bold)
            Text(category.title)
                .font(.system(size: 42, weight: .bold))
                .multilineTextAlignment(.center)
                .foregroundStyle(.primary)

            // Subtitle (smaller, muted)
            Text(category.subtitle)
                .font(.system(size: 18, weight: .regular))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .lineLimit(2)

            // Optional pill tag
            if let tag = category.tag {
                Text(tag)
                    .font(.system(size: 12, weight: .semibold))
                    .tracking(0.5)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(DesignSystem.Colors.tagBackground)
                    )
                    .foregroundStyle(DesignSystem.Colors.tagText)
            }
        }
        .padding(40)
        .frame(maxWidth: .infinity)
        .frame(height: 450)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(DesignSystem.Colors.cardBackground)
                .shadow(color: .black.opacity(0.08), radius: 20, y: 10)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .strokeBorder(DesignSystem.Colors.borderDefault, lineWidth: DesignSystem.Effects.borderWidth)
        )
        .overlay(alignment: .topTrailing) {
            // Progress ring overlay (top-right corner)
            if let progress = progress {
                ProgressRing(
                    progress: progress,
                    color: category.accentColor,
                    lineWidth: 3
                )
                .frame(width: 50, height: 50)
                .padding(16)
            }
        }
    }
}

// MARK: - Preview
#Preview {
    let category = CategoryModel(
        title: "Classic Cinema",
        subtitle: "Timeless masterpieces from the golden age",
        tag: "TOP PICK",
        iconName: "film.stack",
        colorRed: 0.90,
        colorGreen: 0.86,
        colorBlue: 0.82,
        displayOrder: 0
    )

    CategoryCardView(category: category, progress: 0.6)
        .padding()
        .background(DesignSystem.Colors.screenBackground)
        .modelContainer(for: [CategoryModel.self])
}
