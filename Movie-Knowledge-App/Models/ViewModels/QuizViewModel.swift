//
//  QuizViewModel.swift
//  Movie-Knowledge-App
//
//  Created by Ben Simpson on 29/1/2026.
//

import Foundation
import SwiftData
import Observation

@Observable
final class QuizViewModel {
    // Dependencies
    private let context: ModelContext
    private let appState: AppState

    // Quiz data
    let subCategory: SubCategory
    let challenges: [Challenge]

    // Current state
    var currentQuestionIndex: Int = 0
    var userAnswers: [String] = []
    var correctAnswers: [Bool] = []
    var showFeedback: Bool = false
    var isCorrect: Bool = false
    var isQuizComplete: Bool = false

    // Lives system
    var livesRemaining: Int = 3
    var isGameOver: Bool = false

    // Wrong answers for retry
    var wrongAnswerChallenges: [Challenge] = []

    // Computed properties
    var currentChallenge: Challenge? {
        guard currentQuestionIndex < challenges.count else { return nil }
        return challenges[currentQuestionIndex]
    }

    var progress: Double {
        guard !challenges.isEmpty else { return 0 }
        return Double(currentQuestionIndex) / Double(challenges.count)
    }

    var correctCount: Int {
        correctAnswers.filter { $0 }.count
    }

    var totalQuestions: Int {
        challenges.count
    }

    var accuracyRate: Double {
        guard !correctAnswers.isEmpty else { return 0 }
        return Double(correctCount) / Double(correctAnswers.count)
    }

    init(subCategory: SubCategory, context: ModelContext, appState: AppState) {
        self.subCategory = subCategory
        self.challenges = subCategory.challenges.shuffled() // Randomize order
        self.context = context
        self.appState = appState
    }

    // MARK: - Answer Handling

    func submitAnswer(_ answer: String) {
        guard let challenge = currentChallenge else { return }

        // Validate answer
        let correct = validateAnswer(answer, for: challenge)

        // Store results
        userAnswers.append(answer)
        correctAnswers.append(correct)
        isCorrect = correct

        // Haptic feedback
        if correct {
            HapticManager.shared.success()
        } else {
            HapticManager.shared.error()
            // Track wrong answers and reduce lives
            wrongAnswerChallenges.append(challenge)
            livesRemaining -= 1

            // Check for game over
            if livesRemaining <= 0 {
                isGameOver = true
            }
        }

        // Show feedback
        showFeedback = true
    }

    private func validateAnswer(_ answer: String, for challenge: Challenge) -> Bool {
        let normalizedAnswer = answer.trimmingCharacters(in: .whitespaces).lowercased()
        let normalizedCorrect = challenge.correctAnswer.trimmingCharacters(in: .whitespaces).lowercased()

        return normalizedAnswer == normalizedCorrect
    }

    // MARK: - Navigation

    func nextQuestion() {
        showFeedback = false

        // Check for game over
        if isGameOver {
            completeQuiz()
            return
        }

        if currentQuestionIndex < challenges.count - 1 {
            currentQuestionIndex += 1
        } else {
            // Quiz complete
            completeQuiz()
        }
    }

    func skipQuestion() {
        // Mark as incorrect and move on
        if currentChallenge != nil {
            userAnswers.append("")
            correctAnswers.append(false)
        }
        nextQuestion()
    }

    // MARK: - Quiz Completion

    private func completeQuiz() {
        isQuizComplete = true

        guard let profile = appState.userProfile else { return }

        // Calculate XP
        let earnedXP = calculateXP()

        // Update profile stats
        profile.totalQuestionsAnswered += totalQuestions
        profile.totalCorrectAnswers += correctCount

        // Award XP
        if let xpService = appState.xpService {
            xpService.awardXP(earnedXP, to: profile)
        }

        // Update streak and record daily lesson
        if let streakService = appState.streakService {
            streakService.recordDailyLesson(
                for: profile,
                questionsAnswered: totalQuestions,
                correctAnswers: correctCount,
                xpEarned: earnedXP
            )
        }

        // Mark sub-category as complete
        if let progressService = appState.progressService {
            progressService.completeSubCategory(subCategory, for: profile)
        }

        // Update daily focus completion if this matches today's focus
        let today = Calendar.current.startOfDay(for: Date())
        if let focusDate = profile.dailyFocusDate,
           Calendar.current.isDate(focusDate, inSameDayAs: today),
           profile.dailyFocusSubCategoryId == subCategory.id {
            profile.dailyFocusCompleted = true
        }

        // Check for badges
        if let badgeService = appState.badgeService,
           let category = subCategory.parentCategory {
            badgeService.checkAndAwardBadges(for: profile, category: category)
        }

        // Save context
        try? context.save()
    }

    private func calculateXP() -> Int {
        var totalXP = 0
        for (index, isCorrect) in correctAnswers.enumerated() {
            if isCorrect, index < challenges.count {
                totalXP += challenges[index].xpReward
            }
        }
        return totalXP
    }

    // MARK: - Reset

    func resetQuiz() {
        currentQuestionIndex = 0
        userAnswers = []
        correctAnswers = []
        showFeedback = false
        isCorrect = false
        isQuizComplete = false
        livesRemaining = 3
        isGameOver = false
        wrongAnswerChallenges = []
    }

    // MARK: - Retry Mistakes

    var canRetryMistakes: Bool {
        !wrongAnswerChallenges.isEmpty
    }

    func createRetryQuiz() -> QuizViewModel? {
        guard canRetryMistakes else { return nil }

        // Create a new quiz with only the wrong answers
        let retryViewModel = QuizViewModel(
            subCategory: subCategory,
            context: context,
            appState: appState,
            retryingChallenges: wrongAnswerChallenges
        )
        return retryViewModel
    }

    // Alternate initializer for retry mode
    init(subCategory: SubCategory, context: ModelContext, appState: AppState, retryingChallenges: [Challenge]) {
        self.subCategory = subCategory
        self.challenges = retryingChallenges.shuffled()
        self.context = context
        self.appState = appState
    }
}
