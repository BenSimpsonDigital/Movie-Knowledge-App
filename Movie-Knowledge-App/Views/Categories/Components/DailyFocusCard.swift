//
//  DailyFocusCard.swift
//  Movie-Knowledge-App
//
//  Created by Codex on 6/2/2026.
//

import SwiftUI

struct DailyFocusCard: View {
    let focus: DailyFocus?
    let onStart: () -> Void

    private var canStart: Bool {
        guard let focus else { return false }
        return !focus.isCompleted && !focus.isComingSoon
    }

    private var categoryColor: Color {
        guard let focus else {
            return DesignSystem.Colors.accent
        }
        return focus.category.accentColor
    }

    private var titleText: String {
        guard let focus else { return "No daily focus available" }
        if focus.isCompleted {
            return "All set for today"
        }
        return focus.subCategory.title
    }

    private var subtitleText: String {
        guard let focus else { return "Come back soon for your next lesson." }
        if focus.isCompleted {
            return "You completed today's lesson. Come back tomorrow for a new topic."
        }
        if focus.isComingSoon {
            return "Today's lesson is marked as coming soon."
        }
        return focus.category.title
    }

    private var buttonTitle: String {
        guard let focus else { return "Unavailable" }
        if focus.isCompleted { return "Come back tomorrow" }
        if focus.isComingSoon { return "Coming soon" }
        return "Start daily focus"
    }

    private var quickFacts: [String] {
        guard let focus else { return [] }
        if focus.isCompleted {
            return [
                "Your daily focus is complete.",
                "Keep your streak alive tomorrow."
            ]
        }

        let source = focus.subCategory.keyFacts
        if source.isEmpty {
            return [
                "Learn a concise film concept.",
                "Build momentum with one focused quiz."
            ]
        }
        return Array(source.prefix(2))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
            HStack(spacing: DesignSystem.Spacing.xs) {
                Text("DAILY FOCUS")
                    .font(DesignSystem.Typography.caption(.medium))
                    .foregroundStyle(categoryColor)
                    .tracking(0.5)

                Spacer()

                if let focus {
                    Text("\(focus.subCategory.challenges.count) questions")
                        .font(DesignSystem.Typography.caption())
                        .foregroundStyle(DesignSystem.Colors.textSecondary)
                }
            }

            Text(titleText)
                .font(DesignSystem.Typography.heading())
                .foregroundStyle(DesignSystem.Colors.textPrimary)
                .lineLimit(2)

            Text(subtitleText)
                .font(DesignSystem.Typography.body())
                .foregroundStyle(DesignSystem.Colors.textSecondary)
                .lineLimit(2)

            if !quickFacts.isEmpty {
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                    ForEach(quickFacts, id: \.self) { fact in
                        HStack(alignment: .top, spacing: DesignSystem.Spacing.xs) {
                            Circle()
                                .fill(categoryColor.opacity(0.8))
                                .frame(width: 6, height: 6)
                                .padding(.top, 6)

                            Text(fact)
                                .font(DesignSystem.Typography.caption())
                                .foregroundStyle(DesignSystem.Colors.textSecondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
            }

            Button(action: onStart) {
                Text(buttonTitle)
                    .depthButtonLabel(
                        font: DesignSystem.Typography.body(.semibold),
                        verticalPadding: 13
                    )
            }
            .buttonStyle(DepthButtonStyle(cornerRadius: 12))
            .disabled(!canStart)
            .opacity(canStart ? 1 : 0.75)
            .accessibilityHint("Starts your daily lesson if available")
        }
        .padding(DesignSystem.Spacing.xl)
        .background(DesignSystem.Colors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Effects.radiusLarge, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: DesignSystem.Effects.radiusLarge, style: .continuous)
                .strokeBorder(DesignSystem.Colors.borderDefault, lineWidth: DesignSystem.Effects.borderWidth)
        )
        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 3)
    }
}

#Preview {
    DailyFocusCard(focus: nil, onStart: {})
        .padding(DesignSystem.Spacing.xl)
        .background(DesignSystem.Colors.screenBackground)
}
