//
//  HomeView.swift
//  Movie-Knowledge-App
//
//  Created by Ben Simpson on 29/1/2026.
//  Gamified daily topic screen with stats and progress
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.modelContext) private var context

    @State private var dailyFocus: DailyFocus?

    var body: some View {
        ZStack {
            // Warm off-white background
            DesignSystem.Colors.screenBackground
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Header with stats
                headerSection
                    .padding(.top, 16)
                    .padding(.horizontal, 20)

                // XP Progress bar
                xpProgressSection
                    .padding(.top, 12)
                    .padding(.horizontal, 20)

                Spacer()

                // Enhanced topic card
                dailyTopicCard
                    .padding(.horizontal, 20)

                Spacer()

                // Primary action button
                startLearningButton
                    .padding(.horizontal, 20)
                    .padding(.bottom, 24)
            }
        }
        .navigationDestination(isPresented: Binding(
            get: { appState.isQuizActive },
            set: { if !$0 { appState.endQuiz() } }
        )) {
            if let activeSubCategory = appState.activeSubCategory {
                QuizView(
                    subCategory: activeSubCategory,
                    appState: appState,
                    context: context
                )
                .environment(appState)
            }
        }
        .onAppear {
            loadDailyFocus()
        }
        .onChange(of: appState.isQuizActive) { _, isActive in
            if !isActive {
                loadDailyFocus()
            }
        }
    }

    // MARK: - Header with Stats

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Title row with streak badge
            HStack(alignment: .top) {
                Text("Movie Knowledge App")
                    .font(DesignSystem.Typography.viewTitle())
                    .foregroundStyle(DesignSystem.Colors.textPrimary)
                    .padding(.leading, 3)

                Spacer()

                if userStreak > 0 {
                    StreakBadge(streak: userStreak)
                }
            }

            // Level and XP
            Text("Level \(userLevel) \u{2022} \(userXP) XP")
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(DesignSystem.Colors.textSecondary)
        }
    }

    // MARK: - XP Progress Bar

    private var xpProgressSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    // Background track
                    RoundedRectangle(cornerRadius: 4)
                        .fill(DesignSystem.Colors.surfaceSecondary)
                        .frame(height: 8)

                    // Progress fill
                    RoundedRectangle(cornerRadius: 4)
                        .fill(DesignSystem.Colors.accent)
                        .frame(width: geo.size.width * xpProgress, height: 8)
                }
            }
            .frame(height: 8)

            // Progress text
            Text("\(xpToNextLevel) XP to Level \(userLevel + 1)")
                .font(.system(size: 12, weight: .regular))
                .foregroundStyle(DesignSystem.Colors.textTertiary)
        }
    }

    // MARK: - Daily Topic Card

    private var dailyTopicCard: some View {
        Button(action: startTodaySession) {
            VStack(alignment: .leading, spacing: 0) {
                // Category with color accent bar
                HStack(spacing: 8) {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(categoryAccentColor)
                        .frame(width: 4, height: 20)

                    Text(categoryName.uppercased())
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(categoryAccentColor)
                        .kerning(0.8)
                }
                .padding(.bottom, 16)

                // Topic title (larger, bolder)
                Text(topicTitle)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(DesignSystem.Colors.textPrimary)
                    .padding(.bottom, 16)

                // Key facts with film icons
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(Array(keyFacts.enumerated()), id: \.offset) { index, fact in
                        HStack(alignment: .top, spacing: 12) {
                            Image(systemName: factIcon(for: index))
                                .font(.system(size: 16))
                                .foregroundStyle(categoryAccentColor.opacity(0.8))
                                .frame(width: 20)

                            Text(fact)
                                .font(.system(size: 15, weight: .regular))
                                .foregroundStyle(DesignSystem.Colors.textPrimary)
                                .lineSpacing(4)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }

                // Divider
                Rectangle()
                    .fill(DesignSystem.Colors.borderDefault)
                    .frame(height: 1)
                    .padding(.vertical, 16)

                // Quiz metadata
                HStack(spacing: 16) {
                    Label("\(questionCount) questions", systemImage: "list.bullet")
                    Label("~5 min", systemImage: "clock")
                }
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(DesignSystem.Colors.textTertiary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(24)
            .background(DesignSystem.Colors.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .shadow(
                color: Color.black.opacity(0.06),
                radius: 12,
                x: 0,
                y: 4
            )
        }
        .buttonStyle(.plain)
        .disabled(!canStartFocus)
        .opacity(canStartFocus ? 1.0 : 0.7)
    }

    // MARK: - Start Learning Button

    private var startLearningButton: some View {
        Button(action: startTodaySession) {
            Text(buttonTitle)
                .depthButtonLabel(font: .system(size: 17, weight: .semibold))
        }
        .buttonStyle(DepthButtonStyle(cornerRadius: 14))
        .disabled(!canStartFocus)
        .opacity(canStartFocus ? 1.0 : 0.7)
    }

    // MARK: - Helper Functions

    private func factIcon(for index: Int) -> String {
        let icons = ["film", "star", "sparkles", "play.circle"]
        return icons[index % icons.count]
    }

    // MARK: - User Stats Computed Properties

    private var userLevel: Int {
        appState.userProfile?.currentLevel ?? 1
    }

    private var userXP: Int {
        appState.userProfile?.currentXP ?? 0
    }

    private var userStreak: Int {
        appState.userProfile?.currentStreak ?? 0
    }

    private var xpProgress: Double {
        appState.userProfile?.progressToNextLevel ?? 0
    }

    private var xpToNextLevel: Int {
        let next = appState.userProfile?.nextLevelXP ?? 100
        return max(0, next - userXP)
    }

    private var questionCount: Int {
        dailyFocus?.subCategory.challenges.count ?? 10
    }

    // MARK: - Daily Focus Computed Properties

    private var canStartFocus: Bool {
        guard let focus = dailyFocus else { return false }
        return !focus.isCompleted && !focus.isComingSoon
    }

    private var categoryName: String {
        dailyFocus?.category.title ?? "Today"
    }

    private var categoryAccentColor: Color {
        guard let focus = dailyFocus else {
            return DesignSystem.Colors.textSecondary
        }
        return Color(
            red: focus.category.colorRed,
            green: focus.category.colorGreen,
            blue: focus.category.colorBlue
        )
    }

    private var topicTitle: String {
        if dailyFocus?.isCompleted == true {
            return "All set for today"
        }
        return dailyFocus?.subCategory.title ?? "No topic available"
    }

    private var keyFacts: [String] {
        if dailyFocus?.isCompleted == true {
            return [
                "You've completed today's session",
                "Come back tomorrow for a new topic",
                "Keep your streak going!"
            ]
        }

        guard let facts = dailyFocus?.subCategory.keyFacts, !facts.isEmpty else {
            return [
                "Learn something new about film",
                "Test your knowledge with a quiz",
                "Build your movie expertise"
            ]
        }

        return Array(facts.prefix(4))
    }

    private var buttonTitle: String {
        if dailyFocus?.isCompleted == true {
            return "Come back tomorrow"
        }
        if dailyFocus?.isComingSoon == true {
            return "Coming soon"
        }
        return "Start learning"
    }

    // MARK: - Actions

    private func startTodaySession() {
        guard let focus = dailyFocus, canStartFocus else { return }
        HapticManager.shared.medium()
        appState.startQuiz(for: focus.subCategory)
    }

    private func loadDailyFocus() {
        guard let profile = appState.userProfile else {
            print("HomeView: No user profile available")
            return
        }
        let focusService = DailyFocusService(context: context)
        dailyFocus = focusService.getTodayFocus(for: profile)
        print("HomeView: Loaded daily focus - \(dailyFocus?.subCategory.title ?? "nil")")
    }
}

private struct StreakBadge: View {
    let streak: Int

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: "flame.fill")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(DesignSystem.Colors.accent)

            Text("\(streak)")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(DesignSystem.Colors.textPrimary)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(DesignSystem.Colors.surfaceSecondary)
        .clipShape(Capsule())
        .overlay(
            Capsule()
                .stroke(DesignSystem.Colors.borderDefault, lineWidth: 1)
        )
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
    .environment(AppState())
    .modelContainer(for: [UserProfile.self, CategoryModel.self, SubCategory.self])
}
