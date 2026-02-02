//
//  ResultsView.swift
//  Movie-Knowledge-App
//
//  Created by Ben Simpson on 29/1/2026.
//  Minimal, clean results view design
//

import SwiftUI
import SwiftData

struct ResultsView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var viewModel: QuizViewModel

    @State private var showContent = false
    @State private var showWrongAnswers: Bool = false

    private var earnedXP: Int {
        var totalXP = 0
        for (index, isCorrect) in viewModel.correctAnswers.enumerated() {
            if isCorrect, index < viewModel.challenges.count {
                totalXP += viewModel.challenges[index].xpReward
            }
        }
        return totalXP
    }

    private var accuracyPercentage: Int {
        Int(viewModel.accuracyRate * 100)
    }

    private var isGameOver: Bool {
        viewModel.isGameOver
    }

    private var performanceMessage: String {
        if isGameOver { return "Out of lives" }
        switch accuracyPercentage {
        case 90...100: return "Outstanding"
        case 70..<90: return "Great job"
        case 50..<70: return "Good effort"
        default: return "Keep practicing"
        }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Spacer(minLength: 40)

                // Result icon - simple, minimal
                Image(systemName: isGameOver ? "xmark.circle" : "checkmark.circle")
                    .font(.system(size: 56, weight: .light))
                    .foregroundStyle(DesignSystem.Colors.textSecondary)

                // Performance message
                Text(performanceMessage)
                    .font(.system(size: 24, weight: .semibold, design: .default))
                    .foregroundStyle(DesignSystem.Colors.textPrimary)

                // Score card - clean, minimal
                VStack(spacing: 16) {
                    Text("\(viewModel.correctCount)/\(viewModel.totalQuestions)")
                        .font(.system(size: 40, weight: .bold, design: .default))
                        .foregroundStyle(DesignSystem.Colors.textPrimary)

                    Text("Questions correct")
                        .font(DesignSystem.Typography.body())
                        .foregroundStyle(DesignSystem.Colors.textSecondary)

                    // Accuracy
                    Text("\(accuracyPercentage)% accuracy")
                        .font(DesignSystem.Typography.caption())
                        .foregroundStyle(DesignSystem.Colors.textTertiary)
                }
                .padding(24)
                .frame(maxWidth: .infinity)
                .background(DesignSystem.Colors.cardBackground)
                .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Effects.radiusMedium, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: DesignSystem.Effects.radiusMedium, style: .continuous)
                        .strokeBorder(DesignSystem.Colors.borderDefault, lineWidth: 1)
                )

                // XP earned - simple text
                VStack(spacing: 8) {
                    Text("+\(earnedXP) XP")
                        .font(.system(size: 22, weight: .semibold, design: .default))
                        .foregroundStyle(DesignSystem.Colors.textPrimary)

                    Text("Experience earned")
                        .font(DesignSystem.Typography.caption())
                        .foregroundStyle(DesignSystem.Colors.textTertiary)
                }
                .padding(20)
                .frame(maxWidth: .infinity)
                .background(DesignSystem.Colors.surfaceSecondary)
                .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Effects.radiusMedium, style: .continuous))

                // Wrong Answers Section
                if viewModel.canRetryMistakes {
                    wrongAnswersSection
                }

                // Action buttons
                VStack(spacing: 12) {
                    Button(action: { dismiss() }) {
                        Text("Continue")
                            .font(DesignSystem.Typography.body(.medium))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(DesignSystem.Colors.primaryButton)
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    }

                    if viewModel.canRetryMistakes {
                        Button(action: {
                            if let _ = viewModel.createRetryQuiz() {
                                viewModel.resetQuiz()
                            }
                        }) {
                            Text("Retry mistakes (\(viewModel.wrongAnswerChallenges.count))")
                                .font(DesignSystem.Typography.body(.medium))
                                .foregroundStyle(DesignSystem.Colors.textSecondary)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(DesignSystem.Colors.cardBackground)
                                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .strokeBorder(DesignSystem.Colors.borderDefault, lineWidth: 1)
                                )
                        }
                    }

                    Button(action: { viewModel.resetQuiz() }) {
                        Text("Try again")
                            .font(DesignSystem.Typography.body(.medium))
                            .foregroundStyle(DesignSystem.Colors.accent)
                    }
                    .padding(.top, 4)
                }
                .padding(.top, 8)

                Spacer(minLength: DesignSystem.Dimensions.tabSafeBottomPadding)
            }
            .padding(24)
        }
        .background(DesignSystem.Colors.screenBackground)
        .onAppear {
            withAnimation(.easeOut(duration: 0.3)) {
                showContent = true
            }

            if isGameOver {
                HapticManager.shared.error()
            } else if accuracyPercentage >= 90 {
                HapticManager.shared.success()
            }
        }
    }

    // MARK: - Wrong Answers Section
    private var wrongAnswersSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Button(action: {
                withAnimation(.easeOut(duration: 0.2)) {
                    showWrongAnswers.toggle()
                }
            }) {
                HStack {
                    Text("Review mistakes")
                        .font(DesignSystem.Typography.body(.medium))
                        .foregroundStyle(DesignSystem.Colors.textPrimary)

                    Spacer()

                    Image(systemName: showWrongAnswers ? "chevron.up" : "chevron.down")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(DesignSystem.Colors.textTertiary)
                }
            }

            if showWrongAnswers {
                VStack(spacing: 8) {
                    ForEach(viewModel.wrongAnswerChallenges) { challenge in
                        WrongAnswerRow(challenge: challenge)
                    }
                }
            }
        }
        .padding(16)
        .background(DesignSystem.Colors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Effects.radiusMedium, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: DesignSystem.Effects.radiusMedium, style: .continuous)
                .strokeBorder(DesignSystem.Colors.borderDefault, lineWidth: 1)
        )
    }
}

// MARK: - Wrong Answer Row

struct WrongAnswerRow: View {
    let challenge: Challenge

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(challenge.questionText)
                .font(DesignSystem.Typography.caption())
                .foregroundStyle(DesignSystem.Colors.textPrimary)
                .lineLimit(2)

            Text("Answer: \(challenge.correctAnswer)")
                .font(DesignSystem.Typography.caption())
                .foregroundStyle(DesignSystem.Colors.textSecondary)

            if let explanation = challenge.explanation {
                Text(explanation)
                    .font(.system(size: 12))
                    .foregroundStyle(DesignSystem.Colors.textTertiary)
                    .lineLimit(2)
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(DesignSystem.Colors.surfaceSecondary)
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}

#Preview {
    do {
        let container = try ModelContainer(for: CategoryModel.self)
        let context = ModelContext(container)
        let appState = AppState()
        let subCategory = SubCategory(title: "Test", descriptionText: "Test", displayOrder: 0)
        let viewModel = QuizViewModel(
            subCategory: subCategory,
            context: context,
            appState: appState
        )
        viewModel.correctAnswers = [true, true, false, true, true, false, true, true, true, false]

        return ResultsView(viewModel: viewModel)
    } catch {
        return Text("Preview Error: \(error.localizedDescription)")
    }
}
