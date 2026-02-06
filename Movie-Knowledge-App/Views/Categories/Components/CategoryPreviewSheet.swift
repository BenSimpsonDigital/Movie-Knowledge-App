//
//  CategoryPreviewSheet.swift
//  Movie-Knowledge-App
//
//  Created by Codex on 6/2/2026.
//

import SwiftUI

struct CategoryPreviewSheet: View {
    let category: CategoryModel
    let progress: Double
    let onStart: () -> Void
    let onOpenCategory: () -> Void

    @Environment(\.dismiss) private var dismiss

    private var progressPercent: Int {
        Int(progress * 100)
    }

    private var lessonCountText: String {
        let count = category.subCategories.count
        return "\(count) \(count == 1 ? "lesson" : "lessons")"
    }

    private var highlights: [String] {
        Array(CategoryMetadata.highlights(for: category.title).prefix(3))
    }

    private var difficultyText: String {
        guard let metadata = CategoryMetadata.forCategory(title: category.title) else {
            return "Mixed"
        }

        switch metadata.difficulty {
        case .easy: return "Easy"
        case .intermediate: return "Intermediate"
        case .filmNerd: return "Film Nerd"
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.lg) {
                    HStack(spacing: DesignSystem.Spacing.md) {
                        Circle()
                            .fill(category.accentColor.opacity(0.18))
                            .frame(width: 50, height: 50)
                            .overlay {
                                Image(systemName: category.iconName ?? "film")
                                    .font(.system(size: 20, weight: .medium))
                                    .foregroundStyle(category.accentColor)
                            }

                        VStack(alignment: .leading, spacing: DesignSystem.Spacing.xxs) {
                            Text(category.title)
                                .font(DesignSystem.Typography.heading())
                                .foregroundStyle(DesignSystem.Colors.textPrimary)

                            Text(category.subtitle)
                                .font(DesignSystem.Typography.body())
                                .foregroundStyle(DesignSystem.Colors.textSecondary)
                        }
                    }

                    HStack(spacing: DesignSystem.Spacing.sm) {
                        pill(text: lessonCountText, color: DesignSystem.Colors.textSecondary)
                        pill(text: "\(progressPercent)% complete", color: category.accentColor)
                        pill(text: difficultyText, color: DesignSystem.Colors.textSecondary)
                    }

                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
                        Text("What you'll learn")
                            .font(DesignSystem.Typography.body(.semibold))
                            .foregroundStyle(DesignSystem.Colors.textPrimary)

                        ForEach(highlights, id: \.self) { highlight in
                            HStack(alignment: .top, spacing: DesignSystem.Spacing.xs) {
                                Circle()
                                    .fill(category.accentColor)
                                    .frame(width: 6, height: 6)
                                    .padding(.top, 6)

                                Text(highlight)
                                    .font(DesignSystem.Typography.body())
                                    .foregroundStyle(DesignSystem.Colors.textSecondary)
                            }
                        }
                    }

                    VStack(spacing: DesignSystem.Spacing.sm) {
                        Button {
                            onStart()
                            dismiss()
                        } label: {
                            Text("Start quick lesson")
                                .depthButtonLabel(font: DesignSystem.Typography.body(.semibold))
                        }
                        .buttonStyle(DepthButtonStyle(cornerRadius: 12))

                        Button {
                            onOpenCategory()
                            dismiss()
                        } label: {
                            Text("Open full category")
                                .font(DesignSystem.Typography.body(.medium))
                                .foregroundStyle(DesignSystem.Colors.textPrimary)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 13)
                                .background(DesignSystem.Colors.cardBackground)
                                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                        .strokeBorder(
                                            DesignSystem.Colors.borderDefault,
                                            lineWidth: DesignSystem.Effects.borderWidth
                                        )
                                )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(DesignSystem.Spacing.xl)
            }
            .background(DesignSystem.Colors.screenBackground)
            .navigationTitle("Category Preview")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundStyle(DesignSystem.Colors.accent)
                }
            }
        }
        .presentationDetents([.medium, .large])
    }

    private func pill(text: String, color: Color) -> some View {
        Text(text)
            .font(DesignSystem.Typography.caption(.medium))
            .foregroundStyle(color)
            .padding(.horizontal, DesignSystem.Spacing.sm)
            .padding(.vertical, DesignSystem.Spacing.xs)
            .background(color.opacity(0.12))
            .clipShape(Capsule())
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

    CategoryPreviewSheet(
        category: category,
        progress: 0.25,
        onStart: {},
        onOpenCategory: {}
    )
}
