//
//  CategoryTileView.swift
//  Movie-Knowledge-App
//
//  Created by Ben Simpson on 29/1/2026.
//  Minimal, clean category tile design
//

import SwiftUI
import SwiftData

struct CategoryTileView: View {
    let category: CategoryModel
    let progress: Double?
    let isSelected: Bool

    @State private var isPressed: Bool = false

    init(category: CategoryModel, progress: Double? = nil, isSelected: Bool = false) {
        self.category = category
        self.progress = progress
        self.isSelected = isSelected
    }

    // MARK: - Icon Name Conversion
    private var iconAssetName: String {
        guard let iconName = category.iconName else {
            return isSelected ? "heroicon-film-solid" : "heroicon-film-outline"
        }

        let baseIconMap: [String: String] = [
            "film.stack": "heroicon-film",
            "sparkles": "heroicon-sparkles",
            "heart.circle": "heroicon-heart",
            "bolt.fill": "heroicon-bolt",
            "moon.stars": "heroicon-moon",
            "doc.text": "heroicon-document-text",
            "star.fill": "heroicon-star",
            "globe": "heroicon-globe-alt",
            "theatermasks": "heroicon-film",
            "bolt.shield": "heroicon-shield-check",
            "figure.walk": "heroicon-user",
            "lock.shield": "heroicon-lock-closed",
            "play.circle": "heroicon-play-circle",
            "bookmark": "heroicon-bookmark",
            "heart": "heroicon-heart",
            "lightbulb": "heroicon-light-bulb",
            "flame": "heroicon-fire",
            "graduationcap": "heroicon-academic-cap",
            "book.open": "heroicon-book-open",
            "trophy": "heroicon-trophy",
            "camera": "heroicon-camera",
            "ticket": "heroicon-ticket"
        ]

        let baseName = baseIconMap[iconName] ?? "heroicon-film"
        let suffix = isSelected ? "-solid" : "-outline"
        return baseName + suffix
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Top section: Icon with subtle colored background
            HStack(alignment: .top) {
                // Icon container - flat color, no gradient
                ZStack {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(category.accentColor.opacity(0.12))
                        .frame(width: 44, height: 44)

                    if let _ = category.iconName {
                        Image(iconAssetName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 22, height: 22)
                            .foregroundStyle(category.accentColor)
                    }
                }

                Spacer()

                // Progress indicator - minimal ring
                if let progress = progress, progress > 0 {
                    ZStack {
                        Circle()
                            .stroke(DesignSystem.Colors.borderDefault, lineWidth: 2)

                        Circle()
                            .trim(from: 0, to: progress)
                            .stroke(
                                DesignSystem.Colors.textSecondary,
                                style: StrokeStyle(lineWidth: 2, lineCap: .round)
                            )
                            .rotationEffect(.degrees(-90))

                        Text("\(Int(progress * 100))")
                            .font(.system(size: 9, weight: .medium, design: .default))
                            .foregroundStyle(DesignSystem.Colors.textTertiary)
                    }
                    .frame(width: 28, height: 28)
                }
            }
            .padding(.bottom, DesignSystem.Spacing.md)

            Spacer(minLength: 0)

            // Title
            Text(category.title)
                .font(.system(size: 16, weight: .semibold, design: .default))
                .foregroundStyle(DesignSystem.Colors.textPrimary)
                .lineLimit(2)
                .minimumScaleFactor(0.9)
                .fixedSize(horizontal: false, vertical: true)

            Spacer(minLength: DesignSystem.Spacing.xs)

            // Tag or Subtitle - minimal styling
            if let tag = category.tag {
                Text(tag.uppercased())
                    .font(.system(size: 10, weight: .medium, design: .default))
                    .tracking(0.5)
                    .foregroundStyle(DesignSystem.Colors.textTertiary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(DesignSystem.Colors.surfaceSecondary)
                    .clipShape(Capsule())
            } else {
                Text(category.subtitle)
                    .font(.system(size: 12, weight: .regular, design: .default))
                    .foregroundStyle(DesignSystem.Colors.textTertiary)
                    .lineLimit(2)
                    .minimumScaleFactor(0.9)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding(DesignSystem.Spacing.lg)
        .background(DesignSystem.Colors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Effects.radiusMedium, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: DesignSystem.Effects.radiusMedium, style: .continuous)
                .strokeBorder(
                    isSelected ? category.accentColor : DesignSystem.Colors.borderDefault,
                    lineWidth: isSelected ? 1.5 : 1
                )
        )
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .animation(DesignSystem.Animations.snappy, value: isPressed)
    }
}

// MARK: - Preview
#Preview {
    let category1 = CategoryModel(
        title: "Classic Cinema",
        subtitle: "Timeless masterpieces from the golden age",
        tag: "TOP PICK",
        iconName: "film.stack",
        colorRed: 0.75,
        colorGreen: 0.68,
        colorBlue: 0.58,
        displayOrder: 0
    )

    let category2 = CategoryModel(
        title: "Modern Blockbusters",
        subtitle: "Contemporary hits and crowd-pleasers",
        tag: nil,
        iconName: "play.circle",
        colorRed: 0.55,
        colorGreen: 0.65,
        colorBlue: 0.72,
        displayOrder: 1
    )

    let category3 = CategoryModel(
        title: "Horror Nights",
        subtitle: "Spine-chilling tales",
        tag: "NEW",
        iconName: "moon.stars",
        colorRed: 0.60,
        colorGreen: 0.58,
        colorBlue: 0.68,
        displayOrder: 2
    )

    let category4 = CategoryModel(
        title: "Animated Adventures",
        subtitle: "Family-friendly fun",
        tag: nil,
        iconName: "star.fill",
        colorRed: 0.80,
        colorGreen: 0.76,
        colorBlue: 0.62,
        displayOrder: 3
    )

    ScrollView {
        LazyVGrid(columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)], spacing: 16) {
            CategoryTileView(category: category1, progress: 0.65, isSelected: false)
                .frame(height: 160)

            CategoryTileView(category: category2, progress: 0.3, isSelected: true)
                .frame(height: 160)

            CategoryTileView(category: category3, progress: 0.0, isSelected: false)
                .frame(height: 160)

            CategoryTileView(category: category4, progress: 0.85, isSelected: false)
                .frame(height: 160)
        }
        .padding(20)
    }
    .background(DesignSystem.Colors.screenBackground)
    .modelContainer(for: [CategoryModel.self])
}
