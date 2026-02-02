//
//  QuizView.swift
//  Movie-Knowledge-App
//
//  Created by Ben Simpson on 29/1/2026.
//  Minimal, clean quiz view design
//

import SwiftUI
import SwiftData

struct QuizView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    @State private var viewModel: QuizViewModel
    @State private var showContent = false

    init(subCategory: SubCategory, appState: AppState, context: ModelContext) {
        _viewModel = State(initialValue: QuizViewModel(
            subCategory: subCategory,
            context: context,
            appState: appState
        ))
    }

    var body: some View {
        ZStack {
            DesignSystem.Colors.screenBackground
                .ignoresSafeArea()

            if viewModel.isQuizComplete || viewModel.isGameOver {
                ResultsView(viewModel: viewModel)
            } else {
                VStack(spacing: 0) {
                    // Header
                    quizHeader

                    // Question content
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: DesignSystem.Spacing.xl) {
                            if let challenge = viewModel.currentChallenge {
                                questionSection(challenge: challenge)
                                answerSection(challenge: challenge)
                            }

                            Spacer(minLength: 100)
                        }
                        .padding(DesignSystem.Spacing.xl)
                    }
                    .opacity(showContent ? 1 : 0)

                    // Feedback overlay
                    if viewModel.showFeedback {
                        feedbackCard
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
                .animation(DesignSystem.Animations.smooth, value: viewModel.showFeedback)
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            withAnimation(.easeOut(duration: 0.2)) {
                showContent = true
            }
        }
    }

    // MARK: - Quiz Header
    private var quizHeader: some View {
        VStack(spacing: DesignSystem.Spacing.sm) {
            HStack {
                // Exit button
                Button(action: {
                    HapticManager.shared.light()
                    dismiss()
                }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(DesignSystem.Colors.textSecondary)
                        .frame(width: 36, height: 36)
                        .background(
                            Circle()
                                .fill(DesignSystem.Colors.surfaceSecondary)
                        )
                }

                Spacer()

                // Lives indicator
                LivesIndicator(livesRemaining: viewModel.livesRemaining)

                Spacer()

                // Question counter
                HStack(spacing: 4) {
                    Text("\(viewModel.currentQuestionIndex + 1)")
                        .font(.system(size: 15, weight: .semibold, design: .default))
                        .foregroundStyle(DesignSystem.Colors.textPrimary)
                    Text("/")
                        .foregroundStyle(DesignSystem.Colors.textTertiary)
                    Text("\(viewModel.totalQuestions)")
                        .font(.system(size: 15, weight: .medium, design: .default))
                        .foregroundStyle(DesignSystem.Colors.textSecondary)
                }
            }
            .padding(.horizontal, DesignSystem.Spacing.xl)
            .padding(.top, DesignSystem.Spacing.md)

            // Progress dots
            progressDots
                .padding(.horizontal, DesignSystem.Spacing.xl)
        }
        .padding(.bottom, DesignSystem.Spacing.md)
        .background(DesignSystem.Colors.cardBackground)
    }

    // MARK: - Progress Dots
    private var progressDots: some View {
        HStack(spacing: 4) {
            ForEach(0..<viewModel.totalQuestions, id: \.self) { index in
                Circle()
                    .fill(dotColor(for: index))
                    .frame(width: 8, height: 8)
            }
        }
    }

    private func dotColor(for index: Int) -> Color {
        if index < viewModel.correctAnswers.count {
            return viewModel.correctAnswers[index]
                ? DesignSystem.Colors.successGreen
                : DesignSystem.Colors.errorRed
        } else if index == viewModel.currentQuestionIndex {
            return DesignSystem.Colors.textPrimary
        } else {
            return DesignSystem.Colors.borderDefault
        }
    }

    // MARK: - Question Section
    private func questionSection(challenge: Challenge) -> some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
            // Difficulty - text only
            Text(challenge.difficulty.rawValue.capitalized)
                .font(.system(size: 11, weight: .medium, design: .default))
                .foregroundStyle(DesignSystem.Colors.textTertiary)
                .textCase(.uppercase)
                .tracking(0.5)

            // Question text
            Text(challenge.questionText)
                .font(.system(size: 20, weight: .semibold, design: .default))
                .foregroundStyle(DesignSystem.Colors.textPrimary)
                .fixedSize(horizontal: false, vertical: true)
                .lineSpacing(4)
        }
    }

    // MARK: - Answer Section
    private func answerSection(challenge: Challenge) -> some View {
        Group {
            switch challenge.questionType {
            case .multipleChoice:
                MultipleChoiceView(
                    challenge: challenge,
                    onAnswer: { answer in
                        viewModel.submitAnswer(answer)
                    }
                )
                .disabled(viewModel.showFeedback)

            case .trueFalse:
                TrueFalseView(
                    challenge: challenge,
                    onAnswer: { answer in
                        viewModel.submitAnswer(answer)
                    }
                )
                .disabled(viewModel.showFeedback)

            case .fillBlank:
                FillBlankView(
                    challenge: challenge,
                    onAnswer: { answer in
                        viewModel.submitAnswer(answer)
                    }
                )
                .disabled(viewModel.showFeedback)

            case .pickYear:
                PickYearView(
                    challenge: challenge,
                    onAnswer: { answer in
                        viewModel.submitAnswer(answer)
                    }
                )
                .disabled(viewModel.showFeedback)

            case .matchDirector:
                MatchDirectorView(
                    challenge: challenge,
                    onAnswer: { answer in
                        viewModel.submitAnswer(answer)
                    }
                )
                .disabled(viewModel.showFeedback)
            }
        }
    }

    // MARK: - Feedback Card
    private var feedbackCard: some View {
        VStack(spacing: DesignSystem.Spacing.lg) {
            // Result indicator
            HStack(spacing: DesignSystem.Spacing.md) {
                // Simple icon
                Image(systemName: viewModel.isCorrect ? "checkmark.circle" : "xmark.circle")
                    .font(.system(size: 28, weight: .regular))
                    .foregroundStyle(viewModel.isCorrect
                        ? DesignSystem.Colors.successGreen
                        : DesignSystem.Colors.errorRed)

                VStack(alignment: .leading, spacing: 2) {
                    Text(viewModel.isCorrect ? "Correct" : "Incorrect")
                        .font(.system(size: 18, weight: .semibold, design: .default))
                        .foregroundStyle(DesignSystem.Colors.textPrimary)

                    if !viewModel.isCorrect, let challenge = viewModel.currentChallenge {
                        Text("Answer: \(challenge.correctAnswer)")
                            .font(DesignSystem.Typography.caption())
                            .foregroundStyle(DesignSystem.Colors.textSecondary)
                    } else if viewModel.isCorrect, let challenge = viewModel.currentChallenge {
                        Text("+\(challenge.xpReward) XP")
                            .font(DesignSystem.Typography.caption())
                            .foregroundStyle(DesignSystem.Colors.textSecondary)
                    }
                }

                Spacer()
            }

            // Explanation
            if let challenge = viewModel.currentChallenge,
               let explanation = challenge.explanation {
                Text(explanation)
                    .font(DesignSystem.Typography.body())
                    .foregroundStyle(DesignSystem.Colors.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(DesignSystem.Spacing.md)
                    .background(DesignSystem.Colors.surfaceSecondary)
                    .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Effects.radiusSmall, style: .continuous))
            }

            // Next button
            Button(action: {
                HapticManager.shared.medium()
                withAnimation(.easeOut(duration: 0.2)) {
                    viewModel.nextQuestion()
                }
            }) {
                Text(viewModel.currentQuestionIndex < viewModel.totalQuestions - 1 ? "Continue" : "See Results")
                    .font(DesignSystem.Typography.body(.medium))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 46)
                    .background(DesignSystem.Colors.primaryButton)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            }
        }
        .padding(.horizontal, DesignSystem.Spacing.xl)
        .padding(.top, DesignSystem.Spacing.xl)
        .padding(.bottom, DesignSystem.Dimensions.tabSafeBottomPadding)
        .background(
            DesignSystem.Colors.cardBackground
                .clipShape(
                    RoundedCorner(radius: DesignSystem.Effects.radiusLarge, corners: [.topLeft, .topRight])
                )
        )
        .overlay(
            RoundedCorner(radius: DesignSystem.Effects.radiusLarge, corners: [.topLeft, .topRight])
                .stroke(DesignSystem.Colors.borderDefault, lineWidth: 1)
        )
    }
}

// MARK: - Custom Corner Radius
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

#Preview {
    let category = CategoryModel(
        title: "Classic Cinema",
        subtitle: "Test",
        colorRed: 0.75,
        colorGreen: 0.68,
        colorBlue: 0.58,
        displayOrder: 0
    )
    let subCategory = SubCategory(
        title: "Test Lesson",
        descriptionText: "Test",
        displayOrder: 0
    )

    return NavigationStack {
        QuizView(
            subCategory: subCategory,
            appState: AppState(),
            context: ModelContext(try! ModelContainer(for: CategoryModel.self))
        )
    }
}
