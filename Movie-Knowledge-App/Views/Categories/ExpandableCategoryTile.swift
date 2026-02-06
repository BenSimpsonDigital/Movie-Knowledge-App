//
//  ExpandableCategoryTile.swift
//  Movie-Knowledge-App
//
//  Created by Ben Simpson on 30/1/2026.
//

import SwiftUI

struct ExpandableCategoryTile: View {
    let category: CategoryModel
    let progress: Double
    let isFeatured: Bool
    let onTap: () -> Void
    let onInfoTap: () -> Void

    private var progressPercent: Int {
        Int(progress * 100)
    }

    private var lessonCountText: String {
        let count = category.subCategories.count
        return "\(count) \(count == 1 ? "lesson" : "lessons")"
    }

    var body: some View {
        HStack(spacing: DesignSystem.Spacing.md) {
            Button(action: onTap) {
                HStack(spacing: DesignSystem.Spacing.md) {
                    iconView

                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                        HStack(spacing: DesignSystem.Spacing.xs) {
                            Text(category.title)
                                .font(DesignSystem.Typography.body(.semibold))
                                .foregroundStyle(DesignSystem.Colors.textPrimary)
                                .lineLimit(2)

                            if isFeatured {
                                Text("TODAY")
                                    .font(DesignSystem.Typography.caption(.medium))
                                    .foregroundStyle(category.accentColor)
                                    .padding(.horizontal, DesignSystem.Spacing.xs)
                                    .padding(.vertical, DesignSystem.Spacing.xxs)
                                    .background(category.accentColor.opacity(0.12))
                                    .clipShape(Capsule())
                            }
                        }

                        Text(category.journeySubtitle.isEmpty ? category.subtitle : category.journeySubtitle)
                            .font(DesignSystem.Typography.caption())
                            .foregroundStyle(DesignSystem.Colors.textSecondary)
                            .lineLimit(2)

                        HStack(spacing: DesignSystem.Spacing.sm) {
                            Text(lessonCountText)
                                .font(DesignSystem.Typography.caption(.medium))
                                .foregroundStyle(DesignSystem.Colors.textSecondary)

                            if progress > 0 {
                                Text("\(progressPercent)% complete")
                                    .font(DesignSystem.Typography.caption(.medium))
                                    .foregroundStyle(category.accentColor)
                            }
                        }
                    }

                    Spacer()

                    Image(systemName: "chevron.right")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(DesignSystem.Colors.textTertiary)
                }
                .padding(.vertical, DesignSystem.Spacing.md)
                .padding(.leading, DesignSystem.Spacing.lg)
            }
            .buttonStyle(.plain)
            .accessibilityLabel(category.title)
            .accessibilityHint("Open category lessons")

            Button(action: onInfoTap) {
                Image(systemName: "info.circle")
                    .font(.system(size: 18, weight: .regular))
                    .foregroundStyle(DesignSystem.Colors.textSecondary)
                    .frame(width: 44, height: 44)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel("More info for \(category.title)")
            .accessibilityHint("Open category preview")
            .padding(.trailing, DesignSystem.Spacing.sm)
        }
        .frame(maxWidth: .infinity)
        .background(DesignSystem.Colors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Effects.radiusLarge, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: DesignSystem.Effects.radiusLarge, style: .continuous)
                .strokeBorder(DesignSystem.Colors.borderDefault, lineWidth: DesignSystem.Effects.borderWidth)
        )
        .shadow(
            color: Color.black.opacity(0.04),
            radius: 8,
            x: 0,
            y: 3
        )
    }

    private var iconView: some View {
        ZStack {
            Circle()
                .fill(category.accentColor.opacity(0.16))
                .frame(width: 44, height: 44)

            if let iconName = category.iconName {
                Image(systemName: iconName)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(category.accentColor)
            } else {
                Image(systemName: "film")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(category.accentColor)
            }
        }
    }
}

#Preview {
    let category = CategoryModel(
        title: "The Essentials",
        subtitle: "Essential movie knowledge every film buff needs",
        journeySubtitle: "Foundations every film fan should know",
        tag: nil,
        iconName: "film.stack",
        colorRed: 0.30,
        colorGreen: 0.72,
        colorBlue: 0.62,
        displayOrder: 0
    )

    VStack(spacing: DesignSystem.Spacing.md) {
        ExpandableCategoryTile(
            category: category,
            progress: 0.42,
            isFeatured: true,
            onTap: {},
            onInfoTap: {}
        )

        ExpandableCategoryTile(
            category: category,
            progress: 0,
            isFeatured: false,
            onTap: {},
            onInfoTap: {}
        )
    }
    .padding(DesignSystem.Spacing.xl)
    .background(DesignSystem.Colors.screenBackground)
}
