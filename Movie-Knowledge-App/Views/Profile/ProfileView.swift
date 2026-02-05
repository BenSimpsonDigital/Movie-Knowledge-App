//
//  ProfileView.swift
//  Movie-Knowledge-App
//
//  Created by Ben Simpson on 29/1/2026.
//  Minimal, clean profile view design
//

import SwiftUI
import SwiftData

struct ProfileView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.modelContext) private var context
    @State private var showContent = false

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                screenTitle

                // Profile Header
                profileHeader
                    .padding(.bottom, DesignSystem.Spacing.xxl)

                // XP Progress
                xpProgressCard
                    .padding(.horizontal, DesignSystem.Spacing.screenMargin)
                    .padding(.bottom, DesignSystem.Spacing.lg)

                // Streak & Trophy Row
                streakTrophyRow
                    .padding(.horizontal, DesignSystem.Spacing.screenMargin)
                    .padding(.bottom, DesignSystem.Spacing.xxl)

                // Statistics
                achievementStats
                    .padding(.horizontal, DesignSystem.Spacing.screenMargin)
                    .padding(.bottom, DesignSystem.Spacing.xxxl)
            }
        }
        .background(DesignSystem.Colors.screenBackground)
        .onAppear {
            withAnimation(.easeOut(duration: 0.3)) {
                showContent = true
            }
        }
    }

    // MARK: - Profile Header
    private var profileHeader: some View {
        VStack(spacing: DesignSystem.Spacing.md) {
            // Simple avatar
            Circle()
                .fill(DesignSystem.Colors.surfaceSecondary)
                .frame(width: 80, height: 80)
                .overlay {
                    Image(systemName: "person")
                        .font(.system(size: 32, weight: .light))
                        .foregroundStyle(DesignSystem.Colors.textTertiary)
                }

            // Username and level
            if let profile = appState.userProfile {
                VStack(spacing: DesignSystem.Spacing.xs) {
                    Text(profile.username)
                        .font(.system(size: 24, weight: .semibold, design: .default))
                        .foregroundStyle(DesignSystem.Colors.textPrimary)

                    Text("Level \(profile.currentLevel)")
                        .font(DesignSystem.Typography.body())
                        .foregroundStyle(DesignSystem.Colors.textSecondary)
                }
            }
        }
        .opacity(showContent ? 1 : 0)
    }

    // MARK: - Screen Title
    private var screenTitle: some View {
        Text("Profile")
            .font(DesignSystem.Typography.viewTitle())
            .foregroundStyle(DesignSystem.Colors.textPrimary)
            .padding(.leading, 2)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, DesignSystem.Spacing.xl)
            .padding(.horizontal, DesignSystem.Spacing.screenMargin)
            .padding(.bottom, DesignSystem.Spacing.lg)
            .opacity(showContent ? 1 : 0)
    }

    // MARK: - XP Progress Card
    private var xpProgressCard: some View {
        VStack(spacing: DesignSystem.Spacing.lg) {
            if let profile = appState.userProfile {
                // Header
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Experience")
                            .font(DesignSystem.Typography.caption(.medium))
                            .foregroundStyle(DesignSystem.Colors.textTertiary)
                            .textCase(.uppercase)
                            .tracking(0.5)

                        Text("\(profile.currentXP) XP")
                            .font(.system(size: 28, weight: .bold, design: .default))
                            .foregroundStyle(DesignSystem.Colors.textPrimary)
                    }

                    Spacer()

                    VStack(alignment: .trailing, spacing: 4) {
                        Text("Next level")
                            .font(DesignSystem.Typography.caption())
                            .foregroundStyle(DesignSystem.Colors.textTertiary)

                        Text("\(profile.nextLevelXP) XP")
                            .font(DesignSystem.Typography.body(.medium))
                            .foregroundStyle(DesignSystem.Colors.textSecondary)
                    }
                }

                // Progress bar - minimal, single color
                let progressPercent = min(Double(profile.currentXP) / Double(profile.nextLevelXP), 1.0)

                VStack(spacing: DesignSystem.Spacing.xs) {
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 3, style: .continuous)
                                .fill(DesignSystem.Colors.borderDefault)

                            RoundedRectangle(cornerRadius: 3, style: .continuous)
                                .fill(DesignSystem.Colors.textSecondary)
                                .frame(width: geometry.size.width * progressPercent)
                        }
                    }
                    .frame(height: 6)

                    HStack {
                        Text("\(Int(progressPercent * 100))% to Level \(profile.currentLevel + 1)")
                            .font(DesignSystem.Typography.caption())
                            .foregroundStyle(DesignSystem.Colors.textTertiary)

                        Spacer()
                    }
                }
            }
        }
        .padding(DesignSystem.Spacing.xl)
        .background(DesignSystem.Colors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Effects.radiusMedium, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: DesignSystem.Effects.radiusMedium, style: .continuous)
                .strokeBorder(DesignSystem.Colors.borderDefault, lineWidth: 1)
        )
        .opacity(showContent ? 1 : 0)
    }

    // MARK: - Streak & Trophy Row
    private var streakTrophyRow: some View {
        HStack(spacing: DesignSystem.Spacing.md) {
            if let profile = appState.userProfile {
                // Current Streak
                VStack(spacing: DesignSystem.Spacing.sm) {
                    Image(systemName: "flame")
                        .font(.system(size: 24, weight: .regular))
                        .foregroundStyle(DesignSystem.Colors.textSecondary)

                    Text("\(profile.currentStreak)")
                        .font(.system(size: 24, weight: .semibold, design: .default))
                        .foregroundStyle(DesignSystem.Colors.textPrimary)

                    Text("Day Streak")
                        .font(DesignSystem.Typography.caption())
                        .foregroundStyle(DesignSystem.Colors.textTertiary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, DesignSystem.Spacing.lg)
                .background(DesignSystem.Colors.cardBackground)
                .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Effects.radiusMedium, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: DesignSystem.Effects.radiusMedium, style: .continuous)
                        .strokeBorder(DesignSystem.Colors.borderDefault, lineWidth: 1)
                )

                // Best Streak
                VStack(spacing: DesignSystem.Spacing.sm) {
                    Image(systemName: "trophy")
                        .font(.system(size: 24, weight: .regular))
                        .foregroundStyle(DesignSystem.Colors.textSecondary)

                    Text("\(profile.longestStreak)")
                        .font(.system(size: 24, weight: .semibold, design: .default))
                        .foregroundStyle(DesignSystem.Colors.textPrimary)

                    Text("Best Streak")
                        .font(DesignSystem.Typography.caption())
                        .foregroundStyle(DesignSystem.Colors.textTertiary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, DesignSystem.Spacing.lg)
                .background(DesignSystem.Colors.cardBackground)
                .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Effects.radiusMedium, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: DesignSystem.Effects.radiusMedium, style: .continuous)
                        .strokeBorder(DesignSystem.Colors.borderDefault, lineWidth: 1)
                )
            }
        }
        .opacity(showContent ? 1 : 0)
    }

    // MARK: - Achievement Stats
    private var achievementStats: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
            Text("Statistics")
                .font(DesignSystem.Typography.caption(.medium))
                .foregroundStyle(DesignSystem.Colors.textTertiary)
                .textCase(.uppercase)
                .tracking(0.5)

            if let profile = appState.userProfile {
                VStack(spacing: 0) {
                    ProfileStatRow(
                        icon: "questionmark.circle",
                        iconColor: DesignSystem.Colors.textSecondary,
                        title: "Questions Answered",
                        value: "\(profile.totalQuestionsAnswered)"
                    )

                    Divider()
                        .padding(.horizontal, DesignSystem.Spacing.md)

                    ProfileStatRow(
                        icon: "checkmark.circle",
                        iconColor: DesignSystem.Colors.textSecondary,
                        title: "Correct Answers",
                        value: "\(profile.totalCorrectAnswers)"
                    )

                    Divider()
                        .padding(.horizontal, DesignSystem.Spacing.md)

                    ProfileStatRow(
                        icon: "percent",
                        iconColor: DesignSystem.Colors.textSecondary,
                        title: "Accuracy Rate",
                        value: "\(Int(profile.accuracyRate * 100))%"
                    )

                    Divider()
                        .padding(.horizontal, DesignSystem.Spacing.md)

                    ProfileStatRow(
                        icon: "medal",
                        iconColor: DesignSystem.Colors.textSecondary,
                        title: "Badges Earned",
                        value: "\(profile.earnedBadges.count)"
                    )
                }
                .background(DesignSystem.Colors.cardBackground)
                .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Effects.radiusMedium, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: DesignSystem.Effects.radiusMedium, style: .continuous)
                        .strokeBorder(DesignSystem.Colors.borderDefault, lineWidth: 1)
                )
            }
        }
        .opacity(showContent ? 1 : 0)
    }
}

// MARK: - Profile Stat Row Component

struct ProfileStatRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    let value: String

    var body: some View {
        HStack(spacing: DesignSystem.Spacing.md) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .regular))
                .foregroundStyle(iconColor)
                .frame(width: 28)

            Text(title)
                .font(DesignSystem.Typography.body())
                .foregroundStyle(DesignSystem.Colors.textPrimary)

            Spacer()

            Text(value)
                .font(.system(size: 15, weight: .medium, design: .default))
                .foregroundStyle(DesignSystem.Colors.textPrimary)
        }
        .padding(.horizontal, DesignSystem.Spacing.lg)
        .padding(.vertical, DesignSystem.Spacing.md)
    }
}

// MARK: - Legacy Component

struct StatRow: View {
    let title: String
    let value: String

    var body: some View {
        ProfileStatRow(
            icon: "circle",
            iconColor: DesignSystem.Colors.textSecondary,
            title: title,
            value: value
        )
    }
}

#Preview {
    NavigationStack {
        ProfileView()
    }
    .environment(AppState())
    .modelContainer(for: [UserProfile.self])
}
