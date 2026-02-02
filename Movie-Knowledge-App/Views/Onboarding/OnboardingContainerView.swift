//
//  OnboardingContainerView.swift
//  Movie-Knowledge-App
//
//  Created by Ben Simpson on 29/1/2026.
//

import SwiftUI
import SwiftData

struct OnboardingContainerView: View {
    @Environment(\.modelContext) private var context
    @Environment(AppState.self) private var appState

    @State private var currentStep: OnboardingStep = .welcome
    @State private var selectedInterests: Set<String> = []
    @State private var selectedDailyGoal: Int = 5

    enum OnboardingStep: Int, CaseIterable {
        case welcome = 0
        case interests = 1
        case dailyGoal = 2
        case notifications = 3
    }

    var body: some View {
        ZStack {
            // Background
            DesignSystem.Colors.screenBackground
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Progress indicator
                if currentStep != .welcome {
                    progressIndicator
                        .padding(.horizontal, 24)
                        .padding(.top, 16)
                }

                // Current step content
                Group {
                    switch currentStep {
                    case .welcome:
                        WelcomeView(onContinue: { advanceStep() })

                    case .interests:
                        InterestPickerView(
                            selectedInterests: $selectedInterests,
                            onContinue: { advanceStep() }
                        )

                    case .dailyGoal:
                        DailyGoalView(
                            selectedGoal: $selectedDailyGoal,
                            onContinue: { advanceStep() }
                        )

                    case .notifications:
                        NotificationPermissionView(
                            onContinue: { completeOnboarding() },
                            onSkip: { completeOnboarding() }
                        )
                    }
                }
                .transition(.asymmetric(
                    insertion: .move(edge: .trailing).combined(with: .opacity),
                    removal: .move(edge: .leading).combined(with: .opacity)
                ))
            }
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: currentStep)
    }

    // MARK: - Progress Indicator

    private var progressIndicator: some View {
        HStack(spacing: 8) {
            ForEach(1..<OnboardingStep.allCases.count, id: \.self) { step in
                Capsule()
                    .fill(step <= currentStep.rawValue ? DesignSystem.Colors.primaryButton : DesignSystem.Colors.borderDefault)
                    .frame(height: 4)
            }
        }
    }

    // MARK: - Navigation

    private func advanceStep() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            if let nextStep = OnboardingStep(rawValue: currentStep.rawValue + 1) {
                currentStep = nextStep
            }
        }
    }

    private func completeOnboarding() {
        // Save preferences
        if let preferences = appState.userPreferences {
            preferences.selectedInterests = Array(selectedInterests)
            preferences.dailyGoal = selectedDailyGoal
            preferences.hasCompletedOnboarding = true
        }

        // Update AppState
        appState.completeOnboarding(context: context)

        // Trigger haptic feedback
        HapticManager.shared.success()
    }
}

#Preview {
    OnboardingContainerView()
        .environment(AppState())
}
