//
//  HomeView.swift
//  Movie-Knowledge-App
//
//  Created by Ben Simpson on 29/1/2026.
//  Minimal, clean home view design
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.modelContext) private var context

    @State private var recommendedCategories: [CategoryModel] = []
    @State private var todayQuestionsAnswered: Int = 0
    @State private var showContent = false

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                // Header Section
                heroHeader
                    .padding(.bottom, DesignSystem.Spacing.xxl)

                // Daily Goal Card
                dailyGoalCard
                    .padding(.horizontal, DesignSystem.Spacing.screenMargin)
                    .padding(.bottom, DesignSystem.Spacing.xxl)

                // Continue Learning (if available)
                if appState.lastPlayedCategory != nil {
                    continueLearningSection
                        .padding(.horizontal, DesignSystem.Spacing.screenMargin)
                        .padding(.bottom, DesignSystem.Spacing.xxl)
                }

                // Recommended Categories
                if !recommendedCategories.isEmpty {
                    recommendedSection
                        .padding(.bottom, DesignSystem.Spacing.xxl)
                }

                // Stats
                statsSection
                    .padding(.horizontal, DesignSystem.Spacing.screenMargin)
                    .padding(.bottom, DesignSystem.Spacing.xxxl)
            }
        }
        .background(DesignSystem.Colors.screenBackground)
        .onAppear {
            loadRecommendedCategories()
            loadTodayProgress()
            withAnimation(.easeOut(duration: 0.3)) {
                showContent = true
            }
        }
    }

    // MARK: - Hero Header
    private var heroHeader: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.xxs) {
                    Text(greetingText)
                        .font(.system(size: 26, weight: .bold, design: .default))
                        .foregroundStyle(DesignSystem.Colors.textPrimary)

                    if let profile = appState.userProfile {
                        Text("Level \(profile.currentLevel)")
                            .font(DesignSystem.Typography.body())
                            .foregroundStyle(DesignSystem.Colors.textSecondary)
                    }
                }

                Spacer()

                // Minimal streak badge
                if let profile = appState.userProfile, profile.currentStreak > 0 {
                    StreakBadge(streak: profile.currentStreak)
                }
            }
            .padding(.horizontal, DesignSystem.Spacing.screenMargin)
            .padding(.top, DesignSystem.Spacing.md)
        }
        .opacity(showContent ? 1 : 0)
    }

    private var greetingText: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return "Good morning"
        case 12..<17: return "Good afternoon"
        case 17..<21: return "Good evening"
        default: return "Hello"
        }
    }

    // MARK: - Daily Goal Card
    private var dailyGoalCard: some View {
        let dailyGoal = appState.userPreferences?.dailyGoal ?? 5
        let progress = min(Double(todayQuestionsAnswered) / Double(dailyGoal), 1.0)
        let isCompleted = todayQuestionsAnswered >= dailyGoal

        return VStack(spacing: 0) {
            // Content
            HStack(alignment: .top, spacing: DesignSystem.Spacing.lg) {
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
                    Text(isCompleted ? "Complete" : "Today's goal")
                        .font(DesignSystem.Typography.caption(.medium))
                        .foregroundStyle(DesignSystem.Colors.textTertiary)
                        .textCase(.uppercase)
                        .tracking(0.5)

                    Text(isCompleted ? "Great work!" : "Keep going")
                        .font(.system(size: 22, weight: .semibold, design: .default))
                        .foregroundStyle(DesignSystem.Colors.textPrimary)

                    Text("\(todayQuestionsAnswered) of \(dailyGoal) questions")
                        .font(DesignSystem.Typography.body())
                        .foregroundStyle(DesignSystem.Colors.textSecondary)
                }

                Spacer()

                // Minimal progress ring
                ZStack {
                    Circle()
                        .stroke(DesignSystem.Colors.borderDefault, lineWidth: 3)

                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(
                            DesignSystem.Colors.textSecondary,
                            style: StrokeStyle(lineWidth: 3, lineCap: .round)
                        )
                        .rotationEffect(.degrees(-90))

                    Text("\(Int(progress * 100))%")
                        .font(.system(size: 14, weight: .medium, design: .default))
                        .foregroundStyle(DesignSystem.Colors.textSecondary)
                }
                .frame(width: 60, height: 60)
            }
            .padding(DesignSystem.Spacing.xl)

            // CTA Button - solid color, no gradient
            Button(action: {
                HapticManager.shared.medium()
                appState.selectedTab = .categories
            }) {
                HStack(spacing: DesignSystem.Spacing.xs) {
                    Text(isCompleted ? "Continue" : "Start")
                        .font(DesignSystem.Typography.body(.medium))
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 46)
                .background(DesignSystem.Colors.primaryButton)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            }
            .padding(.horizontal, DesignSystem.Spacing.xl)
            .padding(.bottom, DesignSystem.Spacing.xl)
        }
        .background(DesignSystem.Colors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Effects.radiusMedium, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: DesignSystem.Effects.radiusMedium, style: .continuous)
                .strokeBorder(DesignSystem.Colors.borderDefault, lineWidth: 1)
        )
        .opacity(showContent ? 1 : 0)
    }

    // MARK: - Continue Learning
    private var continueLearningSection: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
            Text("Continue")
                .font(DesignSystem.Typography.caption(.medium))
                .foregroundStyle(DesignSystem.Colors.textTertiary)
                .textCase(.uppercase)
                .tracking(0.5)

            if let category = appState.lastPlayedCategory,
               let subCategory = appState.lastPlayedSubCategory {
                Button(action: {
                    HapticManager.shared.medium()
                    appState.activeCategory = category
                    appState.selectedTab = .categories
                }) {
                    HStack(spacing: DesignSystem.Spacing.md) {
                        // Category icon
                        ZStack {
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(category.accentColor.opacity(0.12))
                                .frame(width: 48, height: 48)

                            Image(systemName: category.iconName ?? "film")
                                .font(.system(size: 20, weight: .regular))
                                .foregroundStyle(category.accentColor)
                        }

                        VStack(alignment: .leading, spacing: 2) {
                            Text(category.title)
                                .font(DesignSystem.Typography.body(.medium))
                                .foregroundStyle(DesignSystem.Colors.textPrimary)

                            Text(subCategory.title)
                                .font(DesignSystem.Typography.caption())
                                .foregroundStyle(DesignSystem.Colors.textSecondary)
                        }

                        Spacer()

                        Image(systemName: "arrow.right")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(DesignSystem.Colors.textTertiary)
                    }
                    .padding(DesignSystem.Spacing.md)
                    .background(DesignSystem.Colors.cardBackground)
                    .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Effects.radiusMedium, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: DesignSystem.Effects.radiusMedium, style: .continuous)
                            .strokeBorder(DesignSystem.Colors.borderDefault, lineWidth: 1)
                    )
                }
                .buttonStyle(ScaleButtonStyle())
            }
        }
        .opacity(showContent ? 1 : 0)
    }

    // MARK: - Recommended Section
    private var recommendedSection: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
            HStack {
                Text("Recommended")
                    .font(DesignSystem.Typography.caption(.medium))
                    .foregroundStyle(DesignSystem.Colors.textTertiary)
                    .textCase(.uppercase)
                    .tracking(0.5)

                Spacer()

                Button(action: {
                    appState.selectedTab = .categories
                }) {
                    Text("See all")
                        .font(DesignSystem.Typography.caption(.medium))
                        .foregroundStyle(DesignSystem.Colors.accent)
                }
            }
            .padding(.horizontal, DesignSystem.Spacing.screenMargin)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: DesignSystem.Spacing.md) {
                    ForEach(Array(recommendedCategories.prefix(5).enumerated()), id: \.element.id) { index, category in
                        RecommendedCard(category: category, index: index) {
                            HapticManager.shared.medium()
                            appState.activeCategory = category
                            appState.selectedTab = .categories
                        }
                    }
                }
                .padding(.horizontal, DesignSystem.Spacing.screenMargin)
            }
        }
        .opacity(showContent ? 1 : 0)
    }

    // MARK: - Stats Section
    private var statsSection: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
            Text("Progress")
                .font(DesignSystem.Typography.caption(.medium))
                .foregroundStyle(DesignSystem.Colors.textTertiary)
                .textCase(.uppercase)
                .tracking(0.5)

            if let profile = appState.userProfile {
                LazyVGrid(columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)], spacing: 12) {
                    StatTile(
                        icon: "star",
                        iconColor: DesignSystem.Colors.textSecondary,
                        value: "\(profile.currentXP)",
                        label: "Total XP"
                    )

                    StatTile(
                        icon: "flame",
                        iconColor: DesignSystem.Colors.textSecondary,
                        value: "\(profile.currentStreak)",
                        label: "Day Streak"
                    )

                    StatTile(
                        icon: "checkmark.circle",
                        iconColor: DesignSystem.Colors.textSecondary,
                        value: "\(Int(profile.accuracyRate * 100))%",
                        label: "Accuracy"
                    )

                    StatTile(
                        icon: "questionmark.circle",
                        iconColor: DesignSystem.Colors.textSecondary,
                        value: "\(profile.totalQuestionsAnswered)",
                        label: "Questions"
                    )
                }
            }
        }
        .opacity(showContent ? 1 : 0)
    }

    // MARK: - Data Loading
    private func loadRecommendedCategories() {
        let interests = appState.userPreferences?.selectedInterests ?? []
        let descriptor = FetchDescriptor<CategoryModel>(
            sortBy: [SortDescriptor(\.displayOrder)]
        )

        if let categories = try? context.fetch(descriptor) {
            if interests.isEmpty {
                recommendedCategories = Array(categories.prefix(5))
            } else {
                recommendedCategories = categories.filter { category in
                    let titleLower = category.title.lowercased()
                    return interests.contains { interest in
                        titleLower.contains(interest.lowercased()) ||
                        interest.lowercased().contains(titleLower.prefix(4).lowercased())
                    }
                }
                if recommendedCategories.isEmpty {
                    recommendedCategories = Array(categories.prefix(5))
                }
            }
        }
    }

    private func loadTodayProgress() {
        guard let profile = appState.userProfile else { return }

        let today = Calendar.current.startOfDay(for: Date())
        if let todayRecord = profile.dailyLessonHistory.first(where: {
            Calendar.current.isDate($0.date, inSameDayAs: today)
        }) {
            todayQuestionsAnswered = todayRecord.questionsAnswered
        } else {
            todayQuestionsAnswered = 0
        }
    }
}

// MARK: - Recommended Card Component

struct RecommendedCard: View {
    let category: CategoryModel
    let index: Int
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
                // Icon
                ZStack {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(category.accentColor.opacity(0.12))
                        .frame(width: 40, height: 40)

                    Image(systemName: category.iconName ?? "film")
                        .font(.system(size: 18, weight: .regular))
                        .foregroundStyle(category.accentColor)
                }

                Spacer()

                Text(category.title)
                    .font(DesignSystem.Typography.body(.medium))
                    .foregroundStyle(DesignSystem.Colors.textPrimary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)

                if let tag = category.tag {
                    Text(tag.uppercased())
                        .font(.system(size: 10, weight: .medium, design: .default))
                        .tracking(0.5)
                        .foregroundStyle(DesignSystem.Colors.textTertiary)
                } else {
                    Text(category.subtitle)
                        .font(DesignSystem.Typography.caption())
                        .foregroundStyle(DesignSystem.Colors.textTertiary)
                        .lineLimit(1)
                }
            }
            .frame(width: 130, height: 140)
            .padding(DesignSystem.Spacing.md)
            .background(DesignSystem.Colors.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Effects.radiusMedium, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: DesignSystem.Effects.radiusMedium, style: .continuous)
                    .strokeBorder(DesignSystem.Colors.borderDefault, lineWidth: 1)
            )
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

// MARK: - Stat Tile Component

struct StatTile: View {
    let icon: String
    let iconColor: Color
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: DesignSystem.Spacing.xs) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .regular))
                .foregroundStyle(iconColor)

            Text(value)
                .font(.system(size: 20, weight: .semibold, design: .default))
                .foregroundStyle(DesignSystem.Colors.textPrimary)

            Text(label)
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

// MARK: - Scale Button Style

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}

// MARK: - Legacy Components

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        StatTile(icon: icon, iconColor: DesignSystem.Colors.textSecondary, value: value, label: title)
    }
}

struct RecommendedCategoryCard: View {
    let category: CategoryModel
    let action: () -> Void

    var body: some View {
        RecommendedCard(category: category, index: 0, action: action)
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
    .environment(AppState())
    .modelContainer(for: [UserProfile.self])
}
